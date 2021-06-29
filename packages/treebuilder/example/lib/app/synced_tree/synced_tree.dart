import 'package:example/classes/sample_data.dart';
import 'package:example/services/mock_data_service.dart';
import 'package:flutter/material.dart';
import 'package:treebuilder/treebuilder.dart';

class SyncedTree extends StatefulWidget {
  @override
  _SyncedTreeState createState() => _SyncedTreeState();
}

class _SyncedTreeState extends State<SyncedTree> {
  Map<dynamic, ParentBloc> parentBlocs = Map();
  List<IUniqueParentChildRow> _data;

  @override
  void initState() {
    super.initState();
    _data = MockDataService.getData();
  }

  @override
  void dispose() {
    _disposeParentBlocs();
    parentBlocs.clear();
    super.dispose();
  }

  void _disposeParentBlocs() {
    parentBlocs.forEach((key, value) {
      value.dispose();
    });
  }

  ParentBloc _getParentBloc(SampleData parent) {
    if (parentBlocs[parent] != null) {
      return parentBlocs[parent];
    }

    ParentBloc parentBloc = ParentBloc(expanded: true);
    parentBlocs[parent] = parentBloc;
    return parentBloc;
  }

  Widget childBuilder(child, parent, depth) {
    SampleData c = child;
    return Row(
      children: [
        SizedBox(width: 50),
        Expanded(
          child: Text('${c.name}'),
        ),
      ],
    );
  }

  Widget parentBuilder(parent, _, __, depth, childrenWidgets) {
    ParentBloc parentBloc = _getParentBloc(parent);
    return ParentBuilder(
      stream: parentBloc.stream,
      builder: (expanded) {
        return ParentWidget(
          parent: RotatingIconRow(
            expanded: expanded,
            rowColor: depth == 0 ? Colors.lightBlue : null,
            content: Text('${parent.name}'),
            onPressed: () {
              parentBloc.setExpanded(!expanded);
            },
          ),
          expanded: expanded,
          children: childrenWidgets,
        );
      },
    );
  }

  Widget endOfDepthBuilder(parent, depth) {
    return Row(
      children: [
        SizedBox(width: 50),
        Expanded(
          child: Text('end of depth: $depth'),
        ),
      ],
    );
  }

  Widget syncedParentBuilder(parent, _, __, depth, childrenWidgets) {
    ParentBloc parentBloc = _getParentBloc(parent);
    return ParentBuilder(
      stream: parentBloc.stream,
      builder: (expanded) {
        return ParentWidget(
          parent: RotatingIconRow(
            expanded: expanded,
            rowColor: depth == 0 ? Colors.lightBlue : null,
            content: Text('${parent.name}'),
            onPressed: () {
              parentBloc.setExpanded(!expanded);
            },
          ),
          expanded: expanded,
          children: childrenWidgets,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TreeBuilder(
            data: _data,
            childBuilder: childBuilder,
            parentBuilder: parentBuilder,
            endOfDepthBuilder: endOfDepthBuilder,
          ),
        ),
        Expanded(
          child: TreeBuilder(
            data: _data,
            childBuilder: childBuilder,
            parentBuilder: syncedParentBuilder,
            endOfDepthBuilder: endOfDepthBuilder,
          ),
        ),
      ],
    );
  }
}
