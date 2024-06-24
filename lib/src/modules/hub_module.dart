import 'package:cc_signalr/src/cc_signalr.dart';
import 'package:cc_signalr/src/handlers/i_hub_handler.dart';

abstract class HUBModule implements IHUBHandler {
  String key;

  HUBModule(this.key);

  @override
  void subscribe() {
    CCSignalR.hubConnection.off(key);
    CCSignalR.hubConnection.on(key, listen);
  }

  @override
  void unsubscribe() {
    CCSignalR.hubConnection.off(key);
  }
}
