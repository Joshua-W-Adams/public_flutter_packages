part of treebuilder;

class ParentBloc {
  /// whether the parent widget is expanded or not
  bool expanded;

  ParentBloc({this.expanded = false}) {
    /// initalise stream
    _controller.sink.add(expanded);
  }

  StreamController<bool> _controller = BehaviorSubject();

  Stream<bool> get stream {
    return _controller.stream;
  }

  void setExpanded(bool expanded) {
    this.expanded = expanded;
    _controller.sink.add(expanded);
  }

  void dispose() {
    _controller.close();
  }
}
