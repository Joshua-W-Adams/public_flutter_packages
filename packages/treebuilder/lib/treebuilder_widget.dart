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
    T? parentParent,
    List<T> children,
    int depth,
    List<Widget> childrenWidgets,
  ) parentBuilder;

  final Widget Function(T child, T? parent, int depth) childBuilder;

  /// widget builder function called when the last child of a parent is
  /// encountered at every tree depth level
  final Widget Function(
    T? parent,
    int depth,
  ) endOfDepthBuilder;

  /// Fetchs the immediate children of root. Default is null.
  final String? buildFromId;

  // constructed instance of tree
  List<Widget>? _tree;

  TreeBuilder({
    Key? key,
    required this.data,
    required this.parentBuilder,
    required this.childBuilder,
    required this.endOfDepthBuilder,
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
    T? parent = data.firstWhereOrNull((element) {
      return element.getId() == buildFromId;
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
      child: _tree!.length > 0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _tree!,
            )
          : Container(),
      scrollDirection: Axis.vertical,
    );
  }
}
