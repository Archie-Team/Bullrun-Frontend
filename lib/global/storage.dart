import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Storage {
  static RxBool isTokenSaved = false.obs;
}

Future<void> saveValue(String key, dynamic value) async {
  final box = GetStorage();
  return box.write(key, value);
}

Future<bool> isContainKey(String key) async {
  final box = GetStorage();
  return box.hasData(key);
}

Future<dynamic> getValue(String key) async {
  final box = GetStorage();
  return box.read(key);
}

Future<dynamic> removeValue(String key) async {
  final box = GetStorage();
  return box.remove(key);
}

void clearAll() async {
  final box = GetStorage();
  await box.erase();
}
