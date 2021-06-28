import 'package:flutter/material.dart';
import 'app/synced_tree/synced_tree.dart';
import 'app/tree/tree.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sample Tree App'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TreeHeading(text: 'Standard Tree'),
              Tree(),
              SizedBox(
                height: 50,
              ),
              TreeHeading(text: 'Synced Tree'),
              SyncedTree(),
            ],
          ),
        ),
      ),
    );
  }
}

class TreeHeading extends StatelessWidget {
  final String text;
  TreeHeading({this.text});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle headingStyle = theme.textTheme.headline6;
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.grey[300],
            padding: EdgeInsets.all(8.0),
            child: Text(
              text,
              style: headingStyle,
            ),
          ),
        ),
      ],
    );
  }
}
