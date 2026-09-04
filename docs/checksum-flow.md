# Checksum Flow for Own App and UDP Heartbeats

This document explains how the application gets:

1. its own build version and checksum
2. remote app status data over UDP
3. the data displayed in the checksum UI screen

It also documents the exact flow used for the current implementation.

---

## 1) Own app version

The version is taken from Git at build time.

### Build command

```bash
cd "/home/prime/Desktop/scout-td0-OBD 2/scout-td0-OBD"

export APP_VERSION=$(git describe --tags --always --dirty)

docker build \
  --build-arg APP_NAME=scout_display \
  --build-arg APP_VERSION="$APP_VERSION" \
  -t scout-td0-obd:latest .
```

### Why this is used

- `git describe --tags --always --dirty` gives the current tag if available
- if no tag exists, it falls back to the current commit hash
- this ensures the image version is always attached to the build

### Where it is consumed

In the Dockerfile:

```dockerfile
ARG APP_NAME=scout_display
ARG APP_VERSION=dev

RUN flutter build linux --release \
    --dart-define=APP_NAME=${APP_NAME} \
    --dart-define=APP_VERSION=${APP_VERSION}
```

And in Dart:

```dart
static const String appVersion = String.fromEnvironment(
  'APP_VERSION',
  defaultValue: 'unknown',
);
```

This is implemented in:

- `lib/core/comm/checksum/checksum_self_info_loader.dart`

---

## 2) Own app checksum

The checksum for the running application should be the Docker image checksum, not the app bundle hash.

### Command to get the running image checksum

```bash
docker inspect --format='{{index .RepoDigests 0}}' scout-td0-obd:latest
```

Example output:

```bash
scout-td0-obd@sha256:ff749ace15c1aaecee940c4e11eeb63675e0354b00207fe6f45c3f33087406a2
```

If you want only the digest part:

```bash
docker inspect --format='{{index .RepoDigests 0}}' scout-td0-obd:latest | sed 's/.*@//'
```

Example:

```bash
sha256:ff749ace15c1aaecee940c4e11eeb63675e0354b00207fe6f45c3f33087406a2
```

### Inject into the running container

```bash
DIGEST=$(docker inspect --format='{{index .RepoDigests 0}}' scout-td0-obd:latest | sed 's/.*@//')

docker run --rm -it \
  --net=host \
  --ipc=host \
  -e DISPLAY=$DISPLAY \
  -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
  -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
  -e APP_VERSION="$(git describe --tags --always --dirty)" \
  -e APP_CHECKSUM="$DIGEST" \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY":"$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" \
  --device /dev/dri \
  scout-td0-obd:latest \
  /app/scout_display
```

### How the app reads it

In `checksum_self_info_loader.dart`:

```dart
static const String appVersionEnvVar = 'APP_VERSION';
static const String imageChecksumEnvVar = 'APP_CHECKSUM';

final envVersion = Platform.environment[appVersionEnvVar];
final envChecksum = Platform.environment[imageChecksumEnvVar];
```

Then a self-status row is created:

```dart
_cached = ChecksumStatusEntity(
  appName: appName,
  version: version,
  checksum: checksum,
  ...
);
```

This is the row shown in the checksum UI for this app itself.

---

## 3) Remote apps over UDP

This is the path used for heartbeat/status packets from other apps. The
checksum heartbeat and the CAN data both originate from the same physical
server, `AppConstants.remoteServerIp` (`10.10.60.91`). They use different
local destination ports because CAN frames and checksum heartbeats have
different payload formats.

### UDP port used

The checksum UDP listener is configured in:

- `lib/core/constants/app_constants.dart`

```dart
static const int checksumListenPort = 49152;
```

This is the local port on which the app expects incoming checksum packets from
the shared remote server.

### Data format

Remote apps send JSON packets shaped like:

```json
{
  "app_name": "scout_display",
  "version": "v1.0.0-rc-1-dirty",
  "checksum": "sha256:..."
}
```

The app then parses this JSON and creates a `ChecksumStatusEntity`.

### Flow

- UDP packet arrives on local port `49152`
- datagram is received by the listener
- raw bytes are decoded as UTF-8 JSON
- `ChecksumStatusMapper.fromBytes()` converts JSON to `ChecksumStatusEntity`
- the notifier keeps the latest entity per app
- the checksum screen displays one row per app

Relevant files:

- `lib/core/comm/checksum/checksum_listener.dart`
- `lib/core/comm/checksum/checksum_json_parser.dart`
- `lib/core/comm/checksum/checksum_status_mapper.dart`
- `lib/features/checksum/presentation/state/checksum_status_notifier.dart`
- `lib/features/checksum/presentation/screens/checksum_status_screen.dart`

---

## 4) Self app vs remote UDP flow

There are two different sources of checksum data:

### A. Self app checksum

This is not received over UDP.

It comes from:

- Git tag at build time for version
- Docker repo digest at runtime for checksum
- passed as environment variables into the app

Example:

```bash
APP_VERSION=$(git describe --tags --always --dirty)
DIGEST=$(docker inspect --format='{{index .RepoDigests 0}}' scout-td0-obd:latest | sed 's/.*@//')
```

Then:

```bash
-e APP_VERSION="$APP_VERSION" \
-e APP_CHECKSUM="$DIGEST"
```

### B. Remote app checksum over UDP

This is received from another app, over network UDP.

Example flow:

```text
Other App -> UDP Packet on 49152 -> ChecksumListener -> JSON Parser -> Mapper -> Status Entity -> UI
```

---

## 5) Final UI behavior

The checksum screen shows rows for each app with:

- app name
- version
- checksum string

It is built by:

- `ChecksumStatusNotifier`
- `ChecksumStatusScreen`

The screen sorts the list and renders one status card per app.

---

## 6) Flowchart

```mermaid
flowchart TD
    A[Git tag / commit] --> B[Docker build with APP_VERSION]
    B --> C[Flutter binary compiled with APP_VERSION]

    D[Docker image digest] --> E[Get via docker inspect RepoDigests]
    E --> F[Inject into container as APP_CHECKSUM]
    F --> G[ChecksumSelfInfoLoader.load()]
    G --> H[Create self ChecksumStatusEntity]
    H --> I[Display self row in checksum screen]

    J[Other app sends JSON heartbeat] --> K[UDP packet arrives on port 49152]
    K --> L[ChecksumListener receives datagram]
    L --> M[ChecksumJsonParser decodes JSON]
    M --> N[ChecksumStatusMapper builds entity]
    N --> O[Notifier stores latest status per app]
    O --> P[ChecksumStatusScreen renders rows]

    Q[User opens checksum screen] --> P
```

---

## 7) Summary

The system has two checksum sources:

1. Own app identity
   - version = Git tag at build time
   - checksum = Docker repo digest at runtime
   - injected via environment variables

2. Remote app heartbeat data
   - received over UDP on port `49152`
   - decoded and mapped to UI entities

This is exactly how the checksum screen is meant to show both:

- the current app itself
- and all remote apps sending heartbeat status packets
