import 'package:flutter/material.dart';

class PlaceHolderPage extends StatelessWidget {
  final String title;

  PlaceHolderPage({
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      body: Center(
        child: Text('TBC'),
      ),
    );
  }
}
