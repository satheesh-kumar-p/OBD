// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';

// class ChecksumPacket {
//   final DateTime timestamp;
//   final Uint8List data;
//   final InternetAddress sourceAddress;
//   final int sourcePort;

//   ChecksumPacket({
//     required this.timestamp,
//     required this.data,
//     required this.sourceAddress,
//     required this.sourcePort,
//   });
// }

// class ChecksumListener {
//   RawDatagramSocket? _socket;
//   StreamSubscription<RawSocketEvent>? _subscription;
//   final StreamController<ChecksumPacket> _controller =
//       StreamController<ChecksumPacket>.broadcast();
//   bool _isRunning = false;

//   Stream<ChecksumPacket> get packets => _controller.stream;

//   Future<void> start({
//     required int listenPort,
//     InternetAddress? bindAddress,
//   }) async {
//     if (_isRunning) await stop();

//     final socket = await RawDatagramSocket.bind(
//       bindAddress ?? InternetAddress.anyIPv4,
//       listenPort,
//       reuseAddress: true,
//     );
//     _socket = socket;
//     _isRunning = true;
//     _subscription = socket.listen(_handleSocketEvent);
//   }

//   void _handleSocketEvent(RawSocketEvent event) {
//     if (event != RawSocketEvent.read) return;
//     final datagram = _socket?.receive();
//     if (datagram == null || _controller.isClosed) return;

//     _controller.add(
//       ChecksumPacket(
//         timestamp: DateTime.now(),
//         data: datagram.data,
//         sourceAddress: datagram.address,
//         sourcePort: datagram.port,
//       ),
//     );
//   }

//   Future<void> stop() async {
//     _isRunning = false;
//     await _subscription?.cancel();
//     _subscription = null;
//     _socket?.close();
//     _socket = null;
//   }

//   Future<void> dispose() async {
//     await stop();
//     await _controller.close();
//   }
// }