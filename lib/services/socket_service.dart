import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:swiftcare/services/api_service.dart';
import 'package:swiftcare/services/shared_resource.dart';

class SocketService {
  late IO.Socket socket;

  String baseUrl = ApiService.baseUrl;

  Future<void> connect() async {
    final token = await SharedResources().getAccessToken();

    socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print("Socket connected");
    });

    socket.onDisconnect((_) {
      print("Socket disconnected");
    });
  }

  void joinQueueRoom(String shiftId) {
    socket.emit("joinQueueRoom", shiftId);
  }

  void listenQueueUpdates(Function(dynamic) onUpdate) {
    socket.on("queueUpdated", (data) {
      onUpdate(data);
    });
  }

  void dispose() {
    socket.dispose();
  }
}