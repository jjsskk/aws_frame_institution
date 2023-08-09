import 'package:flutter/material.dart';


class KeyForBottomAppbar {
 final GlobalKey<ScaffoldState> _key = GlobalKey(); //used for bottomappbar

  GlobalKey<ScaffoldState> get key => _key;

  // GlobalKey<ScaffoldState> getKey()
  // {
  //   return GlobalKey();
  // }
}