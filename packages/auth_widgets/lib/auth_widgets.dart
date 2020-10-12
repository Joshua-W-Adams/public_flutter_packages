library auth_widgets;

import 'package:flutter/material.dart';
import 'package:general_widgets/general_widgets.dart';

/// [AuthWidget] Builds signed-in or non signed-in UIs, depending on the data
/// recieved from the passed stream. Expecting a null auth user object on failed
/// authorisation and non null for passed user authorisation. Also allows
/// additional verification checks to be performed if specified in the
/// appropriate builder functions.
/// Notes:
/// The generic dart type variables E, T, S, K and V can be passed to a function
/// or class using the triangle bracket <> notation. This class accepts the
/// generic type parameter <T> which is used to define the type of user model
/// that the authentication stream returns. This allows all functions and
/// variables within to have access to the passed type.
class AuthWidget<T> extends StatelessWidget {
  final Stream<T> authStream;
  final Widget Function(BuildContext, AsyncSnapshot<T>) nonSignedInBuilder;
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
          if (snapshot.hasError) {
            return ShowError(
              error: snapshot.error.toString(),
              footerText: 'Return to Login Page',
              footerTextOnTap: authServiceDownFunction,
            );
          } else if (snapshot.hasData == true) {
            // user has been authentication onto the system with authentication service
            // conduct additional authentication checks
            bool verified = additionalAuthChecks is Function
                ? additionalAuthChecks(context, snapshot)
                : true;
            if (verified) {
              return signedInBuilder(context, snapshot);
            }
            return additionalAuthChecksFailedBuilder(context, snapshot);
          }
          return nonSignedInBuilder(context, snapshot);
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
