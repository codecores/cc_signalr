import 'package:cc_signalr/src/modules/hub_module.dart';

class Example extends HUBModule {
  Example() : super("receiveMainPageStream");

  @override
  void listen(List<Object?>? parameters) {}
}
