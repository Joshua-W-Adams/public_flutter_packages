import 'package:bottom_navigation_material_app/bottom_navigation_material_app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // define all navigation tabs for user
  static final List<NavigationTabModel> navigationTabs = [
    NavigationTabModel(
      title: 'Home',
      icon: Icons.home,
      url: '/home',
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
    NavigationTabModel(
      title: 'Search',
      icon: Icons.search,
      url: '/search',
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
    NavigationTabModel(
      title: 'Profile',
      icon: Icons.person,
      url: '/profile',
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
  ];

  // define route generator to be used for all tab navigator stacks
  final RouteGenerator routeGenerator = RouteGenerator();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationMaterialApp(
      navigationTabs: navigationTabs,
      generateRouteFunction: routeGenerator.generateRoute,
      theme: ThemeData.dark(),
      navigatorBuilder: (_, tabNavigator) {
        return tabNavigator;
      },
    );
  }
}

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    // Widget builder (function that returns a widget) to construct the route page
    WidgetBuilder builder;

    // build different route (page) based on the route passed to the navigator
    switch (settings.name) {
      case '/home':
        builder = (BuildContext context) {
          return SamplePage(name: 'home');
        };
        break;
      case '/search':
        builder = (BuildContext context) {
          return SamplePage(name: 'search');
        };
        break;
      case '/profile':
        builder = (BuildContext context) {
          return SamplePage(name: 'profile');
        };
        break;
      case '/':
        builder = null;
        break;
      default:
        // If there is no such named route in the switch statement
        builder = (BuildContext context) {
          return SamplePage();
        };
    }
    // prevent page being added to default '/' route
    if (builder == null) {
      return null;
    }
    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}

class SamplePage extends StatelessWidget {
  final String name;

  SamplePage({
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RaisedButton(
              child: Text('push new route'),
              onPressed: () {
                Navigator.of(context).pushNamed('/$name');
              },
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) {
                  return Card(
                    child: Text(
                      index.toString(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
