import 'package:flutter/material.dart';
import 'package:the_wallet/model/CardModel.dart';
import '../model/CardModel.dart';
import '../resources/db_provider.dart';

class CodeBloc with ChangeNotifier {
  String _code = '';
  List<CardModel> _codeList = [];

  List<CardModel> _searchList = [];

  String get code => _code;
  List<CardModel> get codeList => _codeList;
  List<CardModel> get searchList => _searchList;

  set code(String code) {
    _code = code;
    notifyListeners();
  }

  update(String code) {
    _code = code;
    notifyListeners();
  }

  addCodeToList(CardModel code) async {
    _codeList.add(code);
    DbProvider.db.addCard(code);
    // notifyListeners();
  }

  removeCard(String uuid) async {
    await DbProvider.db.deleteCard(uuid);
  }

  editCardFromList(CardModel card) async {
    await DbProvider.db.updateCard(card);
  }

  getAllCard() async {
    _codeList = await DbProvider.db.getAllCard();
    notifyListeners();
  }

  findCard(String name) async {
    _searchList = await DbProvider.db.findCardByName(name);
    notifyListeners();
  }

  findCardById(String uuid) async {
    CardModel card = await DbProvider.db.findCardById(uuid);
    return card;
  }

  clearSearchList() {
    _searchList = [];
  }

  clearWallet() async {
    await DbProvider.db.clearDatabase();
    _codeList = [];
  }
}
