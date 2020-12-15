part of treebuilder;

/// [TreeBuilder] will construct treeview based on parent-child relationship.
/// Therefore all data arrays passed to the tree builder must implement this
/// interface
abstract class BaseData {
  /// id of this data
  String getId();

  /// parentId of a child
  String getParentId();
}

/// controls all business logic for the [TreeBuilder]
class TreeBuilderModel {
  // ************************ Private Functions ************************
  // N/A

  // ************************ Public APIs ************************
  List<T> getDirectChildrenFromParent<T extends BaseData>({
    List<T> data,
    String parentId,
  }) {
    parentId = parentId == null ? "" : parentId.toString();
    return data.where((row) {
      String rowParentId = row.getParentId() == null ? "" : row.getParentId();
      return rowParentId == parentId;
    }).toList();
  }

  List<BaseData> getAllChildrenFromParents({
    List<BaseData> parents,
    List<BaseData> data,
  }) {
    List<BaseData> depthData = [];
    parents.forEach(
      (parent) {
        List<BaseData> parentChildren = getDirectChildrenFromParent(
          data: data,
          parentId: parent.getId(),
        );
        if (parentChildren.length == 0) {
          // case 1 - no children
          depthData.add(parent);
        } else {
          // case 2 - children
          List<BaseData> cData = getAllChildrenFromParents(
            parents: parentChildren,
            data: data,
          );
          depthData.addAll(cData);
        }
      },
    );
    return depthData;
  }

  /// Parent child data structure can be represented by the following diagram:
  /// Where P = Parent Node = a node that has nodes below it
  /// and   C = Child Node = a node that has no nodes below it
  ///                    P
  ///                   / \
  ///                  /   \
  ///                 /     \
  ///                -       -
  ///               P         C
  ///             /- -\
  ///           /-     -\
  ///         /-         -\
  ///        -             -
  ///       P               P
  ///      / \             / \
  ///     /   \           /   \
  ///    /     \         /     \
  ///   -       -       -       -
  ///  C        C       C        C
  /// This [recursiveParentChildLoop] function will walk the parent child data
  /// structure starting at the top node (or root) and go down for each parent
  /// (P) and to the right for each child (C or P). Then up for the last node
  /// under each parent.
  void recursiveParentChildLoop<T extends BaseData>({
    /// direct parent node of depth data
    T parent,

    /// current depth data to perform recursive loop from
    List<T> depthData,

    /// all parent child data
    List<T> data,

    /// current depth in tree
    int depth = 0,

    /// child node encountered
    void Function(T child, T parent, int depth) onChild,

    /// parent node encountered on the way DOWN the data tree (i.e. before the
    /// children are processed)
    void Function(T parent, T parentParent, List<T> children, int depth)
        onParentDown,

    /// parent node encountered on the way UP the data tree (i.e. after the
    /// children are processed)
    void Function(T parent, T parentParent, List<T> children, int depth)
        onParentUp,

    /// current depth data processing complete
    void Function(T parent, int depth) onEndOfDepth,
  }) {
    /// loop through nodes at current depth
    depthData.forEach((node) {
      /// get all node children
      List<T> nodeChildren = getDirectChildrenFromParent<T>(
        data: data,
        parentId: node.getId(),
      );

      if (nodeChildren.length == 0) {
        /// case 1 - no children
        onChild(node, parent, depth);
      } else {
        /// case 2 - parent widget encountered

        /// perform operation before parents children are processed
        onParentDown(node, parent, nodeChildren, depth);

        /// resursively call function for parent
        recursiveParentChildLoop(
          parent: node,
          depthData: nodeChildren,
          data: data,
          depth: depth + 1,
          onChild: onChild,
          onParentDown: onParentDown,
          onParentUp: onParentUp,
          onEndOfDepth: onEndOfDepth,
        );

        /// perform operation after parents children are processed
        onParentUp(node, parent, nodeChildren, depth);
      }
    });

    /// nodes completed processing
    if (onEndOfDepth != null) {
      onEndOfDepth(parent, depth);
    }
  }

  List<Widget> _addToArray(
    Map<int, List<Widget>> tree,
    Widget item,
    int depth,
  ) {
    List<Widget> arr;

    /// create array if it does not already exist
    if (tree[depth] == null) {
      arr = [];
    } else {
      arr = tree[depth];
    }

    /// add item to array
    arr.add(item);

    return arr;
  }

  /// [buildWidgetTree] is a wrapper to the [_recursiveParentChildLoop] function
  /// that the ability to construct a widget tree from the loop.
  List<Widget> buildWidgetTree({
    BaseData parent,
    List<BaseData> depthData,
    List<BaseData> data,
    int depth = 0,
    Widget Function(BaseData child, BaseData parent, int depth) onChild,
    Widget Function(BaseData parent, BaseData parentParent,
            List<BaseData> children, int depth, List<Widget> childrenWidgets)
        onParentUp,
    Widget Function(BaseData parent, int depth) onEndOfDepth,
  }) {
    /// create widget array for storing generated tree
    Map<int, List<Widget>> tree = Map<int, List<Widget>>();

    /// perform recursive loop to generate tree
    recursiveParentChildLoop(
      parent: parent,
      depthData: depthData,
      data: data,
      depth: depth,
      onChild: (BaseData child, BaseData parent, int depth) {
        /// generate widget
        Widget cWidget = onChild(child, parent, depth);

        /// store widget in current depth array
        tree[depth] = _addToArray(tree, cWidget, depth);
      },

      /// unused - pass function to prevent missing callback errors
      onParentDown: (_, __, ___, ____) {},
      onParentUp: (BaseData parent, BaseData parentParent,
          List<BaseData> children, int depth) {
        /// get children
        List<Widget> cWidgets = tree[depth + 1];

        /// generate widget
        Widget pWidget =
            onParentUp(parent, parentParent, children, depth, cWidgets);

        /// store widget
        tree[depth] = _addToArray(tree, pWidget, depth);
      },
      onEndOfDepth: (BaseData parent, int depth) {
        /// generate widget
        Widget endWidget = onEndOfDepth(parent, depth);

        /// store widget
        tree[depth] = _addToArray(tree, endWidget, depth);
      },
    );

    return tree[depth];

    /// Old recursive loop logic
    //   List<Widget> depthWidgets = [];
    //   depthData.forEach(
    //     (child) {
    //       List<BaseData> childChildren = getDirectChildrenFromParent(
    //         data: data,
    //         parentId: child.getId(),
    //       );
    //       if (childChildren.length == 0) {
    //         // case 1 - no children - child widget encountered
    //         Widget cWidget = onChild(child, parent, depth);
    //         depthWidgets.add(cWidget);
    //       } else {
    //         // case 2 - children - parent widget encountered
    //         List<Widget> cWidgets = buildWidgetTree(
    //           parent: child,
    //           depthData: childChildren,
    //           data: data,
    //           depth: depth + 1,
    //           onChild: onChild,
    //           onParentDown: onParentDown,
    //           onParentUp: onParentUp,
    //           onEndOfDepth: onEndOfDepth,
    //         );
    //         Widget pWidget =
    //             onParentUp(child, parent, childChildren, depth, cWidgets);
    //         depthWidgets.add(pWidget);
    //       }
    //     },
    //   );
    //   if (onEndOfDepth != null) {
    //     Widget endWidget = onEndOfDepth(parent, depth);
    //     depthWidgets.add(endWidget);
    //   }
    //   return depthWidgets;
  }
}
