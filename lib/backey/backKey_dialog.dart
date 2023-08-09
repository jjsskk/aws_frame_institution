import 'package:flutter/material.dart';

class GlobalBackKeyDialog {
  static Future<bool> getBackKeyDialog(BuildContext context) async {
    return await showDialog(
            context: context,
            useRootNavigator: false,
            // without this, info.ifRouteChanged(context) dont recognize context change. check page stack
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('끝내겠습니까?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text('네')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text('아니요'))
                ],
              );
            }) ??
        Future(() => true);
  }
}
