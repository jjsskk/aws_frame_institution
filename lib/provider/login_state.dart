import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoginState extends ChangeNotifier {

  //announcement
  bool _isannounceUpdated = false;

  bool get isannounceUpdated => _isannounceUpdated;

  void announceUpdate() {
    print("announce update");
    _isannounceUpdated = !_isannounceUpdated;
    notifyListeners(); // 프로바이더 변경 사항을 감지하는 리스너들에게 알립니다.
  }

  //news
  bool _isnewsUpdated = false;

  bool get isNewsUpdated => _isnewsUpdated;

  void newsUpdate() {
    print("news update");
    _isnewsUpdated = !isNewsUpdated;
    notifyListeners(); // 프로바이더 변경 사항을 감지하는 리스너들에게 알립니다.
  }

  //comment
  void Function(String userId)? _detectCommentChange =
      null;

  Function(String userId)? get detectCommentChange =>
      _detectCommentChange;

  set detectCommentChange(Function(String userId)? func) {
    print('register detectCommentChange');
    _detectCommentChange = func;
      // notifyListeners();
  }


}
