import 'package:example/router/public_route_names.dart';
import 'package:example/router/route_error_page.dart';
import 'package:example/app/place_holder/place_holder_page.dart';
import 'package:example/app/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:multi_auth_ui/multi_auth_ui.dart';

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    // Widget builder (function that returns a widget) to construct the route page
    WidgetBuilder builder;

    // build different route (page) based on the route passed to the navigator
    switch (settings.name) {
      case PublicRoutes.signInPage:
        builder = (BuildContext context) {
          return SignInPageBuilder();
        };
        break;
      case PublicRoutes.signInEmailPassword:
        builder = (BuildContext context) {
          var emailPasswordSignInBloc = EmailPasswordSignInBloc(
            signInWithEmailAndPassword: (email, password) {
              return;
            },
            createUserWithEmailAndPassword: (email, password) {
              return;
            },
            sendPasswordResetEmail: (email) {
              return;
            },
          );
          return EmailPasswordSignInPageBuilder(
            bloc: emailPasswordSignInBloc,
          );
        };
        break;
      case PublicRoutes.termsOfUse:
        builder = (BuildContext context) {
          return PlaceHolderPage(title: PublicRoutes.termsOfUse);
        };
        break;
      case PublicRoutes.billingTerms:
        builder = (BuildContext context) {
          return PlaceHolderPage(title: PublicRoutes.billingTerms);
        };
        break;
      case PublicRoutes.privacyPolicy:
        builder = (BuildContext context) {
          return PlaceHolderPage(title: PublicRoutes.privacyPolicy);
        };
        break;
      default:
        // If there is no such named route in the switch statement, e.g. /third
        builder = (BuildContext context) {
          return RouteErrorPage();
        };
    }
    // Return a Page Route (or more simply a page to be constructed)
    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}
