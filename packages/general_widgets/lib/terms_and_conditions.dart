part of general_widgets;

class TermsAndConditions extends StatelessWidget {
  final Function()? termsOfUseCallback;
  final Function()? billingTermsCallback;
  final Function()? privacyPolicyCallback;

  TermsAndConditions({
    this.termsOfUseCallback,
    this.billingTermsCallback,
    this.privacyPolicyCallback,
  });

  TextStyle _getFooterTextStyle(ThemeData theme) {
    return TextStyle(
      color: theme.textTheme.bodyText1!.color!.withOpacity(0.5),
    );
  }

  TextStyle _getFooterClickableTextStyle(ThemeData theme) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
      color: theme.textTheme.bodyText1!.color!.withOpacity(0.5),
    );
  }

  TextSpan? _getTermsOfUse(ThemeData theme) {
    if (termsOfUseCallback == null) {
      return null;
    }
    return TextSpan(
      text: 'Terms of Use',
      style: _getFooterClickableTextStyle(theme),
      // https://fluttermaster.com/method-chaining-using-cascade-in-dart/
      // below "chains" the two methods together
      recognizer: TapGestureRecognizer()..onTap = termsOfUseCallback,
    );
  }

  TextSpan? _getBillingTerms(ThemeData theme) {
    if (billingTermsCallback == null) {
      return null;
    }
    return TextSpan(
      text: 'Billing Terms',
      style: _getFooterClickableTextStyle(theme),
      recognizer: TapGestureRecognizer()..onTap = billingTermsCallback,
    );
  }

  TextSpan? _getPrivacyPolicy(ThemeData theme) {
    if (privacyPolicyCallback == null) {
      return null;
    }
    return TextSpan(
      text: 'Privacy Policy',
      style: _getFooterClickableTextStyle(theme),
      recognizer: TapGestureRecognizer()..onTap = privacyPolicyCallback,
    );
  }

  void _addTextSpan(List<TextSpan> textSpans, TextSpan? textSpanToAdd) {
    if (textSpanToAdd != null) {
      textSpans.add(textSpanToAdd);
    }
  }

  List<TextSpan> _getTextSpans(ThemeData theme) {
    List<TextSpan> input = [];
    List<TextSpan> output = [];
    // add all items to array
    _addTextSpan(input, _getTermsOfUse(theme));
    _addTextSpan(input, _getBillingTerms(theme));
    _addTextSpan(input, _getPrivacyPolicy(theme));
    // loop through array
    for (var i = 0; i < input.length; i++) {
      // case 1 - first item in list
      if (i == 0) {
        output.add(input[i]);
      }
      // case 2 - last item in list
      else if (i == input.length - 1) {
        output.add(
          TextSpan(
            text: ' and ',
            style: _getFooterTextStyle(theme),
          ),
        );
        output.add(input[i]);
        output.add(
          TextSpan(
            text: '.',
            style: _getFooterTextStyle(theme),
          ),
        );
      }
      // case 3 - in between all other items
      else {
        output.add(
          TextSpan(
            text: ' , ',
            style: _getFooterTextStyle(theme),
          ),
        );
        output.add(input[i]);
      }
    }
    // handle no items passed
    if (output.length == 0) {
      return [
        TextSpan(
          text: 'error no functions passed',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ];
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: 75,
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            text:
                'By signing up, you confirm that you have read, understood and agree to our ',
            style: _getFooterTextStyle(theme),
            children: _getTextSpans(theme),
          ),
        ),
      ),
    );
  }
}
