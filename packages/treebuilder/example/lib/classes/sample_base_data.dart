import 'package:treebuilder/treebuilder.dart';

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
