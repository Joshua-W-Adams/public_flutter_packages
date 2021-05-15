part of treebuilder;

/// A tree view that supports indefinite parent/child datastructures with
/// passable widget builder for parent, child and last row in depth.
class TreeBuilder<T extends BaseData> extends StatelessWidget {
  /// TreeBuilder will be constructed based on this parent child data array.
  /// Create a model class and implement [BaseData]
  final List<T> data;

  /// widget builder functions that are called for parent and child items
  final Widget Function(
    T parent,
    T parentParent,
    List<T> children,
    int depth,
    List<Widget> childrenWidgets,
  ) parentBuilder;

  final Widget Function(T child, T parent, int depth) childBuilder;

  /// widget builder function called when the last child of a parent is
  /// encountered at every tree depth level
  final Widget Function(
    T parent,
    int depth,
  ) endOfDepthBuilder;

  /// Fetchs the immediate children of root. Default is null.
  final String buildFromId;

  // constructed instance of tree
  List<Widget> _tree;

  TreeBuilder({
    Key key,
    @required this.data,
    @required this.parentBuilder,
    @required this.childBuilder,
    this.endOfDepthBuilder,
    this.buildFromId,
  }) : super(key: key) {
    // recursive build tree funciton needs to occur as soon as the tree is
    // constructed to ensure all recursive calculations occur BEFORE subsequent
    // operations are performed.
    _tree = _buildTree();
  }

  List<Widget> _buildTree() {
    // get all root data to start from
    List<T> roots = TreeBuilderModel.getDirectChildrenFromParent(
      data: data,
      parentId: buildFromId,
    );

    /// get parent data
    T parent = data.firstWhere((element) {
      return element.getId() == buildFromId;
    }, orElse: () {
      /// no element matching id found
      return null;
    });

    // perform recursive loop
    return TreeBuilderModel.buildWidgetTree<T>(
      parent: parent,
      depthData: roots,
      data: data,
      onChild: childBuilder,
      onParentUp: parentBuilder,
      onEndOfDepth: endOfDepthBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _tree.length > 0 ? _tree : Container(),
      ),
      scrollDirection: Axis.vertical,
    );
  }
}

/// Wrapper widget for all parent widgets to enable disabling or hiding all child
/// widgets
class ParentWidget extends StatefulWidget {
  final Widget parent;
  final List<Widget> children;
  final IconData arrowIcon;
  // final bool shouldExpand;
  // final Function onToggle;

  /// style configuration properties
  final Color parentRowColor;

  ParentWidget({
    @required this.parent,
    @required this.children,
    this.arrowIcon = Icons.keyboard_arrow_down,
    // this.shouldExpand = false,
    // this.onToggle,
    this.parentRowColor,
    Key key,
  }) : super(key: key);

  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget>
    with SingleTickerProviderStateMixin {
  bool shouldExpand = false;
  Animation<double> sizeAnimation;
  AnimationController expandController;

  @override
  void initState() {
    super.initState();
    // shouldExpand = widget.shouldExpand;
    // print(shouldExpand);
    prepareAnimation();
  }

  // @override
  // void didUpdateWidget(ParentWidget oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // update detected, rebuild widget state
  //   setState(() {});
  // }

  @override
  void dispose() {
    super.dispose();
    expandController.dispose();
  }

  void prepareAnimation() {
    expandController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    Animation curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    sizeAnimation = Tween(
      begin: 0.0,
      end: 0.5,
    ).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: widget.parentRowColor,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  // if (widget.onToggle != null) {
                  //   widget.onToggle();
                  // }
                  setState(() {
                    shouldExpand = !shouldExpand;
                  });
                  if (shouldExpand) {
                    expandController.forward();
                  } else {
                    expandController.reverse();
                  }
                },
                icon: RotationTransition(
                  turns: sizeAnimation,
                  child: Icon(
                    widget.arrowIcon,
                  ),
                ),
              ),
              // parent widget builder executed here
              Expanded(
                child: widget.parent,
              ),
            ],
          ),
        ),
        ChildWidget(
          children: widget.children,
          shouldExpand: shouldExpand,
        )
      ],
    );
  }
}

/// all children widgets to the parent widget are wrapped with this class to
/// enable hiding and showing of child widgets
class ChildWidget extends StatefulWidget {
  final List<Widget> children;
  final bool shouldExpand;

  ChildWidget({
    this.children,
    this.shouldExpand = false,
  });

  @override
  _ChildWidgetState createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget>
    with SingleTickerProviderStateMixin {
  Animation<double> sizeAnimation;
  AnimationController expandController;

  @override
  void didUpdateWidget(ChildWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldExpand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void initState() {
    prepareAnimation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    expandController.dispose();
  }

  void prepareAnimation() {
    expandController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    Animation curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    sizeAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: sizeAnimation,
      axisAlignment: -1.0,
      child: Column(
        children: widget.children,
      ),
    );
  }
}
