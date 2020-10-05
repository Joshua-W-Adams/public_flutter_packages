library auth_widgets;

import 'package:flutter/material.dart';
import 'package:general_widgets/general_widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// [AuthWidget] Builds the signed-in or non signed-in UI, depending on the the
/// response from the authention service onAuthStateChanged stream. Expecting a
/// null auth user object on failed authorisation and non null for passed user
/// authorisation. Also allows injection of a multiprovider if authorisation
/// specific services need to be created.
/// Notes:
/// The generic dart type variables E, T, S, K and V can be passed to a function
/// or class using the triangle bracket <> notation. This class accepts the
/// generic type parameter <T> which is used to define the type of user model
/// that the authentication stream returns. This allows all functions and
/// varaibles within to have access to the passed type.
class AuthWidget<T> extends StatelessWidget {
  final Stream<T> authStream;
  final List<SingleChildWidget> Function(BuildContext, AsyncSnapshot<T>)
      multiProviderBuilder;
  final Widget Function(BuildContext) nonSignedInBuilder;
  // callback function to conduct additional verification checks. For example
  // email verification or 2FA.
  final bool Function(BuildContext, AsyncSnapshot<T>) additionalAuthChecks;
  final Widget Function(BuildContext, AsyncSnapshot<T>)
      additionalAuthChecksFailedBuilder;
  final Widget Function(BuildContext, AsyncSnapshot<T>) signedInBuilder;
  final Function authServiceDownFunction;

  const AuthWidget({
    Key key,
    @required this.authStream,
    this.multiProviderBuilder,
    @required this.nonSignedInBuilder,
    @required this.additionalAuthChecks,
    @required this.additionalAuthChecksFailedBuilder,
    @required this.signedInBuilder,
    @required this.authServiceDownFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: authStream,
      builder: (context, snapshot) {
        // only attempt to load signed in or non sign in widgets after the
        // authentication stream has been initialised to prevent unnecessary
        // widget builds
        if (snapshot.connectionState == ConnectionState.active) {
          // user has been authentication onto the system with authentication service
          if (snapshot.hasData == true) {
            // conduct additional authentication checks
            bool verified = additionalAuthChecks is Function
                ? additionalAuthChecks(context, snapshot)
                : true;
            if (verified) {
              if (multiProviderBuilder is Function) {
                return MultiProvider(
                  providers: multiProviderBuilder(context, snapshot),
                  child: signedInBuilder(context, snapshot),
                );
              }
              return signedInBuilder(context, snapshot);
            }
            return additionalAuthChecksFailedBuilder(context, snapshot);
          }
          return nonSignedInBuilder(context);
        }
        // pending authentication connection screen in case of errors with auth
        // service availability
        return Awaiting(
          headerText: 'Awaiting user authentication...',
          footerTextOnTap: authServiceDownFunction,
        );
      },
    );
  }
}

/// [UserManagementWidget] builds ui's based on verification checks to the user
/// model injected. Also allows creation of user-dependent objects that need to
/// be accessible by all widgets. Generic type <T> indicates the application
/// specific user model to that will be returned by the user profile stream.
class UserManagementWidget<T> extends StatelessWidget {
  final Stream<T> userProfileStream;
  final List<SingleChildWidget> Function(BuildContext, AsyncSnapshot<T>)
      multiProviderBuilder;
  // callback function to conduct various verification checks that will allow
  // the user to access the application or enforce additional user input. For
  // example, email verification, onboarding or subscriptions.
  final bool Function(BuildContext, AsyncSnapshot<T>) verificationChecks;
  // ui element to return based on the failed checks
  final Widget Function(BuildContext, AsyncSnapshot<T>)
      verificationFailedBuilder;
  // ui element to return if all checks have passed
  final Widget Function(BuildContext, AsyncSnapshot<T>)
      verificationPassedBuilder;
  // function to be called if the user profile stream is down
  final Function userProfileServiceDownFunction;

  const UserManagementWidget({
    Key key,
    @required this.userProfileStream,
    this.multiProviderBuilder,
    @required this.verificationChecks,
    @required this.verificationFailedBuilder,
    @required this.verificationPassedBuilder,
    @required this.userProfileServiceDownFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: userProfileStream,
      builder: (context, snapshot) {
        // check that the user profile stream service is up
        if (snapshot.connectionState == ConnectionState.active) {
          // check user profile has been parsed correctly and has data
          if (snapshot.data != null) {
            // commence user profile verification checks
            bool verified = verificationChecks is Function
                ? verificationChecks(context, snapshot)
                : true;
            if (verified) {
              if (multiProviderBuilder is Function) {
                return MultiProvider(
                  providers: multiProviderBuilder(context, snapshot),
                  child: verificationPassedBuilder(context, snapshot),
                );
              }
              return verificationPassedBuilder(context, snapshot);
            }
            return verificationFailedBuilder(context, snapshot);
          }
          return Awaiting(
            headerText: 'Awaiting non null user profile...',
            footerTextOnTap: userProfileServiceDownFunction,
          );
        }
        // awaiting user profile service
        return Awaiting(
          headerText: 'Awaiting user authentication...',
          footerTextOnTap: userProfileServiceDownFunction,
        );
      },
    );
  }
}
