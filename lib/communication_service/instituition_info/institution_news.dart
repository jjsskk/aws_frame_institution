import 'package:flutter/material.dart';

class InstitutionNewsPage extends StatelessWidget {
  const InstitutionNewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          Text('기관소식')
        ],
      ),
    );
  }
}
