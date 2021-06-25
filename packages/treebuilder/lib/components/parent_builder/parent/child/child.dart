part of treebuilder;

/// all children widgets to the parent widget are wrapped with this class to
/// enable hiding and showing of child widgets
class ChildWidget extends StatelessWidget {
  final List<Widget> children;
  final bool shouldExpand;

  ChildWidget({
    required this.children,
    this.shouldExpand = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizeAnimation(
      forward: shouldExpand,
      child: Column(
        children: children,
      ),
    );
  }
}
