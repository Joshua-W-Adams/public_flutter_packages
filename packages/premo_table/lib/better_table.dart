part of premo_table;

/// [BetterTable] is a ui widget intended to produce a fully customisable table
/// or spreadsheet. It supports sticky column and row headers (if you scroll
/// content horizontally or vertically column and row headers always stay),
/// custom builder widgets for all elements of the table and various other
/// functionality.
///
/// In terms of its layout. It is divided into four main sections as follows:
/// - Top Left Quarter:
///   Legend cell and sticky column headers.
/// - Top Right Quarter:
///   Scrollable column headers.
/// - Bottom Left Quarter:
///   Row headers and sticky row cells.
/// - Bottom Right Quarter:
///   Scrollable row cells.
/// Each section is wrapped in a [SingleChildScrollView] as required to stick /
/// freeze the appropriate section.
class BetterTable extends StatefulWidget {
  final int rowsLength;
  final int columnsLength;
  final int stickToColumn;
  final bool enableRowHeaders;
  final bool enableColHeaders;
  final Widget legendCell;
  final Widget Function(int colulmnIndex) columnHeadersBuilder;
  final Widget Function(int rowIndex) rowHeadersBuilder;
  final Widget Function(int columnIndex, int rowIndex) contentCellBuilder;
  final String Function(int rowIndex) rowKeyBuilder;

  BetterTable({
    Key key,

    /// Number of Columns
    @required this.columnsLength,

    /// Number of Rows
    @required this.rowsLength,

    /// Stick all columns up to this column to the side of the table
    this.stickToColumn,

    /// Enable or disable row headers in the table
    this.enableRowHeaders = true,

    /// Enable or disable col headers in the table
    this.enableColHeaders = true,

    /// Top left cell
    this.legendCell = const Text(''),

    /// Builder for column headers. Takes index of column as parameter and
    /// returns a widget for displaying in column header
    @required this.columnHeadersBuilder,

    /// Builder for row headers. Takes index of row as parameter and returns a
    /// widget for displaying in row header
    @required this.rowHeadersBuilder,

    /// Builder for content cells. Takes indexes for column and row and returns
    /// a widget for displaying in cell
    @required this.contentCellBuilder,

    /// Expects a unique string identifier to be returned. This unique string is
    /// used to create a map of unique keys for each row in the bottom half of
    /// the [BetterTable]. Enables more refined state management over the table.
    /// For example the state can be cleared or persisted on adding and
    /// removing rows from the table.
    this.rowKeyBuilder,
  }) : super(key: key) {
    assert(columnsLength != null);
    assert(rowsLength != null);
    assert(columnHeadersBuilder != null);
    assert(rowHeadersBuilder != null);
    assert(contentCellBuilder != null);
  }

  @override
  _BetterTableState createState() => _BetterTableState();
}

class _BetterTableState extends State<BetterTable> {
  final ScrollController _verticalRowHeadersController = ScrollController();
  final ScrollController _verticalContentController = ScrollController();

  final ScrollController _horizontalColHeadersController = ScrollController();
  final ScrollController _horizontalContentController = ScrollController();

  _SyncScrollController _verticalSyncController;
  _SyncScrollController _horizontalSyncController;

  Row _q1TopLeftColHeaders;
  Row _q2TopRightColHeaders;
  List<Widget> _q3BottomLeftRowHeaders = [];
  List<Widget> _q4BottomRightCells = [];

  Map<String, List<UniqueKey>> _rowKeys = Map<String, List<UniqueKey>>();

  @override
  void initState() {
    super.initState();
    _verticalSyncController = _SyncScrollController(
      [
        _verticalRowHeadersController,
        _verticalContentController,
      ],
    );
    _horizontalSyncController = _SyncScrollController(
      [
        _horizontalColHeadersController,
        _horizontalContentController,
      ],
    );
  }

  @override
  void dispose() {
    _verticalRowHeadersController.dispose();
    _verticalContentController.dispose();
    _horizontalColHeadersController.dispose();
    _horizontalContentController.dispose();
    _verticalSyncController = null;
    _horizontalSyncController = null;
    _q1TopLeftColHeaders = null;
    _q2TopRightColHeaders = null;
    _q3BottomLeftRowHeaders = null;
    _q4BottomRightCells = null;
    _rowKeys = null;
    super.dispose();
  }

  void _clearGlobalConfig() {
    _q1TopLeftColHeaders = null;
    _q2TopRightColHeaders = null;
    _q3BottomLeftRowHeaders = [];
    _q4BottomRightCells = [];
  }

  List<UniqueKey> _getUniqueRowKeys(
    String uniqueKey,
  ) {
    List<UniqueKey> keys;

    if (_rowKeys[uniqueKey] == null) {
      /// case 1 - create key if id does not exist
      keys = [
        UniqueKey(),
        UniqueKey(),
      ];
    } else {
      /// case 2 - return current keys
      keys = _rowKeys[uniqueKey];
    }

    return keys;
  }

