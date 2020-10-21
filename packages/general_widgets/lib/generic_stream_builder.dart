part of general_widgets;

/// [GenericStreamBuilder] is an extension of a [StreamBuilder] with basic
/// connection state and error handling.
class GenericStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final void Function() streamDownFunction;
  final Widget Function(AsyncSnapshot<T> snapshot) builder;

  GenericStreamBuilder({
    @required this.stream,
    @required this.streamDownFunction,
    @required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Awaiting(
            footerTextOnTap: streamDownFunction,
          );
        } else if (snapshot.hasError) {
          return ShowError(
            error: snapshot.error.toString(),
            footerText: 'Return to Login Page',
            footerTextOnTap: streamDownFunction,
          );
        } else {
          return builder(snapshot);
        }
      },
    );
  }
}
