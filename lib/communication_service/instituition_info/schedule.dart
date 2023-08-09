import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          Text('시간표')
        ],
      ),
    );
  }
}
