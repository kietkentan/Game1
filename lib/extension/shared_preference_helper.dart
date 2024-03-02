import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  SharedPreferenceHelper._internal();
  static final SharedPreferenceHelper _singleton =
  SharedPreferenceHelper._internal();

  factory SharedPreferenceHelper() {
    return _singleton;
  }

  Future clearPreferenceValues() async {
    (await SharedPreferences.getInstance()).clear();
  }

  Future<int> getLevel() async {
    int? num = (await SharedPreferences.getInstance())
        .getInt(PreferenceKey.LEVEL.name);
    return num ?? 0;
  }

  Future<bool> saveLevel(int level) async {
    return (await SharedPreferences.getInstance()).setInt(
        PreferenceKey.LEVEL.name, level);
  }

  Future<int> getCoin() async {
    int? num = (await SharedPreferences.getInstance())
        .getInt(PreferenceKey.COIN.name);
    if (num == null || num < 100) {
      num = 1000;
    }
    return num;
  }

  Future<bool> saveCoin(int coin) async {
    return (await SharedPreferences.getInstance()).setInt(
        PreferenceKey.COIN.name, coin);
  }

  Future<int> getSound() async {
    int? num = (await SharedPreferences.getInstance())
        .getInt(PreferenceKey.SOUND.name);
    return num ?? 0;
  }

  Future<bool> saveSound(int s) async {
    return (await SharedPreferences.getInstance()).setInt(
        PreferenceKey.SOUND.name, s);
  }
}

enum PreferenceKey { LEVEL, COIN, SOUND }