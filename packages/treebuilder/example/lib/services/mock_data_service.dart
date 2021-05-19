import 'package:example/classes/sample_data.dart';
import 'package:treebuilder/treebuilder.dart';

abstract class MockDataService {
  static List<IUniqueParentChildRow> getData() {
    return [
      SampleData(
        id: '1',
        parentId: null,
        name: 'root',
      ),
      SampleData(
        id: '2',
        parentId: '1',
        name: 'L1 child',
      ),
      SampleData(
        id: '3',
        parentId: '1',
        name: 'L1 parent',
      ),
      SampleData(
        id: '4',
        parentId: '3',
        name: 'L2 child',
      ),
      SampleData(
        id: '5',
        parentId: '3',
        name: 'L2 parent',
      ),
      SampleData(
        id: '6',
        parentId: '5',
        name: 'L3 child',
      ),
      SampleData(
        id: '7',
        parentId: '1',
        name: 'L1 parent',
      ),
      SampleData(
        id: '8',
        parentId: '7',
        name: 'L2 child',
      ),
    ];
  }
}
