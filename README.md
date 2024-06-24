# CC SignalR for Flutter

CC SignalR is a plugin that provides SignalR support for Flutter applications. This plugin makes it easy to manage SignalR connections and communicate using an event-driven approach.

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  cc_signalr: ^1.0.0
```

Then, run the following command in the terminal to load the dependencies:

```sh
flutter pub get
```

## Usage

### 1. Define Connection Options

Use the `init` method to add the necessary modules. Define the connection options and configurations directly within this method.

```dart
import 'package:cc_signalr/cc_signalr.dart';
void main() {
  CCSignalR.init(
    connectionOptions: HttpConnectionOptions(
      skipNegotiation: true,
      transport: HttpTransportType.WebSockets,
      logMessageContent: false,
    ),
    signalROptions: CCSignalROptions(
      url: "https://example.com/signalrHub",
      autoReconnect: true,
      hubProtocol: JsonHubProtocol(),
      onConnected: (HubConnection connection) async {
        print("Connected");
      },
      onDisconnected: (value) {
        print("Disconnected");
      },
      onReconnected: (value) {
        print("Reconnected");
      },
    ),
    loggingOptions: CCSignalRLogging(
      logEnabled: true,
      logLevel: Level.INFO,
    ),
    modules: [
      Example(),
    ],
  );
}
```

### 2. Using Modules

You can use your example module to receive and manage messages over SignalR.

```dart
void main() {
  // Other initialization code...

  // Start the connection
  CCSignalR.connect();

  // Subscribe to the module
  CCSignalR.getModule<Example>().subscribe();

  // Unsubscribe from the module
  CCSignalR.getModule<Example>().unsubscribe();
}
```

### Create Your Own Module

The `HUBModule` class is inherited to listen for a specific SignalR message. This class listens for messages coming over SignalR and prints these messages to the console. You can create your own module by defining a class like this:

```dart
import 'package:cc_signalr/src/modules/hub_module.dart';

class Example extends HUBModule {
  Example() : super("receiveMainPageStream");

  @override
  void listen(List<Object?>? parameters) {
    print("Broadcast : " + parameters.toString());
  }
}
```

### Example Code

Below is the complete example code:

```dart
void main() {
  CCSignalR.init(
    connectionOptions: HttpConnectionOptions(
      skipNegotiation: true,
      transport: HttpTransportType.WebSockets,
      logMessageContent: false,
    ),
    signalROptions: CCSignalROptions(
      url: "https://example.com/signalrHub",
      autoReconnect: true,
      hubProtocol: JsonHubProtocol(),
      onConnected: (HubConnection connection) async {
        String connectionId = await connection.invoke("getConnectionId") as String;
        print("Connected : " + connectionId);
      },
      onDisconnected: (value) {
        print("Disconnected");
      },
      onReconnected: (value) {
        print("Reconnected");
      },
    ),
    loggingOptions: CCSignalRLogging(
      logEnabled: true,
      logLevel: Level.INFO,
    ),
    modules: [
      Example(),
    ],
  );

  CCSignalR.connect();

  CCSignalR.getModule<Example>().subscribe();
}
```

#### Explanation

- **Inheritance**: The `Example` class is inherited from the `HUBModule` class. This means that the `Example` class inherits all the properties and methods of the `HUBModule` class.
- **Constructor**: The constructor of the `Example` class calls the constructor of the `HUBModule` class with the `"receiveMainPageStream"` parameter. This means that the `Example` class will listen to the `"receiveMainPageStream"` message.
- **`listen` Method**: This method listens for messages coming from SignalR. The `parameters` parameter contains the content of the message from SignalR, and this content is printed to the console.

## Contributing

If you would like to contribute to this project, please send a pull request or open an issue.

## License

This project is licensed under the MIT License. For more information, see the `LICENSE` file.