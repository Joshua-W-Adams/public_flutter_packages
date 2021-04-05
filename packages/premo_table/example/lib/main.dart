import 'package:example/services/mockDataService.dart';
import 'package:flutter/material.dart';
import 'package:premo_table/premo_table.dart';
import 'models/sampleDataModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: SampleCRUDTableBuilder(),
        ),
      ),
    );
  }
}

class SampleCRUDTableBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// create sample array of data
    List<SampleDataModel> data = [
      SampleDataModel(id: '1', name: 'Josh', age: 32),
      SampleDataModel(id: '2', name: 'Rachel', age: 27),
      SampleDataModel(id: '3', name: 'Shannon', age: 35),
    ];

    /// generate data service that provide stream of mocked server data
    MockDataService<SampleDataModel> mockDataStream =
        MockDataService(data: data);

    /// create BLoC with mocked service
    CrudTableBloc<SampleDataModel> _crudTableBloc = CrudTableBloc(
      inputStream: mockDataStream.stream,
    );

    /// generate instance of table
    return CrudTable<SampleDataModel>(
      crudTableBloc: _crudTableBloc,
      columnNames: [
        'Id',
        'Name',
        'Age',
      ],
      columnWidths: [75.0, 200.0, 75.0],
      editableColumns: [false, true, true],
      columnAlignments: [TextAlign.center, TextAlign.left, TextAlign.center],
      columnDataFormats: ['text', 'text', 'text'],
      columnTypes: ['standard', 'standard', 'standard'],
      columnDropdownLists: [null, null, null],
      // cellTextStyleBuilder: (item, row, col) {
      //   /// return some TextStyle override if necessary
      //   return null;
      // },
      // columnValidators: [null, null, null],
      cellValueBuilder: (item, row, col) {
        if (col == 0) {
          return item.id;
        } else if (col == 1) {
          return item.name;
        } else {
          return item.age?.toString();
        }
      },
      // cellWidgetBuilder: (item, row, col) {
      /// replace entire widget in a specific cell
      // return Widget;
      // },
      // onAdd: () async {
      /// create new item template
      // TransactionItemModel item = TransactionItemModel(
      //   id: 'pending',
      //   parentId: widget.parentTransactionItemId,
      //   dateAdded: DateTime.now(),
      // );

      /// add budget item to server
      // await _db.addTransactionItem(
      //   budgetId: widget.budgetId,
      //   item: item,
      // );
      // },
      // onDelete: (item, _) async {
      // await _db.deleteSingleTransactionItem(
      //   budgetId: widget.budgetId,
      //   transactionItemId: item.id,
      // );
      // },
      onUpdate: (item, value, _, col) async {
        /// store item details in model instance
        if (col == 0) {
          /// N/A - non editable column
        } else if (col == 1) {
          item.name = value;
        } else {
          item.age = num.tryParse(value);
        }

        /// update item to database
        // _db.updateTransactionItem(
        //   budgetId: widget.budgetId,
        //   item: item,
        // );
      },
      // rowKeyBuilder: (item, _) {
      //   /// Use transaction item doc identifier as the unique key for a row
      //   /// prevents on change cell functions firing on removal of existing
      //   /// rows.
      //   return item.id;
      // },
    );
  }
}
