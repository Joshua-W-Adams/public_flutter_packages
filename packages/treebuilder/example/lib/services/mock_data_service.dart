import 'package:example/classes/sample_base_data.dart';
import 'package:treebuilder/treebuilder.dart';

abstract class MockDataService {
  static List<BaseData> getData() {
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
}
