import 'package:aws_frame_institution/bottomappbar/globalkey.dart';
import 'package:flutter/material.dart';

class GlobalBottomAppBar extends StatelessWidget {
  GlobalBottomAppBar({required this.keyObj});

  final keyObj;

  // GlobalKey<ScaffoldState> get key => _key;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      // if you want to remove notch, input null
      color: colorScheme.primary,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                // print(keyObj.key);
                keyObj.key.currentState!.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                size: 30,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.adjust,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
