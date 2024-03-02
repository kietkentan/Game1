import 'package:flutter/cupertino.dart';

import '../extension/extensions.dart';
import '../extension/shared_preference_helper.dart';


class AppState extends ChangeNotifier {
  int level = -1;
  int thisLevel = 0;
  int sound = 0;
  int bg = 1;

  int gun = 1;
  int coin = -1;
  int fish = 0;

  int kill = 0;
  double time = 0;
  bool isPlay = false;
  bool isAdd = true;

  resetGame(int l) {
    thisLevel = l;
    fish = 0;
    if (thisLevel > 100) {
      kill = 250;
      time = 600000;
    } else if (thisLevel > 50) {
      kill = 200;
      time = 300000;
    } else if (thisLevel > 25) {
      kill = 100;
      time = 180000;
    } else if (thisLevel > 10) {
      kill = 75;
      time = 120000;
    } else if (thisLevel > 5) {
      kill = 50;
      time = 60000;
    } else if (thisLevel > 0) {
      kill = thisLevel * 10;
      time = 60000;
    } else {
      kill = 5;
      time = 10000;
    }
    bg = thisLevel % 5 + 1;
    isPlay = true;
    notifyListeners();
  }

  addGun() {
    gun += 1;
    if (gun > 3) {
      gun = 3;
    }
  }

  subGun() {
    gun -= 1;
    if (gun < 1) {
      gun = 1;
    }
  }

  getValue() {
    getCoin();
    getSound();
    getLevel();
  }

  bool subCoin() {
    if (coin >= gun) {
      coin -= gun;
      return true;
    }
    return false;
  }

  getLevel() async {
    level = await getIt<SharedPreferenceHelper>()
        .getLevel()
        .then((value) => value);
  }

  saveLevel(int lv) {
    level = lv;
    try {
      getIt<SharedPreferenceHelper>().saveLevel(lv);
    } catch (error) {
      print('ErrorInNumberState: $error');
    }
    notifyListeners();
  }

  getCoin() async {
    coin = await getIt<SharedPreferenceHelper>()
        .getCoin()
        .then((value) => value);
    notifyListeners();
  }

  saveCoin() {
    if (coin <= 1) {
      coin = 1000;
    }
    try {
      getIt<SharedPreferenceHelper>().saveCoin(coin);
    } catch (error) {
      print('ErrorInNumberState: $error');
    }
  }


  getSound() async {
    sound = await getIt<SharedPreferenceHelper>()
        .getSound()
        .then((value) => value);
  }

  saveSound(int s) {
    sound = s;
    try {
      getIt<SharedPreferenceHelper>().saveSound(s);
    } catch (error) {
      print('ErrorInNumberState: $error');
    }
    notifyListeners();
  }
}