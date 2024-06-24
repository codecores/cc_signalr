import 'package:cc_signalr/src/provider/example.dart';
import 'package:cc_signalr/src/cc_signalr_options.dart';
import 'package:cc_signalr/src/modules/hub_module.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/web_supporting_http_client.dart';

class CCSignalR {
  static bool _connected = false;

  static bool isConnected() => _connected;

  static void setConnectState(bool value) => _connected = value;

  static Map<String, dynamic> _instances = <String, dynamic>{};

  static late HttpConnectionOptions connectionOptions;

  static late CCSignalROptions signalROptions;

  static late CCSignalRLogging loggingOptions;

  static HubConnectionBuilder? _hubConnectionBuilder;
  static late HubConnection hubConnection;
  static var _hubProtLogger;
  static var _transportProtLogger;

  static void init({
    required HttpConnectionOptions connectionOptions,
    required CCSignalROptions signalROptions,
    CCSignalRLogging? loggingOptions,
    required List<dynamic> modules,
  }) {
    CCSignalR.signalROptions = signalROptions;

    CCSignalR.loggingOptions =
        loggingOptions ?? CCSignalRLogging(logEnabled: false);

    Logger.root.level = loggingOptions!.logLevel;
    Logger.root.onRecord.listen(
      (LogRecord rec) {
        if (loggingOptions.logEnabled) {
          print('CC-SIGNALR -> ${rec.level.name}: ${rec.time}: ${rec.message}');
        }
      },
    );

    for (HUBModule module in modules) {
      register(module);
    }

    _hubProtLogger = Logger("SignalR - hub");
    _transportProtLogger = Logger("SignalR - transport");

    connectionOptions.httpClient =
        WebSupportingHttpClient(_transportProtLogger);
    connectionOptions.logger = _transportProtLogger;

    _hubConnectionBuilder = HubConnectionBuilder()
        .withUrl(
          signalROptions.url,
          options: connectionOptions,
          transportType: signalROptions.transportType,
        )
        .configureLogging(_hubProtLogger)
        .withHubProtocol(signalROptions.hubProtocol!);

    if (signalROptions.autoReconnect!) {
      _hubConnectionBuilder!.withAutomaticReconnect(
        reconnectPolicy: SignalRRetryPolicy(),
      );
    }

    hubConnection = _hubConnectionBuilder!.build();
  }

  static void connect() async {
    await hubConnection.start();

    hubConnection.onreconnected(
      ({String? connectionId}) async {
        if (signalROptions.onReconnected != null) {
          signalROptions.onReconnected!(connectionId);
        }
      },
    );

    hubConnection.onclose(
      ({Exception? error}) {
        if (signalROptions.onDisconnected != null) {
          signalROptions.onDisconnected!(error);
        }
      },
    );

    if (signalROptions.onConnected != null) {
      signalROptions.onConnected!(hubConnection);
    }
  }

  static void register<T>(HUBModule instance) {
    CCSignalR._instances[instance.key] = instance;
  }

  static T getModule<T>() {
    final instance = _instances[T.runtimeType.toString()];

    if (instance != null) {
      return instance as T;
    }
    return Example() as T;
  }
}