  /// [_buildTableQuarters] is the main method that runs everytime the @build
  /// method is initiated. This method will construct all the widgets required
  /// to build each quarter of [BetterTable].
  void _buildTableQuarters() {
    // check global configuration options - i.e. legend cell display settings
    _clearGlobalConfig();
    // loop through table
    for (int row = 0; row < widget.rowsLength; row++) {
      List<Widget> q1Cells = [];
      List<Widget> q2Cells = [];
      List<Widget> q3Cells = [];
      List<Widget> q4Cells = [];
      // case 1 - row and column headers enabled
      if (row == 0 && widget.enableColHeaders && widget.enableRowHeaders) {
        q1Cells.add(widget.legendCell);
      }
      // case 2 - row headers enabled only
      // no specific config required
      // case 3 - col headers enabled only
      // no specific config required
      // case 4 - no row or column headers
      // no specific config required
      for (int col = 0; col < widget.columnsLength; col++) {
        // build TOP HALF - table headers
        if (row == 0 && widget.enableColHeaders == true) {
          if (widget.stickToColumn != null && col <= widget.stickToColumn) {
            // build q1 - sticky headers
            q1Cells.add(widget.columnHeadersBuilder(col));
          } else {
            // build q2 - scrollable headers
            q2Cells.add(widget.columnHeadersBuilder(col));
          }
        }
        // build BOTTOM HALF - table content
        // handle enabled row headers
        if (col == 0 && widget.enableRowHeaders == true) {
          q3Cells.add(widget.rowHeadersBuilder(row));
        }
        if (widget.stickToColumn != null && col <= widget.stickToColumn) {
          // build q3 - sticky row headers
          q3Cells.add(widget.contentCellBuilder(col, row));
        } else {
          // build q4 - scrollable cell content
          q4Cells.add(widget.contentCellBuilder(col, row));
        }
      }
      // add cells to row and store in quarter
      if (row == 0 && widget.enableColHeaders == true) {
        _q1TopLeftColHeaders = Row(children: q1Cells);
        _q2TopRightColHeaders = Row(children: q2Cells);
      }
      // generate unique keys to assign to rows
      List<UniqueKey> keys;
      if (widget.rowKeyBuilder != null) {
        // get user specified unique string identifier
        String key = widget.rowKeyBuilder(row);
        keys = _getUniqueRowKeys(
          key,
        );
        // update map with keys
        _rowKeys[key] = keys;
      }
      _q3BottomLeftRowHeaders.add(
        Row(key: keys != null ? keys[0] : null, children: q3Cells),
      );
      _q4BottomRightCells.add(
        Row(key: keys != null ? keys[1] : null, children: q4Cells),
      );
    }
  }

  Widget _getTopHalf() {
    Widget q1 = _q1TopLeftColHeaders;
    Widget q2 = _q2TopRightColHeaders;
    if (!widget.enableColHeaders) {
      // case 1 - col headers disabled
      q1 = Container();
      q2 = Container();
    }
    // case 2 - col headers enabled
    return Row(
      children: <Widget>[
        // TOP LEFT
        // Q1 - Sticky column headers and legend cell
        q1,
        // TOP RIGHT
        // SCROLLABLE column headers
        Expanded(
          child: NotificationListener<ScrollNotification>(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: q2,
              controller: _horizontalColHeadersController,
            ),
            onNotification: (ScrollNotification notification) {
              _horizontalSyncController.processNotification(
                notification,
                _horizontalColHeadersController,
              );
              return true;
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // build four main sections of table
    _buildTableQuarters();
    return Column(
      children: <Widget>[
        // TOP HALF
        _getTopHalf(),
        // BOTTOM HALF
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // BOTTOM LEFT
              // q3 - Sticky row headers
              NotificationListener<ScrollNotification>(
                child: SingleChildScrollView(
                  child: Column(
                    children: _q3BottomLeftRowHeaders,
                  ),
                  controller: _verticalRowHeadersController,
                ),
                onNotification: (ScrollNotification notification) {
                  _verticalSyncController.processNotification(
                    notification,
                    _verticalRowHeadersController,
                  );
                  return true;
                },
              ),
              // BOTTOM RIGHT
              // q4 - Scrollable cell content
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalContentController,
                    child: NotificationListener<ScrollNotification>(
                      child: SingleChildScrollView(
                        controller: _verticalContentController,
                        child: Column(
                          children: _q4BottomRightCells,
                        ),
                      ),
                      onNotification: (ScrollNotification notification) {
                        _verticalSyncController.processNotification(
                          notification,
                          _verticalContentController,
                        );
                        return true;
                      },
                    ),
                  ),
                  onNotification: (ScrollNotification notification) {
                    _horizontalSyncController.processNotification(
                      notification,
                      _horizontalContentController,
                    );
                    return true;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// [SyncScrollController] keeps scroll controllers in sync.
class _SyncScrollController {
  final List<ScrollController> _registeredScrollControllers = [];
  ScrollController _scrollingController;
  bool _scrollingActive = false;

  _SyncScrollController(List<ScrollController> controllers) {
    controllers.forEach((controller) {
      return _registeredScrollControllers.add(controller);
    });
  }

  processNotification(
    ScrollNotification notification,
    ScrollController sender,
  ) {
    if (notification is ScrollStartNotification && !_scrollingActive) {
      _scrollingController = sender;
      _scrollingActive = true;
      return;
    }

    if (identical(sender, _scrollingController) && _scrollingActive) {
      if (notification is ScrollEndNotification) {
        _scrollingController = null;
        _scrollingActive = false;
        return;
      }

      if (notification is ScrollUpdateNotification) {
        for (ScrollController controller in _registeredScrollControllers) {
          if (identical(_scrollingController, controller)) continue;
          controller.jumpTo(_scrollingController.offset);
        }
      }
    }
  }
}
