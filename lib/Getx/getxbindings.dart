
import 'package:get/get.dart';
import 'package:rjwada/Getx/getx_controller.dart';

class GetxBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DataController());
    // TODO: implement dependencies
  }

}