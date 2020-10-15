part of general_widgets;

class SelectableListView extends StatefulWidget {
  final List<SelectableListItem> list;
  final bool multipleSelection;
  final Function(List<SelectableListItem> items) onSelectedCallback;

  SelectableListView({
    Key key,
    @required this.list,
    this.multipleSelection = false,
    this.onSelectedCallback,
  }) : super(key: key);
  @override
  _SelectableListViewState createState() => _SelectableListViewState();
}

class _SelectableListViewState extends State<SelectableListView> {
  bool _multipleSelection;
  List<SelectableListItem> _list;
  Function(List<SelectableListItem> items) _onSelectedCallback;

  @override
  void initState() {
    _list = widget.list;
    _multipleSelection = widget.multipleSelection;
    _onSelectedCallback = widget.onSelectedCallback;
    super.initState();
  }

  void setSelectedValue(int index) {
    if (!_multipleSelection) {
      // case 1 - single selectable items
      for (var i = 0; i < _list.length; i++) {
        if (i == index) {
          // set new items selection status
          _list[index].selected = !_list[index].selected;
        } else {
          // reset selection status on all other items
          _list[i].selected = false;
        }
      }
    } else {
      // case 2 - multiple selectable items
      _list[index].selected = !_list[index].selected;
    }
  }

  bool getSelectionStatus(int index) {
    return _list[index].selected;
  }

  Widget _getLeading(int index) {
    Widget _leading = _list[index].leading;
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
      itemCount: _list.length,
      itemBuilder: (context, index) {
        bool _selected = getSelectionStatus(index);
        return ListTile(
          onTap: () {
            setState(() {
              setSelectedValue(index);
              if (_onSelectedCallback is Function) {
                _onSelectedCallback(_list);
              }
            });
          },
          selected: _selected,
          leading: _getLeading(index),
          title: Text('${_list[index].title}'),
          subtitle: Text('${_list[index].subtitle}'),
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
