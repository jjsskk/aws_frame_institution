import 'package:flutter/material.dart';

class ConveniencePage extends StatelessWidget {
  const ConveniencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          Text('편의사항')
        ],
      ),
    );
  }
}
