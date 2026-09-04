# Checksum Display Functionality

This document explains how checksum and version information is displayed in the Scout OBD application. There are two sources of information:

1. The local Scout OBD application identity.
2. Application status packets received through the shared CAN/checksum UDP socket on port `5005`.

## 1. Local Application Checksum

The local checksum entry represents the running Scout OBD application itself. It is not calculated by hashing the application files while the UI is running.

The application reads its identity in this order:

- First, it checks the runtime environment for `APP_VERSION` and `APP_CHECKSUM`.
- If a version is not available at runtime, it uses the version supplied at build time.
- If no version is available from either source, it displays `dev`.
- The checksum can also come from a build-time value.
- If no checksum value is available, the local entry is not created.

The local entry is created with the name `SCOUT-OBD`. It is seeded into the checksum state when the checksum notifier starts, so it can be displayed without waiting for a UDP packet.

The local source is represented internally as `127.0.0.1:0`, indicating that the information came from the application itself rather than a remote UDP sender.

## 2. Checksum Data Received Through the Shared UDP Socket

The application uses one UDP socket for both CAN frames and checksum/version data:

- Bind address: all IPv4 interfaces (`0.0.0.0`)
- Listening port: `5005`
- Remote CAN endpoint: `10.10.60.91:5001`

Checksum data is not received from a separate port anymore. Both payload types arrive on the same socket and are separated by `CommManager` before parsing.

For every incoming UDP datagram, the first byte is inspected:

- A first byte of `0xAA` identifies a Waveshare-framed CAN packet. It is sent to the CAN frame parser.
- Any other non-empty payload is treated as a checksum/version JSON heartbeat and sent to the checksum stream.

This routing works per datagram because UDP preserves each datagram as an independent message. Checksum bytes are therefore never sent through the CAN frame parser.

## 3. Remote Packet Processing

Each received datagram is processed in these stages:

1. `CommManager` routes the non-CAN datagram to the checksum stream.
2. The raw bytes are decoded as UTF-8 text.
3. The text is parsed as a JSON object.
4. The JSON shape is detected and converted into typed checksum status records.
5. The record extracts the application name, version, checksum, source metadata, and timestamp.
6. Invalid UTF-8, malformed JSON, or unexpected entries are ignored without stopping the checksum stream.

A packet can use either of these supported JSON shapes:

- A flat single-application object containing a top-level `app_name`, `version`, and `checksum`.
- A combined object whose top-level keys represent applications and whose values contain each application's status.

The application creates one status record for a flat packet, or one record for each valid application entry in a combined packet. Application names inside nested objects are preferred; otherwise the top-level object key is used.

## 4. Latest Status Storage

The checksum notifier combines both sources into one status collection:

- The local Scout OBD entry is added first when available.
- Remote entries received from the shared UDP socket on port `5005` are then added or updated.
- Only the latest record for each application and source is kept.
- Repeated heartbeat packets update existing entries instead of creating an unlimited history.

If a remote application reports an `unknown` checksum, that entry remains visible and receives warning styling in the UI.

## 5. Display in the Version Screen

The Version screen watches the checksum notifier and displays the current entries as a list of application status cards.

Each card shows:

- Application name
- Version
- SHA-256 checksum value
- A colored status indicator

Entries are sorted alphabetically by application name. A valid checksum uses the healthy status color, while an unknown checksum uses the warning color.

If no local checksum is configured and no UDP checksum packet has arrived, the screen displays a waiting message.

## 6. File-Wise Flow

### Local identity

`checksum_self_info_loader.dart` reads the local version and checksum values and creates the Scout OBD status record.

### UDP listener and raw packet stream

`comm_manager.dart` creates the UDP transport on port `5005`, routes CAN-framed datagrams to the CAN parser, and exposes other datagrams through the checksum data stream.

`checksum_packet.dart` defines the raw packet passed from the communication layer to the checksum processing layer.

### Decoding and mapping

`checksum_json_parser.dart` converts the received bytes into a JSON object.

`checksum_status_mapper.dart` supports both flat single-application JSON packets and combined multi-application envelopes, then converts them into typed checksum status records.

`checksum_status_entity.dart` stores the version, checksum, source information, timestamps, and warning-state information used by the UI.

### State and UI

`checksum_status_notifier.dart` seeds the local entry, listens for UDP checksum packets, and updates the latest status for each application.

`checksum_providers.dart` exposes the checksum stream and notifier through Riverpod.

`checksum_status_screen.dart` reads the notifier state and renders the application cards on the Version screen.

`home_screen.dart` adds the Version navigation item and places the checksum screen in the application page stack.

## Summary

The local checksum is an application identity supplied through environment or build configuration. Remote checksum information shares the CAN UDP listener at `0.0.0.0:5005` and is separated from CAN frames using the `0xAA` framing byte. Both sources are normalized into the same status model and displayed together on the Version screen.