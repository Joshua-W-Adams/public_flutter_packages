library bottom_navigation_material_app;

import 'package:flutter/material.dart';

/// [BottomNavigationMaterialApp] is a material app at this core with the
/// following additional functionality added:
/// 1. Bottom navigation bar
/// 2. Unique navigator for each bot nav bar item
/// 3. Navigators all persist state
class BottomNavigationMaterialApp extends StatefulWidget {
  final List<NavigationTabModel> navigationTabs;

  // route generator used to build all material page routes
  final Route<dynamic>? Function(RouteSettings settings)? generateRouteFunction;

  final ThemeData? theme;

  final Widget Function(NavigationTabModel tab, Navigator tabNavigator)?
      navigatorBuilder;

  BottomNavigationMaterialApp({
    required this.navigationTabs,
    required this.generateRouteFunction,
    this.theme,
    this.navigatorBuilder,
  });

  @override
  _BottomNavigationMaterialAppState createState() =>
      _BottomNavigationMaterialAppState();
}

class _BottomNavigationMaterialAppState
    extends State<BottomNavigationMaterialApp> {
  /// set the current tab to the home page
  int _currentIndex = 0;

  void _select(int index) {
    if (index == _currentIndex) {
      /// case 1 - if user presses on currently selected tab
      /// pop to first route - i.e. ensure no routes are over laid on top of the
      /// current route
      widget.navigationTabs[_currentIndex].navigatorKey.currentState!
          .popUntil((route) {
        return route.isFirst;
      });
    } else {
      // case 2 - user selects any other tab
      // rebuild application state with the newly selected navigation tab
      setState(() {
        _currentIndex = index;
      });
    }
  }

  /// generate a list of navigators that will have their state persisted in an
  /// indexed stack.
  List<Widget> _getPersistantStack() {
    return widget.navigationTabs.map((tab) {
      Navigator tabNavigator = Navigator(
        key: tab.navigatorKey,
        initialRoute: tab.url,
        onGenerateRoute: widget.generateRouteFunction,
      );
      return WillPopScope(
        onWillPop: () async {
          return !await tab.navigatorKey.currentState!.maybePop();
        },
        child: widget.navigatorBuilder != null
            ? widget.navigatorBuilder!(tab, tabNavigator)
            : tabNavigator,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    /// ********************* HOLD POINT *********************
    /// TODO - MaterialApp contains our top-level Navigator. This navigator is
    /// required to enable navigation via urls in flutter web. Likely that this
    /// section requires refractoring in some way to enable url updates from the
    /// nested navigators and hyperlinking from web browsers to specific pages
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: widget.theme,
      home: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            children: _getPersistantStack(),
            index: _currentIndex,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: widget.navigationTabs.map((tab) {
            return BottomNavigationBarItem(
              label: tab.title,
              icon: Icon(tab.icon),
            );
          }).toList(),
          onTap: (int index) {
            _select(index);
          },
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          // hide titles on navigation bar
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}

class NavigationTabModel {
  final String title;
  final IconData icon;
  final String url;
  final GlobalKey<NavigatorState> navigatorKey;

  NavigationTabModel({
    required this.title,
    required this.icon,
    required this.url,
    required this.navigatorKey,
  });
}
