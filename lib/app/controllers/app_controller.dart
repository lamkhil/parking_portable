import 'package:get/get.dart';
import 'package:parking_portable/app/data/models/user.dart';

class AppController extends GetxController {
  final user = Rx<User?>(null);
}
