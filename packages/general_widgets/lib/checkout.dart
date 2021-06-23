part of general_widgets;

class Checkout extends StatefulWidget {
  final String checkoutItemHeader;
  final String checkoutItemTitle;
  final String checkoutItemSubtitle;
  final String paymentMethodHeader;
  final String paymentMethodTitle;
  final String paymentMethodSubtitle;
  final String purchaseNotes;
  final Future<void> Function()? purchaseCallback;
  final Future<void> Function(String? discountCode)? discountCallback;
  final Function() termsOfUseCallback;
  final Function() privacyPolicyCallback;
  final Function() billingTermsCallback;

  Checkout({
    Key? key,
    required this.checkoutItemHeader,
    required this.checkoutItemTitle,
    required this.checkoutItemSubtitle,
    required this.paymentMethodHeader,
    required this.paymentMethodTitle,
    required this.paymentMethodSubtitle,
    required this.purchaseNotes,
    this.purchaseCallback,
    this.discountCallback,
    required this.termsOfUseCallback,
    required this.privacyPolicyCallback,
    required this.billingTermsCallback,
  }) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool _requestPending = false;
  String? _discountCode;
  GlobalKey<FormFieldState> _textFieldKey = GlobalKey();

  /// [_processRequest] is a generic ui function for handling server requests.
  /// Preventing users from performing additional requests while one is
  /// processing and also displaying success and error messages to the user.
  void _processRequest({
    required BuildContext context,
    required Future<void> requestFuture,
  }) {
    // check if request has already been issued to database
    if (!_requestPending) {
      // prevent user sending additional request while like is already underway
      setState(() {
        _requestPending = true;
      });
      // perform request
      requestFuture.then((_) async {
        // request successful
        setState(() {
          _requestPending = false;
        });
        // inform user of successful request
        ScaffoldMessengerState scaffoldMessengerState =
            ScaffoldMessenger.of(context);
        scaffoldMessengerState.showSnackBar(
          SnackBar(
            content: Text(
              'Request to server completed successfully.',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
          ),
        );
        // await showAlertDialog(
        //   context: context,
        //   title: 'Succeeded',
        //   content: 'Request to server complete.',
        //   defaultActionText: 'Close',
        // );
      }).catchError((e) async {
        // request complete. allow user to send new request.
        setState(() {
          _requestPending = false;
        });
        // inform user of failed request
        await showExceptionAlertDialog(
          context: context,
          title: 'Failed',
          exception: e,
        );
      });
    }
    // pending result of request. Do nothing.
  }

  Widget _getTitleTile(String title) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _getReviewItem(
    String itemTitle,
    String itemSubTitle,
  ) {
    return ListTile(
      title: Text(itemTitle),
      subtitle: Text(itemSubTitle),
    );
  }

  Widget _getPurchaseNotes() {
    return ListTile(
      subtitle: Text(
        '${widget.purchaseNotes}',
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _getDiscountCodeField() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: TextFormField(
        key: _textFieldKey,
        autocorrect: false,
        enabled: !_requestPending,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Discount Code',
        ),
        validator: (String? value) {
          if (value == null || value.length == 0) {
            return 'Must provide a discount code';
          }
          return null;
        },
        onChanged: (String val) {
          // save the discount code in memory
          _discountCode = val;
        },
      ),
    );
  }

  Widget _getDiscountCodeButton(ThemeData theme) {
    return Container(
      width: 100,
      height: 35,
      child: StackButton(
        text: 'Apply',
        disabledColor: theme.canvasColor,
        onPressed: _requestPending == true
            ? null
            : () {
                // confirm discount code field is valid
                bool valid = _textFieldKey.currentState!.validate();
                // send request to server if valid code and callback passed
                if (valid && widget.discountCallback != null) {
                  _processRequest(
                    context: context,
                    requestFuture: widget.discountCallback!(_discountCode),
                  );
                }
              },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        // scrollable content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _getTitleTile('${widget.paymentMethodHeader}'),
                _getReviewItem(
                  '${widget.paymentMethodTitle}',
                  '${widget.paymentMethodSubtitle}',
                ),
                _getTitleTile('${widget.checkoutItemHeader}'),
                _getReviewItem(
                  '${widget.checkoutItemTitle}',
                  '${widget.checkoutItemSubtitle}',
                ),
                Row(
                  children: [
                    Expanded(child: _getDiscountCodeField()),
                    _getDiscountCodeButton(theme),
                  ],
                ),
                SizedBox(height: 16),
                _getPurchaseNotes(),
                TermsAndConditions(
                  termsOfUseCallback: widget.termsOfUseCallback,
                  privacyPolicyCallback: widget.privacyPolicyCallback,
                  billingTermsCallback: widget.billingTermsCallback,
                ),
              ],
            ),
          ),
        ),
        // non scrollable footer content
        SizedBox(height: 16),
        StackButton(
          text: 'Purchase',
          child: Icon(
            Icons.payment_rounded,
          ),
          disabledColor: theme.canvasColor,
          onPressed: _requestPending == true
              ? null
              : () {
                  if (widget.purchaseCallback != null) {
                    _processRequest(
                      context: context,
                      requestFuture: widget.purchaseCallback!(),
                    );
                  }
                },
        ),
      ],
    );
  }
}
