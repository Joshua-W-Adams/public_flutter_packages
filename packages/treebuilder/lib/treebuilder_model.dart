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
  List<BaseData> getDirectChildrenFromParent({
    List<BaseData> data,
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
  List<Widget> recursiveParentChildLoop({
    BaseData parent,
    List<BaseData> children,
    List<BaseData> data,
    int depth = 0,
    Function(BaseData child, BaseData parent, int depth) childCallback,
    Function(BaseData parent, BaseData parentParent, List<BaseData> children,
            int depth, List<Widget> childrenWidgets)
        parentCallback,
    Function(BaseData parent, int depth) endOfDepthCallback,
  }) {
    List<Widget> depthWidgets = [];
    children.forEach(
      (child) {
        List<BaseData> childChildren = getDirectChildrenFromParent(
          data: data,
          parentId: child.getId(),
        );
        if (childChildren.length == 0) {
          // case 1 - no children - child widget encountered
          Widget cWidget = childCallback(child, parent, depth);
          depthWidgets.add(cWidget);
        } else {
          // case 2 - children - parent widget encountered
          List<Widget> cWidgets = recursiveParentChildLoop(
            parent: child,
            children: childChildren,
            data: data,
            depth: depth + 1,
            childCallback: childCallback,
            parentCallback: parentCallback,
            endOfDepthCallback: endOfDepthCallback,
          );
          Widget pWidget =
              parentCallback(child, parent, childChildren, depth, cWidgets);
          depthWidgets.add(pWidget);
        }
      },
    );
    if (endOfDepthCallback != null) {
      Widget endWidget = endOfDepthCallback(parent, depth);
      depthWidgets.add(endWidget);
    }
    return depthWidgets;
  }
}
