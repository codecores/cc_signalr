# CC SignalR for Flutter

CC SignalR, Flutter uygulamaları için SignalR desteği sağlayan bir eklentidir. Bu eklenti, SignalR bağlantılarını yönetmeyi ve olay tabanlı iletişim kurmayı kolaylaştırır.

## Kurulum

`pubspec.yaml` dosyanıza aşağıdaki bağımlılığı ekleyin:

```yaml
dependencies:
  cc_signalr: ^1.0.0
```

Ardından, bağımlılıkları yüklemek için terminalden aşağıdaki komutu çalıştırın:

```sh
flutter pub get
```

## Kullanım

### 1. Bağlantı Seçeneklerini Tanımlayın

Gerekli modülleri eklemek için `init` metodunu kullanın. Bağlantı seçeneklerini ve yapılandırmaları doğrudan bu metodun içinde tanımlayın.

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

### 2. Modülleri Kullanma

Örnek modülünüzü kullanarak SignalR üzerinden mesajlar alabilir ve yönetebilirsiniz.

```dart
void main() {
  // Diğer başlatma kodları...

  //Bağlantıyı başlatın
  CCSignalR.connect();

  // Modülü abone edin
  CCSignalR.getModule<Example>().subscribe();

  // Modülü abonelikten çıkarın
  CCSignalR.getModule<Example>().unsubscribe();
}
```

### Örnek Kod

Aşağıda, tam örnek kodu bulabilirsiniz:

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

### Create Own Module

`HUBModule` sınıfından türetilmiştir ve belirli bir SignalR mesajını dinlemek için kullanılır. Bu sınıf, SignalR üzerinden gelen mesajları dinler ve bu mesajları konsola yazdırır. You can create your own module by defining a class like this:

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

#### Açıklama

- **Kalıtım**: `Example` sınıfı, `HUBModule` sınıfından türetilmiştir. Bu, `Example` sınıfının `HUBModule` sınıfının tüm özelliklerini ve metodlarını miras aldığı anlamına gelir.
- **Konstruktor**: `Example` sınıfının yapıcı metodu, `HUBModule` sınıfının yapıcı metodunu `"receiveMainPageStream"` parametresi ile çağırır. Bu, `Example` sınıfının `"receiveMainPageStream"` mesajını dinleyeceği anlamına gelir.
- **`listen` Metodu**: Bu metod, SignalR'dan gelen mesajları dinler. `parameters` parametresi, SignalR'dan gelen mesajın içeriğini içerir ve bu içerik konsola yazdırılır.

## Katkıda Bulunma

Bu projeye katkıda bulunmak isterseniz, lütfen bir pull request gönderin veya bir issue açın.

## Lisans

Bu proje MIT lisansı ile lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasına bakın.