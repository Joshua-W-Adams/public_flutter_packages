part of general_widgets;

class UiStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(BuildContext, AsyncSnapshot<T>) builder;

  UiStreamBuilder({
    required this.stream,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (_context, _snapshot) {
        if (_snapshot.connectionState == ConnectionState.waiting) {
          /// case 1 - awaiting connection
          return Center(child: CircularProgressIndicator());
        } else if (_snapshot.hasError) {
          /// case 2 - error in snapshot
          return ShowError(error: '${_snapshot.error.toString()}');
        } else if (!_snapshot.hasData) {
          /// case 3 - no data recieved
          return ShowError(error: 'Error: No data recieved');
        } else {
          /// case 4 - all verfication checks passed
          return builder(_context, _snapshot);
        }
      },
    );
  }
}
