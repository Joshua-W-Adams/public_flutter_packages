part of general_widgets;

class SelectableListView<T> extends StatefulWidget {
  final List<T> list;
  final SelectableListItem Function(T item) selectableItemBuilder;
  final bool multipleSelection;
  final Function(List<SelectableListItem> items) onSelectedCallback;

  SelectableListView({
    Key key,
    @required this.list,
    @required this.selectableItemBuilder,
    this.multipleSelection = false,
    this.onSelectedCallback,
  }) : super(key: key);
  @override
  _SelectableListViewState<T> createState() => _SelectableListViewState<T>();
}

class _SelectableListViewState<T> extends State<SelectableListView<T>> {
  bool _multipleSelection;
  List<T> _list;
  List<SelectableListItem> _selectableList;
  Function(List<SelectableListItem> items) _onSelectedCallback;

  @override
  void initState() {
    _list = widget.list;
    _multipleSelection = widget.multipleSelection;
    _onSelectedCallback = widget.onSelectedCallback;
    _setSelectableList();
    super.initState();
  }

  @override
  void didUpdateWidget(SelectableListView oldWidget) {
    // check for change in underlying data model
    if (_list != widget.list) {
      setState(() {
        _list = widget.list;
        _multipleSelection = widget.multipleSelection;
        _onSelectedCallback = widget.onSelectedCallback;
        _setSelectableList();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _setSelectableList() {
    _selectableList = [];
    for (var i = 0; i < _list.length; i++) {
      // convert data model to selectable item
      SelectableListItem sItem = widget.selectableItemBuilder(_list[i]);
      _selectableList.add(sItem);
    }
  }

  void setSelectedValue(int index) {
    if (!_multipleSelection) {
      // case 1 - single selectable items
      for (var i = 0; i < _selectableList.length; i++) {
        if (i == index) {
          // set new items selection status
          _selectableList[index].selected = !_selectableList[index].selected;
        } else {
          // reset selection status on all other items
          _selectableList[i].selected = false;
        }
      }
    } else {
      // case 2 - multiple selectable items
      _selectableList[index].selected = !_selectableList[index].selected;
    }
  }

  bool getSelectionStatus(int index) {
    return _selectableList[index].selected;
  }

  Widget _getLeading(int index) {
    Widget _leading = _selectableList[index].leading;
    if (_leading == null) {
      return _leading;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 32,
          child: _leading,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _selectableList.length,
      itemBuilder: (context, index) {
        bool _selected = getSelectionStatus(index);
        return ListTile(
          onTap: () {
            setState(() {
              setSelectedValue(index);
              if (_onSelectedCallback is Function) {
                _onSelectedCallback(_selectableList);
              }
            });
          },
          selected: _selected,
          leading: _getLeading(index),
          title: Text('${_selectableList[index].title}'),
          subtitle: Text('${_selectableList[index].subtitle}'),
          trailing: _selected
              ? Icon(Icons.check_box)
              : Icon(Icons.check_box_outline_blank),
        );
      },
    );
  }
}

class SelectableListItem {
  final String id;
  final String title;
  final String subtitle;
  final Widget leading;
  final dynamic extraData;
  bool selected;

  SelectableListItem({
    this.id = '',
    this.title = '',
    this.subtitle = '',
    this.leading,
    this.extraData,
    this.selected = false,
  });
}
