import 'package:flutter/material.dart';
import 'package:treebuilder/treebuilder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sample Tree App'),
        ),
        body: Tree(),
      ),
    );
  }
}

List<BaseData> _getData() {
  return [
    SampleBaseData(
      id: '1',
      parentId: null,
      name: 'root',
    ),
    SampleBaseData(
      id: '2',
      parentId: '1',
      name: 'L1 child',
    ),
    SampleBaseData(
      id: '3',
      parentId: '1',
      name: 'L1 parent',
    ),
    SampleBaseData(
      id: '4',
      parentId: '3',
      name: 'L2 child',
    ),
    SampleBaseData(
      id: '5',
      parentId: '3',
      name: 'L2 parent',
    ),
    SampleBaseData(
      id: '6',
      parentId: '5',
      name: 'L3 child',
    ),
    SampleBaseData(
      id: '7',
      parentId: '1',
      name: 'L1 parent',
    ),
    SampleBaseData(
      id: '8',
      parentId: '7',
      name: 'L2 child',
    ),
  ];
}

class Tree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TreeBuilder(
      data: _getData(),
      childBuilder: (child, parent, depth) {
        SampleBaseData c = child;
        return Row(
          children: [
            SizedBox(width: 50),
            Expanded(
              child: Text('${c.name}'),
            ),
          ],
        );
      },
      parentBuilder: (parent, _, __, ___, childrenWidgets) {
        SampleBaseData p = parent;
        return ParentWidget(
          parent: Text('${p.name}'),
          children: childrenWidgets,
          arrowIcon: Icons.keyboard_arrow_down,
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

class SampleBaseData extends BaseData {
  final String id;
  final String parentId;
  final String name;

  SampleBaseData({
    this.id,
    this.parentId,
    this.name,
  });

  @override
  String getId() {
    return id;
  }

  @override
  String getParentId() {
    return parentId;
  }
}
