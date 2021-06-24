import 'package:flutter/material.dart';
import 'package:general_widgets/general_widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconTextButton(
                      image: Image.network(
                        'https://robohash.org/YOUR-TEXT.png',
                        height: 50,
                      ),
                      label: 'Edit',
                      toolTip: 'Edit item',
                      highlightColor: Colors.deepOrangeAccent,
                    ),
                    IconTextButton(
                      icon: Icons.edit,
                      iconSize: 50,
                      label: 'Edit',
                      onTap: () async {},
                      toolTip: 'Edit item',
                    ),
                    IconTextButton(
                      icon: Icons.edit,
                      onTap: () async {},
                    ),
                    IconTextButton(
                      icon: Icons.edit,
                      label: 'Edit',
                      onTap: () async {},
                      toolTip: 'Edit item',
                    ),
                    IconTextButton(
                      icon: Icons.edit,
                      iconColor: Colors.blue,
                      label: 'Edit',
                      disabledIconColor: Colors.red,
                      disabledTextColor: Colors.orange,
                    ),
                    IconTextButton(
                      icon: Icons.edit,
                      label: 'Edit',
                      onTap: () async {
                        await Future.delayed(Duration(milliseconds: 1000));
                      },
                      toolTip: 'Edit item',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
