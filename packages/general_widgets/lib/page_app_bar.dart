part of general_widgets;

// implements = class inherits the implented classes data type and also API (functions)
// allows widget to be used as a PreferredSizeWidget which is a requirement to be used as
// a application bar.
class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Key? key;
  final String title;
  final bool backButton;
  final Function? backButtonOnPressed;
  final List<Widget>? actions;

  PageAppBar({
    this.key,
    this.title = '',
    this.backButton = true,
    this.backButtonOnPressed,
    this.actions,
  }) : super(key: key);

  void _defaultBackButtonOnPressed(BuildContext context) {
    // get current navigator state based on build context
    final NavigatorState navigatorState = Navigator.of(context);
    // pop state off route
    navigatorState.pop();
  }

  Widget? _buildBackButton(BuildContext context) {
    if (backButton != false) {
      return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          if (backButtonOnPressed != null) {
            // execute passed function
            backButtonOnPressed!();
          } else {
            // execute default navigator pop function
            _defaultBackButtonOnPressed(context);
          }
        },
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: _buildBackButton(context),
      actions: actions,
    );
  }

  @override
  final Size preferredSize = Size.fromHeight(kToolbarHeight);
}
