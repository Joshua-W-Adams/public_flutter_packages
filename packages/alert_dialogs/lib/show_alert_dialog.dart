part of alert_dialogs;

Future<bool> showAlertDialog({
  @required BuildContext context,
  @required String title,
  @required String content,
  String cancelActionText,
  @required String defaultActionText,
  void Function() onCloseCallback,
  bool barrierDismissible = true,
}) async {
  return await showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          if (cancelActionText != null)
            TextButton(
              child: Text(cancelActionText),
              onPressed: () {
                return Navigator.of(context).pop(false);
              },
            ),
          TextButton(
            child: Text(defaultActionText),
            onPressed: () {
              if (onCloseCallback != null) {
                onCloseCallback();
              }
              return Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
