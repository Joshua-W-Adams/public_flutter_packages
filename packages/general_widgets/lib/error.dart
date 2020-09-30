part of general_widgets;

/// Standardised widget to display errors to the user in a consistent format
class ShowError extends StatelessWidget {
  final String error;

  ShowError({
    @required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
          Text(
            'Error: $error',
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
