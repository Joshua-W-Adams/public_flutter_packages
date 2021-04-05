class SampleDataModel {
  final String id;
  String name;
  num age;

  SampleDataModel({this.id, this.name, this.age})
      : assert(id != null, 'id must not be null');
}
