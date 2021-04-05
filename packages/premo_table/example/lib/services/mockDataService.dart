import 'dart:async';

class MockDataService<T> {
  final List<T> data;

  StreamController<List<T>> _controller = StreamController();

  MockDataService({this.data}) {
    /// add data to stream so listeners update
    _controller.sink.add(data);
  }

  Stream<List<T>> get stream {
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }
}
