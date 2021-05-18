part of treebuilder;

class ParentBuilder extends StatelessWidget {
  /// stream of expanded status
  final Stream<bool> stream;

  final Widget Function(bool expanded) builder;

  ParentBuilder({
    required this.stream,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          /// case 1 - awaiting connection
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          /// case 2 - error in snapshot
          return Text(
            '${snapshot.error.toString()}',
          );
        } else if (!snapshot.hasData) {
          /// case 3 - no data
          return Text(
            'No data recieved from server',
          );
        }

        /// get expanded status from bloc
        bool expanded = snapshot.data ?? false;

        return builder(expanded);
      },
    );
  }
}
