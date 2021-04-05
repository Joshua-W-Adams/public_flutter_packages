part of premo_table;

/// [CrudTable] is a generic widget that extends the base [BetterTable] widget
/// with CRUD (Create, Read, Update, Delete) operations to a connected stream.
///
/// It also adds various other functionality including, but not limited to:
/// - Standardised formatting for all cells using the various contructors from
/// the [Cell] class
/// - Selected cell highlighting
class CrudTable<T> extends StatelessWidget {
  /// BloC component that manages CrudTable state
  final CrudTableBloc crudTableBloc;

  /// Column based configuration options
  final List<String> columnNames;
  final List<double> columnWidths;
  final List<bool> editableColumns;
  final List<TextAlign> columnAlignments;
  final List<String> columnDataFormats;
  final List<String> columnTypes;
  final List<List<String>> columnDropdownLists;
  final List<Function(String)> columnValidators;

  /// callback function for generating a cell value based on generic data model
  /// streamed through
  final String Function(T item, int row, int col) cellValueBuilder;

  /// callback function for generating a cell widget based on generic data model
  /// streamed through
  final Widget Function(T item, int row, int col) cellWidgetBuilder;

  /// Cell based configuration options
  final TextStyle Function(T item, int row, int col) cellTextStyleBuilder;

  /// CRUD operations
  final Function onAdd;
  final Function(T item, int row) onDelete;
  final Function(T item, String value, int row, int col) onUpdate;

  /// Conditionally assign unique keys to [BetterTable] rows for clearing child
  /// widget state on deletion of rows
  final String Function(T item, int row) rowKeyBuilder;

  CrudTable({
    Key key,
    @required this.crudTableBloc,
    @required this.columnNames,
    this.columnWidths,
    this.editableColumns,
    this.columnAlignments,
    this.columnDataFormats,
    this.columnTypes,
    this.columnDropdownLists,
    this.columnValidators,
    @required this.cellValueBuilder,
    this.cellWidgetBuilder,
    this.cellTextStyleBuilder,
    this.onAdd,
    this.onDelete,
    this.onUpdate,
    this.rowKeyBuilder,
  }) : super(key: key);

  /// [_getCellBorders] returns a standardised design for all cell borders
  Border _getCellBorders(Color borderColor) {
    return Border(
      right: BorderSide(
        color: borderColor,
      ),
      bottom: BorderSide(
        color: borderColor,
      ),
    );
  }

  /// [_getCellColor] returns the color of a cell based on its selected status
  Color _getCellColor(
    int row,
    int col,
    int selectedRow,
    int selectedColumn,
    Color defaultColor,
    Color highlightedColor,
  ) {
    if (row == selectedRow && col == selectedColumn) {
      /// case 1 - selected cell
      return highlightedColor;
    }

    /// case 2 - unselected
    return defaultColor;
  }

  /// [_getColumnHeaderDecoration] returns a standardised design for column
  /// headers based on the selected cell's column
  BoxDecoration _getColumnHeaderDecoration(
    int col,
    int selectedColumn,
    Color headerColor,
    Color highlightedCellColor,
    Color cellBorderColor,
    Color highlightedCellBorderColor,
  ) {
    if (col == selectedColumn) {
      /// case 1 - selected column
      return BoxDecoration(
        color: highlightedCellColor,
        border: Border(
          top: BorderSide(
            color: cellBorderColor,
          ),
          right: BorderSide(
            color: cellBorderColor,
          ),
          bottom: BorderSide(
            color: highlightedCellBorderColor,
            width: 4,
          ),
        ),
      );
    } else {
      /// case 2 - otherwise
      return BoxDecoration(
        color: headerColor,
        border: Border(
          top: BorderSide(
            color: cellBorderColor,
          ),
          right: BorderSide(
            color: cellBorderColor,
          ),
          bottom: BorderSide(
            color: cellBorderColor,
          ),
        ),
      );
    }
  }

  /// [_getRowHeaderDecoration] returns a standardised design for row headers
  /// based on the selected cell's row
  BoxDecoration _getRowHeaderDecoration(
    int row,
    int selectedRow,
    Color highlightedCellColor,
    Color highlightedCellBorderColor,
    Color borderColor,
  ) {
    if (row == selectedRow) {
      /// case 1 - selected row
      return BoxDecoration(
        color: highlightedCellColor,
        border: Border(
          right: BorderSide(
            color: highlightedCellBorderColor,
            width: 4,
          ),
        ),
      );
    } else {
      /// case 2 - otherwise
      return BoxDecoration(
        border: Border(
          right: BorderSide(
            color: borderColor,
          ),
        ),
      );
    }
  }

  ///
  /// Default assignments for constructor properties
  ///

  double _getColumnWidth(int col) {
    if (columnWidths != null) {
      return columnWidths[col];
    }
    return 125.0;
  }

  bool _getColumnIsEditable(int col) {
    if (editableColumns != null) {
      return editableColumns[col];
    }
    return true;
  }

  TextAlign _getColumnAlignment(int col) {
    if (columnAlignments != null) {
      return columnAlignments[col];
    }
    return TextAlign.center;
  }

  String _getColumnDataFormat(int col) {
    if (columnDataFormats != null) {
      return columnDataFormats[col];
    }
    return 'text';
  }

  String _getColumnType(int col) {
    if (columnTypes != null) {
      return columnTypes[col];
    }
    return 'standard';
  }

  List<String> _getColumnDropdownList(int col) {
    if (columnDropdownLists != null) {
      return columnDropdownLists[col];
    }
    return null;
  }

