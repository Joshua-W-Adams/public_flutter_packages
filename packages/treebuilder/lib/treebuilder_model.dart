part of treebuilder;

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

abstract class IUniqueRow {
  /// id of this data
  String getId();
}

/// [TreeBuilder] will construct treeview based on parent-child relationship.
/// Therefore all data arrays passed to the tree builder must implement this
/// interface
abstract class IUniqueParentChildRow extends IUniqueRow {
  /// parentId of a child
  String? getParentId();
}

/// controls all business logic for the [TreeBuilder]
abstract class TreeBuilderModel {
  // ************************ Private Functions ************************
  // N/A

  // ************************ Public APIs ************************
  static List<T> getDirectChildrenFromParent<T extends IUniqueParentChildRow>({
    required List<T> data,
    required String? parentId,
  }) {
    parentId = parentId == null ? "" : parentId.toString();
    return data.where((row) {
      String? rowParentId = row.getParentId();
      rowParentId = rowParentId ?? "";
      return rowParentId == parentId;
    }).toList();
  }

  static List<T> getAllChildrenFromParents<T extends IUniqueParentChildRow>({
    required List<T> parents,
    required List<T> data,
  }) {
    List<T> depthData = [];
    parents.forEach(
      (parent) {
        List<T> parentChildren = getDirectChildrenFromParent(
          data: data,
          parentId: parent.getId(),
        );
        if (parentChildren.length == 0) {
          // case 1 - no children
          depthData.add(parent);
        } else {
          // case 2 - children
          List<T> cData = getAllChildrenFromParents(
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
  static void recursiveParentChildLoop<T extends IUniqueParentChildRow>({
    /// direct parent node of depth data
    T? parent,

    /// current depth data to perform recursive loop from
    required List<T> depthData,

    /// all parent child data
    required List<T> data,

    /// current depth in tree
    int depth = 0,

    /// child node encountered
    void Function(
      T child,
      T? parent,
      T? childPreviousSibling,
      int depth,
    )?
        onChild,

    /// parent node encountered on the way DOWN the data tree (i.e. before the
    /// children are processed)
    void Function(
      T parent,
      T? parentParent,
      T? parentPreviousSibling,
      List<T> children,
      int depth,
    )?
        onParentDown,

    /// parent node encountered on the way UP the data tree (i.e. after the
    /// children are processed)
    void Function(
      T parent,
      T? parentParent,
      T? parentPreviousSibling,
      List<T> children,
      int depth,
    )?
        onParentUp,

    /// current depth data processing complete
    void Function(
      T? parent,
      T? childPreviousSibling,
      int depth,
    )?
        onEndOfDepth,
  }) {
    /// loop through nodes at current depth
    for (var n = 0; n < depthData.length; n++) {
      T node = depthData[n];

      T? nodePreviousSibling;
      if (n != 0) {
        /// previous sibling exists everywhere but position 0
        nodePreviousSibling = depthData[n - 1];
      }

      /// get all node children
      List<T> nodeChildren = getDirectChildrenFromParent<T>(
        data: data,
        parentId: node.getId(),
      );

      if (nodeChildren.length == 0) {
        /// case 1 - no children
        onChild?.call(node, parent, nodePreviousSibling, depth);
      } else {
        /// case 2 - parent widget encountered

        /// perform operation before parents children are processed
        onParentDown?.call(
            node, parent, nodePreviousSibling, nodeChildren, depth);

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
        onParentUp?.call(
            node, parent, nodePreviousSibling, nodeChildren, depth);
      }
    }

    /// get last node of current depth
    T? lastNode;
    if (depthData.length != 0) {
      lastNode = depthData.last;
    }

    /// nodes completed processing
    onEndOfDepth?.call(parent, lastNode, depth);
  }

  static List<Widget> addToArray<T extends IUniqueParentChildRow>(
    Map<T?, List<Widget>> tree,
    Widget item,
    T? parent,
  ) {
    List<Widget> children;

    /// create array if it does not already exist
    if (tree[parent] == null) {
      children = [];
    } else {
      children = tree[parent]!;
    }

    /// add item to array
    children.add(item);

    return children;
  }

  /// [buildWidgetTree] is a wrapper to the [_recursiveParentChildLoop] function
  /// that the ability to construct a widget tree from the loop.
  static List<Widget> buildWidgetTree<T extends IUniqueParentChildRow>({
    T? parent,
    required List<T> depthData,
    required List<T> data,
    int depth = 0,
    required Widget Function(T child, T? parent, int depth) onChild,
    required Widget Function(
      T parent,
      T? parentParent,
      List<T> children,
      int depth,
      List<Widget> childrenWidgets,
    )
        onParentUp,
    required Widget Function(T? parent, int depth) onEndOfDepth,
  }) {
    /// create widget array for storing generated tree
    Map<T?, List<Widget>> tree = Map<T?, List<Widget>>();

    /// perform recursive loop to generate tree
    recursiveParentChildLoop<T>(
      parent: parent,
      depthData: depthData,
      data: data,
      depth: depth,
      onChild: (T child, T? parent, T? _, int depth) {
        /// generate widget
        Widget cWidget = onChild(child, parent, depth);

        /// store widget in current depth array
        tree[parent] = addToArray<T>(tree, cWidget, parent);
      },
      onParentUp: (
        T parent,
        T? parentParent,
        T? _,
        List<T> children,
        int depth,
      ) {
        /// get children
        List<Widget> cWidgets = tree[parent]!;

        /// generate widget
        Widget pWidget =
            onParentUp(parent, parentParent, children, depth, cWidgets);

        /// store widget
        tree[parentParent] = addToArray<T>(tree, pWidget, parentParent);
      },
      onEndOfDepth: (T? parent, T? _, int depth) {
        /// generate widget
        Widget endWidget = onEndOfDepth(parent, depth);

        /// store widget
        tree[parent] = addToArray<T>(tree, endWidget, parent);
      },
    );

    return tree[parent]!;

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

  static void recursiveParentLookupLoop<T extends IUniqueParentChildRow>({
    /// direct parent node of depth data
    required T node,

    /// all parent child data
    required List<T> data,

    /// child node encountered
    required void Function(T child, T parent) onParent,
  }) {
    if (node.getParentId() != null) {
      // case 1 - any node besides root node

      // loop through nodes in parent child tree
      for (var i = 0; i < data.length; i++) {
        // store current node
        T n = data[i];

        if (n.getId() == node.getParentId()) {
          // case 1.1 - parent found
          T parent = n;
          // perform specific operations for parent
          onParent(node, parent);
          // recursively call function
          recursiveParentLookupLoop(
            node: parent,
            data: data,
            onParent: onParent,
          );
          // end current loop to prevent un-necessary processing
          break;
        }
        // case 1.2 - parent not found, continue searching data
      }
    }
    // case 2 - root node passed - do nothing
  }
}
