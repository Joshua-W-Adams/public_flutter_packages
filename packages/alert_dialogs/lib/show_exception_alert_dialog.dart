part of alert_dialogs;

Future<void> showExceptionAlertDialog({
  @required BuildContext context,
  @required String title,
  @required dynamic exception,
}) async =>
    await showAlertDialog(
      context: context,
      title: title,
      content: _message(exception),
      defaultActionText: 'OK',
    );

String _message(dynamic exception) {
  if (exception is PlatformException) {
    return exception.message;
  }
  return exception.toString();
}
