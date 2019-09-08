import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _singleton = LocalStorage._init();

  static LocalStorage get instance => _singleton;

  SharedPreferences _prefs;

  SharedPreferences get prefs => _prefs;

  LocalStorage._init() {
    print('init');
    initStore();
  }

  initStore() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
