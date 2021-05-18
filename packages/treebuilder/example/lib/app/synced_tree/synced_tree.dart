import 'package:example/classes/sample_base_data.dart';
import 'package:example/services/mock_data_service.dart';
import 'package:flutter/material.dart';
import 'package:treebuilder/treebuilder.dart';

class SyncedTree extends StatefulWidget {
  @override
  _SyncedTreeState createState() => _SyncedTreeState();
}

class _SyncedTreeState extends State<SyncedTree> {
  Map<dynamic, ParentBloc> parentBlocs = Map();

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

  Widget childBuilder(child, parent, depth) {
    SampleBaseData c = child;
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
    SampleBaseData p = parent;
    ParentBloc parentBloc = ParentBloc(expanded: true);
    parentBlocs[parent] = parentBloc;

    return ParentBuilder(
      stream: parentBloc.stream,
      builder: (expanded) {
        return ParentWidget(
          parent: Text('${p.name}'),
          expanded: expanded,
          parentRowColor: depth == 0 ? Colors.lightBlue : null,
          children: childrenWidgets,
          icon: Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            parentBloc.setExpanded(!expanded);
          },
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
    SampleBaseData p = parent;
    ParentBloc parentBloc = parentBlocs[parent];
    return ParentBuilder(
      stream: parentBloc.syncStream,
      builder: (expanded) {
        return ParentWidget(
          parent: Text('${p.name}'),
          expanded: expanded,
          parentRowColor: depth == 0 ? Colors.lightBlue : null,
          children: childrenWidgets,
          icon: Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            parentBloc.setExpanded(!expanded);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _disposeParentBlocs();
    List<BaseData> data = MockDataService.getData();
    return Row(
      children: [
        Expanded(
          child: TreeBuilder(
            data: data,
            childBuilder: childBuilder,
            parentBuilder: parentBuilder,
            endOfDepthBuilder: endOfDepthBuilder,
          ),
        ),
        Expanded(
          child: TreeBuilder(
            data: data,
            childBuilder: childBuilder,
            parentBuilder: syncedParentBuilder,
            endOfDepthBuilder: endOfDepthBuilder,
          ),
        ),
      ],
    );
  }
}
