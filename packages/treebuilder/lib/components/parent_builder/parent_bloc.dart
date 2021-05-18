part of treebuilder;

class ParentBloc {
  /// whether the parent widget is expanded or not
  bool expanded;

  ParentBloc({this.expanded = false}) {
    /// initalise stream
    _controller.sink.add(expanded);
    _syncController.sink.add(expanded);
  }

  StreamController<bool> _controller = StreamController();
  StreamController<bool> _syncController = StreamController();

  Stream<bool> get stream {
    return _controller.stream;
  }

  Stream<bool> get syncStream {
    return _syncController.stream;
  }

  void setExpanded(bool expanded) {
    this.expanded = expanded;
    _controller.sink.add(expanded);
    _syncController.sink.add(expanded);
  }

  void dispose() {
    _controller.close();
    _syncController.close();
  }
}
