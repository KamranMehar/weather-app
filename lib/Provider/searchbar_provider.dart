

import 'package:flutter/cupertino.dart';

class SearchBarProvider with ChangeNotifier{
  bool showSearchBar=false;

  setShowSearchBar(){
    showSearchBar=!showSearchBar;
    notifyListeners();
  }

  clearSearchText(){
    notifyListeners();
  }
}