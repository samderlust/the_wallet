import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/db_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountBloc with ChangeNotifier {
  String _userName = '';
  int _totalCardsNo;
  bool _isFirstTime = true;

  bool get isFirstTime => _isFirstTime;
  String get userName => _userName;
  int get totalCardsNo => _totalCardsNo;

  set userName(name) => _userName = name;

  getUserName() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    var name = await store.get('userName');
    if (name != null) userName = name;
    notifyListeners();
  }

  setTheName(String name) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    store.setString('userName', name);
    _userName = name;
  }

  getTotalCardNo() async {
    var number = await DbProvider.db.countNumberOfCards();
    _totalCardsNo = number[0]['total'];
    notifyListeners();
  }

  checkIfFistTime() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    var check = store.getBool('isFirstTime');
    if (check != null) _isFirstTime = check;
    return _isFirstTime;
  }

  firstSetup() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    _isFirstTime = false;
    store.setBool('isFirstTime', _isFirstTime);
  }
}
