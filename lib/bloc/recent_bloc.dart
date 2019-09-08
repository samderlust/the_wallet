import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_wallet/model/CardModel.dart';
import 'package:the_wallet/resources/db_provider.dart';
import '../resources/local_storage.dart';

class RecentBloc with ChangeNotifier {
  // SharedPreferences store = LocalStorage.instance.prefs;
  List<CardModel> _recentCards = [];
  List<String> _recentList = [];
  List<String> get recentList => _recentList;
  List<CardModel> get recentCards => _recentCards;

  getRecentListFromStorage() async {
    if (_recentCards.length != 0)
      return Future.delayed(Duration(milliseconds: 100), () => recentCards);
    else
      await _updateRecentCardsList();
    return recentCards;
  }

  _updateRecentCardsList() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    var theList = store.getStringList('recentList');
    if (theList != null) _recentList = theList;

    List<CardModel> cardList = [];

    for (String code in _recentList) {
      CardModel card = await DbProvider.db.findCardById(code);
      if (card != null) {
        cardList.add(card);
      }
    }
    _recentCards = cardList;
    notifyListeners();
  }

  addToRecent(String code) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    recentList.remove(code);
    recentList.insert(0, code);
    await store.setStringList('recentList', recentList);
    _updateRecentCardsList();
  }

  removefromRecent(String code) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    recentList.remove(code);
    await store.setStringList('recentList', recentList);
    _updateRecentCardsList();
  }

  clearRecentList() async {
    _recentList = [];
    _recentCards = [];
    SharedPreferences store = await SharedPreferences.getInstance();
    store.remove('recentList');
    notifyListeners();
  }
}
