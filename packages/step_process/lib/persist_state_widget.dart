part of step_process;

/// [PersistStateWidget] is simply a wrapper to another widget to ensure the
/// wrapped (or child) widgets state is persisted. Specifically in the case of
/// the [StepProcess] widget, this widget will conditionally wrap each steps
/// content widget to prevent the state of each step being lost when the user
/// navigates forward and backward along the step process.
class PersistStateWidget extends StatefulWidget {
  final Widget child;

  const PersistStateWidget({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _PersistStateWidgetState createState() => _PersistStateWidgetState();
}

/// mixin = type of class to add the ability of one class to another
/// with = how a mixin is applied to another class
/// AuutomaticKeepaliove mixin tells flutter that you want to perserve this
/// stateful widgets state.
class _PersistStateWidgetState extends State<PersistStateWidget>
    with AutomaticKeepAliveClientMixin<PersistStateWidget> {
  /// want keep alive will preserve the state of this widget in memory
  /// setting to true will force the tab to never be disposed. This could be dangerous.
  /// dispose will still be called when the parent widgets dispose method is
  /// called.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // required by the wantkeep alive mixin.
    super.build(context);
    return widget.child;
  }
}
