import 'package:aws_frame_institution/home/home_page.dart';
import 'package:aws_frame_institution/storage/storage_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class LoginSession extends StatefulWidget {

  final VoidCallback shouldLogOut;

  LoginSession({Key? key, required this.shouldLogOut}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginSessionState();
}

class _LoginSessionState extends State<LoginSession> {


  List<MaterialPage> get _pages {
    return [
      MaterialPage(
          child: HomePage(
              shouldLogOut: widget.shouldLogOut
      )),

    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey()
  @override
  Widget build(BuildContext context) {
    return Navigator(
      // key: navigatorKey,
      pages: _pages,
      onPopPage: (route, result) => route.didPop(result),
    );
  }

}
