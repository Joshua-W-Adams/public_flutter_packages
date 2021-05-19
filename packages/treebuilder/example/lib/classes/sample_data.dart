import 'package:treebuilder/treebuilder.dart';

class SampleData extends IUniqueParentChildRow {
  final String id;
  final String parentId;
  final String name;

  SampleData({
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
