import 'package:cc_signalr/src/handlers/IHUBHandler.dart';

abstract class HUBModule implements IHUBHandler {
  String key;

  HUBModule(this.key);

  @override
  void request() {
    SocketManager.hubConnection.off(key);
    SocketManager.hubConnection.on(key, listen);
  }
}
