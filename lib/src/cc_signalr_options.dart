import 'package:logging/logging.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/iretry_policy.dart';
import 'package:signalr_netcore/itransport.dart';
import 'package:signalr_netcore/json_hub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';

class CCSignalROptions {
  String url;

  HttpTransportType? transportType;
  bool? autoReconnect = true;
  Function(HubConnection connection)? onConnected;
  Function(String?)? onReconnected;
  Function(Exception?)? onDisconnected;
  IHubProtocol? hubProtocol = JsonHubProtocol();

  CCSignalROptions({
    required this.url,
    this.autoReconnect,
    this.transportType,
    this.hubProtocol,
    this.onConnected,
    this.onReconnected,
    this.onDisconnected,
  }) {}
}

class CCSignalRLogging {
  bool logEnabled = true;
  Level? logLevel = Level.ALL;

  CCSignalRLogging({
    required this.logEnabled,
    this.logLevel,
  });
}

class SignalRRetryPolicy extends IRetryPolicy {
  @override
  int? nextRetryDelayInMilliseconds(RetryContext retryContext) {
    return 3;
  }
}
