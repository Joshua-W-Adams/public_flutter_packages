import 'package:flutter/material.dart';
import 'package:example/router/public_router.dart';
import 'package:example/app/sign_in/sign_in_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // get instance of route generator
    RouteGenerator _routeGenerator = RouteGenerator();

    return MaterialApp(
      title: 'Example Login UI',
      home: SignInPageBuilder(),
      onGenerateRoute: _routeGenerator.generateRoute,
      builder: (context, child) {
        return SafeArea(
          child: WillPopScope(
            // https://stackoverflow.com/questions/49681415/flutter-persistent-navigation-bar-with-named-routes
            // Will pop scope handles the back button on the physical device.
            onWillPop: () async {
              return !await Navigator.of(context).maybePop();
            },
            child: child,
          ),
        );
      },
    );
  }
}
