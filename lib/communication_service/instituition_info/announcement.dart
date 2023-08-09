import 'package:flutter/material.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          Text('공지사항')
        ],
      ),
    );
  }
}
