import 'package:bet/config/config.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketSingleton {
  static Socket? socket;

  static final SocketSingleton _instance = SocketSingleton._internal();

  factory SocketSingleton() {
    return _instance;
  }

  SocketSingleton._internal() {
    socket = io(
        AddressConfig.socketBaseUrl,
        OptionBuilder()
            .setTransports(['websocket'])
            // .enableForceNew()
            .disableAutoConnect()
            .enableForceNew()
            .enableForceNewConnection()
            .enableReconnection()
            // .setReconnectionAttempts(5)
            .build());
  }

  Socket getSocketInstance() {
    return socket!;
  }

// static Singleton get instance {
//   if (_instance == null) {
//     _instance = Singleton._internal();
//   }
//   return _instance;
// }
}
