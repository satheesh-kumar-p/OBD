# Checksum UDP Functionality

## Task

The goal was to add a separate checksum/status monitoring path for the app, independent from the main CAN communication flow.

The system must:

- listen for UDP packets on the local port `49152`
- parse the incoming checksum payload as JSON
- map the JSON into a typed application status model
- keep the latest status for each reporting app
- display that data in a dedicated sidebar tab
- avoid interfering with the main CAN transport already handled by the project

## What was completed

This was implemented as a dedicated checksum feature, using the same project pattern already used elsewhere in the app:

- a raw transport listener in the core layer
- a Riverpod provider layer for state access
- a feature UI screen for display
- startup wiring so the listener stays alive for the app lifetime

The implementation is organized as follows:

- `lib/core/comm/checksum/checksum_listener.dart`
  - binds the UDP socket
  - receives raw datagrams
  - emits `ChecksumPacket` objects
- `lib/core/comm/checksum/checksum_json_parser.dart`
  - decodes raw UDP bytes as UTF-8 JSON
- `lib/core/comm/checksum/checksum_status_mapper.dart`
  - converts JSON payloads into a domain entity
- `lib/features/checksum/presentation/state/checksum_status_notifier.dart`
  - keeps the latest checksum status per app
- `lib/features/checksum/presentation/screens/checksum_status_screen.dart`
  - renders the live checksum table in the app UI
- `lib/core/di/injection_container.dart`
  - registers the checksum listener and startup provider
- `lib/core/application/core_controller.dart`
  - keeps the checksum listener alive in the app lifecycle
- `lib/features/home/presentation/screens/home_screen.dart`
  - adds the checksum tab to the sidebar

## Why this approach was chosen

The main reason for keeping checksum handling separate is architecture.

The project already has a dedicated transport pipeline for CAN traffic through the communication manager and dispatcher. That path is designed for the vehicle bus and must remain stable, predictable, and focused on CAN message parsing.

The checksum stream is different:

- it is UDP-based
- it is a diagnostic/status stream
- it does not belong to the CAN frame pipeline
- it needs a simple, isolated listener that can decode heartbeat data without affecting the main communication stack

So the checksum logic was implemented as an independent feature instead of being mixed into the CAN flow. This keeps the application safer, easier to debug, and easier to extend later.

## Main data flow

The packet flow is:

1. A UDP packet arrives on the local port `49152`
2. `ChecksumListener.start()` binds the socket using `RawDatagramSocket.bind(...)`
3. The socket receives a datagram in `_handleSocketEvent()`
4. A `ChecksumPacket` is created with:
   - timestamp
   - source address
   - source port
   - raw payload bytes
5. `checksumStatusNotifierProvider` listens to `checksumListenerProvider.packets`
6. `ChecksumStatusMapper.fromBytes()` decodes the raw data into JSON and then into a `ChecksumStatusEntity`
7. The notifier stores the latest value per app name/version key, so the UI always shows the most recent heartbeat
8. `ChecksumStatusScreen` watches that notifier and renders the latest status rows for each app

## Why this is safe for the project

This design is safe because:

- it does not modify the CAN transport behavior
- it does not touch the message dispatcher or parser used for the main vehicle protocol
- it keeps the checksum listener isolated and independent
- it follows the existing Riverpod-based architecture already used in the app
- it can be started or stopped without interfering with the main communication lifecycle

## Operational expectations

The checksum listener is intended to receive JSON heartbeat packets from the configured local UDP endpoint. Because the socket is bound to the local interface using `InternetAddress.anyIPv4`, it can accept datagrams addressed to the local port regardless of which local interface they arrive on.

If a stricter source filter is needed later, it can be added at the socket-event level before the packet is parsed.

## Summary

The checksum feature was implemented as a modular, separate UDP diagnostics path that matches the project architecture and avoids breaking the main CAN communication logic. The result is a clean, maintainable monitoring screen that shows live checksum status data without changing the underlying communication model.
