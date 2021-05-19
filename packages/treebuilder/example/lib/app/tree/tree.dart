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

  @override
  Widget build(BuildContext context) {
    _disposeParentBlocs();
    return TreeBuilder(
      data: MockDataService.getData(),
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
        SampleData p = parent;
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
