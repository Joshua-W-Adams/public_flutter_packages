library add_credit_card_page;

import 'package:flutter/material.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:general_widgets/general_widgets.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';

class AddCreditCardPage extends StatefulWidget {
  final Future<Map<String, dynamic>> Function(Map<String, dynamic> cardMap)
      createPaymentMethodFromCard;

  AddCreditCardPage({
    Key key,
    @required this.createPaymentMethodFromCard,
  }) : super(key: key);

  @override
  _AddCreditCardPageState createState() => _AddCreditCardPageState();
}

class _AddCreditCardPageState extends State<AddCreditCardPage> {
  bool _requestPending = false;
  final formKey = GlobalKey<FormState>();

  void _addStripePaymentMethod(BuildContext context, StripeCard card) {
    // check if request has already been issued to database
    if (!_requestPending) {
      // prevent user sending additional request while like is already underway
      _requestPending = true;
      // rebuild state to display to user
      setState(() {});
      // convert stripe card to json
      Map<String, dynamic> cardMap = card.toPaymentMethod();
      // create payment method
      widget.createPaymentMethodFromCard(cardMap).then((_) async {
        // request successful
        _requestPending = false;
        setState(() {});
        bool closed = await showAlertDialog(
          context: context,
          title: 'Success',
          content: 'Card successfully added to account',
          defaultActionText: 'Close',
        );
        if (closed) {
          Navigator.of(context).pop();
        }
      }).catchError((e) async {
        // request complete. allow user to send new request.
        _requestPending = false;
        setState(() {});
        await showExceptionAlertDialog(
          context: context,
          title: 'Sign in Failed',
          exception: e,
        );
      });
    }
    // pending result of request. Do nothing.
  }

  void _showNoFunctionError() {
    showAlertDialog(
      context: context,
      title: 'Error',
      content: 'No add payment method function provided',
      defaultActionText: 'Close',
    );
  }

  Widget _buildSubmitButton(BuildContext context, StripeCard card) {
    return StackButton(
      text: 'Submit',
      child: Icon(
        Icons.credit_card,
      ),
      disabledColor: Theme.of(context).canvasColor,
      // Assigning a null value to the onpressed event disables the button
      onPressed: _requestPending
          ? null
          : () {
              // check all form fields are validated
              if (formKey.currentState.validate()) {
                // save details to card so they can be accessed later
                formKey.currentState.save();
                // send card details to stripe and store in database
                if (widget.createPaymentMethodFromCard != null) {
                  _addStripePaymentMethod(context, card);
                } else {
                  _showNoFunctionError();
                }
              }
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = StripeCard();
    final form = CardForm(card: card, formKey: formKey);
    return Scaffold(
      appBar: PageAppBar(
        title: 'Add Credit Card',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            form,
            SizedBox(height: 10),
            _buildSubmitButton(context, card),
          ],
        ),
      ),
    );
  }
}
