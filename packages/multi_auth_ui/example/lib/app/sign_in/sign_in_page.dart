import 'package:flutter/foundation.dart';
import 'package:example/router/public_route_names.dart';
import 'package:flutter/material.dart';
import 'package:multi_auth_ui/multi_auth_ui.dart';

class SignInPageBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInPage(
      appIconFilePath: 'assets/img/app_icon.png',
      appIconHeight: 75,
      appIconWidth: 75,
      appTextFilePath: null,
      appTextHeight: 0,
      authProviders: kIsWeb == true
          ? [
              'password',
              'google.com',
            ]
          : ['password', 'google.com', 'apple.com'],
      emailSignInCallback: () {
        final navigator = Navigator.of(context);
        navigator.pushNamed(
          PublicRoutes.signInEmailPassword,
        );
      },
      // signInAnonymously: () {
      //   return auth.signInAnonymously();
      // },
      // signInWithGoogle: () {
      //   return auth.signInWithGoogle();
      // },
      // signInWithFacebook: () async {
      //   return auth.signInWithFacebook();
      // },
      // signInWithApple: () {
      //   return auth.signInWithApple();
      // },
      // linkCredentialsCallback: (credentials) {
      //   final navigator = Navigator.of(context);
      //   navigator.pushNamed(
      //     PublicRoutes.linkAuthProviders,
      //     arguments: credentials,
      //   );
      // },
      privacyPolicyCallback: () {
        final navigator = Navigator.of(context);
        navigator.pushNamed(PublicRoutes.privacyPolicy);
      },
      billingTermsCallback: () {
        final navigator = Navigator.of(context);
        navigator.pushNamed(PublicRoutes.billingTerms);
      },
      termsOfUseCallback: () {
        final navigator = Navigator.of(context);
        navigator.pushNamed(PublicRoutes.termsOfUse);
      },
    );
  }
}
