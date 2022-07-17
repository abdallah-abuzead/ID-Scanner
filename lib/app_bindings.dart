import 'package:get/get.dart';
import 'package:id_scanner/controllers/card_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CardController(), fenix: true);
  }
}
