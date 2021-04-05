part of premo_table;

class CrudTableState<T> {
  /// internal properties to track the currently selected row and column used to
  /// highlight rows and columns when user is navigating the table.
  int selectedRow;
  int selectedColumn;

  /// inform listeners when the selected cell has changed
  bool selectedCellChanged;

  /// Latest data event recieved from the server stream
  List<T> data;

  CrudTableState({
    this.selectedRow,
    this.selectedColumn,
    this.selectedCellChanged,
    this.data,
  }) : assert(data != null, 'data cannot be null');
}

class CrudTableBloc<T> {
  /// generic stream of data that will be displayed in the table
  final Stream<List<T>> inputStream;

  /// current state of the crud table
  CrudTableState crudTableState;

  /// initialise state stream controller
  StreamController _controller = StreamController<CrudTableState>();

  /// expose stream for listening as getter function
  Stream<CrudTableState> get stream {
    return _controller.stream;
  }

  /// store subscription for cleaning up on BloC disposal
  StreamSubscription _subscription;

  CrudTableBloc({
    this.inputStream,
  }) : assert(inputStream != null, 'inputStream cannot be null') {
    /// listen to input data stream
    _subscription = inputStream.listen((event) {
      if (crudTableState == null) {
        /// case 1 - state does not exist - initial load of CRUD table
        crudTableState = CrudTableState(
          selectedRow: null,
          selectedColumn: null,
          selectedCellChanged: false,
          data: event,
        );
      } else {
        /// case 2 - state does exist
        crudTableState.data = event;
        crudTableState.selectedCellChanged = false;
      }

      /// release all parent events as crud table state
      _controller.sink.add(crudTableState);
    });
  }

  /// [deselectCell] clears the currently selected cell from the state and
  /// releases the new state to the stream. This allows listeners to update to
  /// suit.
  ///
  /// e.g. Will re-executes the @build method in connected ui components so that
  /// the [CrudTable] is rebuilt with the selected cell cleared.
  void deselectCell() {
    /// clear row and column selection
    selectCell(null, null);
  }

  /// [selectCell] sets the selected cell to the specific row and column passed
  /// and releases the new state to the stream. This allows listeners to update
  /// to suit.
  ///
  /// e.g. Will re-executes the @build method in connected ui components so that
  /// the [CrudTable] is rebuilt with the correctly selected cell.
  void selectCell(int row, int col) {
    // check state stream initialised
    if (crudTableState != null) {
      if (crudTableState.selectedRow != row ||
          crudTableState.selectedColumn != col) {
        /// case 1 - selected cell changed
        /// set new cellselection
        crudTableState.selectedRow = row;
        crudTableState.selectedColumn = col;
        crudTableState.selectedCellChanged = true;

        /// release new state to stream
        _controller.sink.add(crudTableState);
      }

      /// case 2 - selected cell unchanged
      /// do nothing

    }
  }

  /// clean up variables to prevent memory leaks
  void dispose() {
    _subscription.cancel();
    _controller.close();
    crudTableState = null;
  }
}
