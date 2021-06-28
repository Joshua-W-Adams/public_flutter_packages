import 'package:example/classes/sample_data.dart';
import 'package:example/services/mock_data_service.dart';
import 'package:flutter/material.dart';
import 'package:treebuilder/treebuilder.dart';

class Tree extends StatefulWidget {
  @override
  _TreeState createState() => _TreeState();
}

class _TreeState extends State<Tree> {
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

  @override
  Widget build(BuildContext context) {
    return TreeBuilder(
      data: _data,
      childBuilder: (child, parent, depth) {
        SampleData c = child;
        return Row(
          children: [
            SizedBox(width: 50),
            Expanded(
              child: Text('${c.name}'),
            ),
          ],
        );
      },
      parentBuilder: (parent, _, __, depth, childrenWidgets) {
        ParentBloc parentBloc = _getParentBloc(parent);
        return ParentBuilder(
          stream: parentBloc.stream,
          builder: (expanded) {
            return ParentWidget(
              parent: Text('${parent.name}'),
              expanded: expanded,
              parentRowColor: depth == 0 ? Colors.lightBlue : null,
              children: childrenWidgets,
              onPressed: () {
                parentBloc.setExpanded(!expanded);
              },
            );
          },
        );
      },
      endOfDepthBuilder: (parent, depth) {
        return Row(
          children: [
            SizedBox(width: 50),
            Expanded(
              child: Text('end of depth: $depth'),
            ),
          ],
        );
      },
    );
  }
}