  Function(String) _getColumnValidator(int col) {
    if (columnValidators != null) {
      return columnValidators[col];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    /// properties to standardise colours across table instance
    ThemeData _theme = Theme.of(context);
    Color _cellBorderColor = _theme.primaryColor;
    Color _headerColor = _theme.accentColor.withOpacity(0.25);
    Color _disabledCellColor = _theme.accentColor.withOpacity(0.25);
    Color _highlightedCellColor = _theme.accentColor.withOpacity(0.5);
    Color _highlightedCellBorderColor = _theme.accentColor;

    return StreamBuilder<CrudTableState>(
      stream: crudTableBloc.stream,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          /// case 1 - awaiting connection
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          /// case 2 - error in snapshot
          return ShowError(
            error: '${snapshot.error.toString()}',
          );
        } else if (!snapshot.hasData) {
          /// case 3 - no data return
          return ShowError(
            error: 'Error: No data recieved from server',
          );
        }

        /// case 4 - all verification checks passed.

        /// store current state
        CrudTableState crudTableState = snapshot.data;

        return BetterTable(
          columnsLength: columnNames.length,

          /// add additional row onto table to allow for 'add row' functionality
          rowsLength: crudTableState.data.length + (onAdd != null ? 1 : 0),
          // stickToColumn: 0,
          // enableColHeaders: true,
          // enableRowHeaders: true,

          /// Conditional unique key assignment to row to prevent child widget
          /// state being persisted on row deletion
          rowKeyBuilder: rowKeyBuilder != null
              ? (row) {
                  String key;

                  /// no key generation required for last row
                  if (row != crudTableState.data.length) {
                    /// get item associated to current cell
                    T item = crudTableState.data[row];

                    /// get key from item
                    key = rowKeyBuilder(item, row);
                  }

                  return key;
                }
              : null,

          /// *********** cell at position 0,0 ***********
          legendCell: Cell.legend(
            value: '',
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: _cellBorderColor,
                ),
              ),
            ),
            onTap: () {
              crudTableBloc.deselectCell();
            },
          ),

          /// *********** COLUMN HEADERS ***********
          columnHeadersBuilder: (col) {
            return Cell.columnHeader(
              value: columnNames[col],
              width: _getColumnWidth(col),
              decoration: _getColumnHeaderDecoration(
                col,
                crudTableState.selectedColumn,
                _headerColor,
                _highlightedCellColor,
                _cellBorderColor,
                _highlightedCellBorderColor,
              ),
              onTap: () {
                crudTableBloc.deselectCell();
              },
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            );
          },

          /// *********** ROW HEADERS ***********
          rowHeadersBuilder: (row) {
            /// case 1 - add new item row
            if (row == crudTableState.data.length) {
              return Cell.rowHeader(
                contentWidget: IconButton(
                  icon: Icon(
                    Icons.add,
                  ),
                  color: Colors.green,
                  onPressed: () async {
                    /// generic on add functionality
                    crudTableBloc.deselectCell();

                    if (onAdd != null) {
                      await onAdd();
                    }
                  },
                ),
                decoration: _getRowHeaderDecoration(
                  row,
                  crudTableState.selectedRow,
                  _highlightedCellColor,
                  _highlightedCellBorderColor,
                  Colors.transparent,
                ),
              );
            }

            /// get current item
            T item = crudTableState.data[row];

            /// case 2 - otherwise
            return Cell.rowHeader(
              contentWidget: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () async {
                  /// default on delete functionality
                  crudTableBloc.deselectCell();

                  if (onDelete != null) {
                    /// user specific on delete functionality
                    onDelete(item, row);
                  }
                },
              ),
              decoration: _getRowHeaderDecoration(
                row,
                crudTableState.selectedRow,
                _highlightedCellColor,
                _highlightedCellBorderColor,
                _cellBorderColor,
              ),
            );
          },

          /// *********** CONTENT ***********
          contentCellBuilder: (col, row) {
            /// case 1 - add new item row
            if (row == crudTableState.data.length) {
              return Cell.content(
                value: '',
                width: _getColumnWidth(col),
                textAlign: _getColumnAlignment(col),
                isEditable: false,
                decoration: BoxDecoration(
                  color: _getCellColor(
                    row,
                    col,
                    crudTableState.selectedRow,
                    crudTableState.selectedColumn,
                    _disabledCellColor,
                    _highlightedCellColor,
                  ),
                ),
                onTap: () {
                  crudTableBloc.selectCell(row, col);
                },
              );
            }

            /// get item associated to current cell
            T item = crudTableState.data[row];

            /// case 2 - otherwise
            return Cell.content(
              value: cellValueBuilder(item, row, col),
              contentWidget: cellWidgetBuilder != null
                  ? cellWidgetBuilder(item, row, col)
                  : null,
              type: _getColumnType(col),
              dataFormat: _getColumnDataFormat(col),
              dropdownList: _getColumnDropdownList(col),
              width: _getColumnWidth(col),
              isEditable: _getColumnIsEditable(col),
              textStyle: cellTextStyleBuilder != null
                  ? cellTextStyleBuilder(item, row, col)
                  : null,
              textAlign: _getColumnAlignment(col),
              decoration: BoxDecoration(
                color: _getCellColor(
                  row,
                  col,
                  crudTableState.selectedRow,
                  crudTableState.selectedColumn,
                  Colors.transparent,
                  _highlightedCellColor,
                ),
                border: _getCellBorders(_cellBorderColor),
              ),
              onEditingComplete: (value) {
                if (onUpdate != null) {
                  /// execute user specific callback functionality
                  onUpdate(item, value, row, col);
                }
              },
              onTap: () {
                crudTableBloc.selectCell(row, col);
              },
              validator: _getColumnValidator(col),
            );
          },
        );
      },
    );
  }
}
