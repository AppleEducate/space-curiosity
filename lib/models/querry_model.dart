import 'dart:async';

import 'package:scoped_model/scoped_model.dart';

abstract class QuerryModel extends Model {
  List _items = List();
  List _photos = List();
  List snapshot;
  var response;
  bool _loading = true;

  Future refresh() async {
    clearItems();
    await loadData();
    notifyListeners();
  }

  void loadingState(bool state) {
    _loading = state;
    notifyListeners();
  }

  Future loadData();

  List get items => _items;

  List get photos => _photos;

  String getPhoto(index) => _photos[index];

  int get getPhotosCount => _photos.length;

  int get getSize => _items.length;

  dynamic getItem(index) => _items[index];

  bool get isLoading => _loading;

  clearItems() => _items.clear();
}
