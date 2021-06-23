part of general_widgets;

/// [CrudListBuilder] is essentially a stream builder with generic handling of
/// errors, missing data and connection state management. All callback functions
/// and item builders to perform CRUD operations are simply passed through to
/// the [CrudList].
class CrudListBuilder<T> extends StatelessWidget {
  final Stream<List<T>> stream;
  final void Function(T selectedItem)? onSelectCallback;
  final void Function()? addNewItemCallback;
  final Future<void> Function(T deletedItem)? deleteItemCallback;
  final void Function()? forInformationCallback;
  final SelectableListItem Function(T item) selectableListItemBuilder;
  final String? addNewItemText;
  final String? deleteItemText;
  final String? forInformationText;

  CrudListBuilder({
    Key? key,
    required this.stream,
    this.onSelectCallback,
    this.addNewItemCallback,
    this.deleteItemCallback,
    this.forInformationCallback,
    required this.selectableListItemBuilder,
    this.addNewItemText,
    this.deleteItemText,
    this.forInformationText,
  }) : super(key: key);

  Widget _loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<T>>(
      stream: stream,
      builder: (_, _snapshot) {
        if (_snapshot.connectionState == ConnectionState.waiting) {
          // case 1 - Awaiting connection
          return _loading();
        } else if (_snapshot.hasError) {
          // case 2 - error in snapshot
          return ShowError(
            error: _snapshot.error.toString(),
          );
        } else if (!_snapshot.hasData) {
          // case 3 - no data in snapshot - awaiting to recieve results
          return _loading();
        } else {
          // case 4 - data recieved - load crud list
          return CrudList<T>(
            items: _snapshot.data!,
            onSelectCallback: onSelectCallback,
            addNewItemCallback: addNewItemCallback,
            deleteItemCallback: deleteItemCallback,
            forInformationCallback: forInformationCallback,
            selectableListItemBuilder: selectableListItemBuilder,
            addNewItemText: addNewItemText,
            deleteItemText: deleteItemText,
            forInformationText: forInformationText,
          );
        }
      },
    );
  }
}

/// [CrudList] is an abstract ui for managing CRUD operations on lists connected
/// to a server. All business logic for ui operations are passed through as
/// callback functions.
class CrudList<T> extends StatefulWidget {
  final List<T> items;
  final void Function(T selectedItem)? onSelectCallback;
  final void Function()? addNewItemCallback;
  final Future<void> Function(T deletedItem)? deleteItemCallback;
  final void Function()? forInformationCallback;
  final SelectableListItem Function(T item) selectableListItemBuilder;
  final String? addNewItemText;
  final String? deleteItemText;
  final String? forInformationText;

  CrudList({
    Key? key,
    required this.items,
    this.onSelectCallback,
    this.addNewItemCallback,
    this.deleteItemCallback,
    this.forInformationCallback,
    required this.selectableListItemBuilder,
    this.addNewItemText = 'Add new item',
    this.deleteItemText = 'Delete item',
    this.forInformationText = 'More information',
  }) : super(key: key);

  @override
  _CrudListState<T> createState() => _CrudListState<T>();
}

class _CrudListState<T> extends State<CrudList<T>> {
  late List<T> _items;
  SelectableListItem? _selectedItem;
  bool _requestPending = false;

  @override
  void initState() {
    // clean up variable declaration
    _items = widget.items;
    super.initState();
  }

  // Stateful widgets do not fire the build function when flutter walks the
  // already constructed widget tree. Therefore on the all subsequent builds of
  // this widget by the parent stream builder we need to call the setState
  // method when the item list changes to force a rebuild of this widget.
  @override
  void didUpdateWidget(CrudList<T> oldWidget) {
    // detected change to the item list
    if (_items != widget.items) {
      setState(() {
        _items = widget.items;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  /// [_processRequest] is a generic ui function for handling server requests.
  /// Preventing users from performing additional requests while one is
  /// processing and also displaying success and error messages to the user.
  void _processRequest({
    required BuildContext context,
    required Future<void> requestFuture,
  }) {
    // check if request has already been issued to database
    if (!_requestPending) {
      // prevent user sending additional request while like is already underway
      setState(() {
        _requestPending = true;
      });
      // perform request
      requestFuture.then((_) async {
        // request successful
        setState(() {
          _requestPending = false;
        });
        // inform user of successful request
        ScaffoldMessengerState scaffoldMessengerState =
            ScaffoldMessenger.of(context);
        scaffoldMessengerState.showSnackBar(
          SnackBar(
            content: Text(
              'Request to server completed successfully.',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
          ),
        );
        // await showAlertDialog(
        //   context: context,
        //   title: 'Succeeded',
        //   content: 'Request to server complete.',
        //   defaultActionText: 'Close',
        // );
      }).catchError((e) async {
        // request complete. allow user to send new request.
        setState(() {
          _requestPending = false;
        });
        // inform user of failed request
        await showExceptionAlertDialog(
          context: context,
          title: 'Failed',
          exception: e,
        );
      });
    }
    // pending result of request. Do nothing.
  }

  SelectableListItem? _getSelectedItem(List<SelectableListItem> items) {
    for (var i = 0; i < items.length; i++) {
      SelectableListItem item = items[i];
      if (item.selected == true) {
        return item;
      }
    }
    return null;
  }

  Widget _getSelectableList() {
    // No data on server
    if (_items.length == 0) {
      return Center(
        child: Text(''),
      );
    }
    return SelectableListView<T>(
      list: _items,
      selectableItemBuilder: widget.selectableListItemBuilder,
      multipleSelection: false,
      onSelectedCallback: (selectableItems) {
        setState(() {
          _selectedItem = _getSelectedItem(selectableItems!);
        });
        widget.onSelectCallback?.call(_selectedItem?.extraData);
      },
    );
  }

  Widget _getAddNewItem(BuildContext context, ThemeData theme) {
    if (widget.addNewItemCallback == null) {
      return Container();
    }
    return ListTile(
      title: Text('${widget.addNewItemText}'),
      leading: Icon(
        Icons.add_circle_outline,
        color: theme.primaryColor,
      ),
      onTap: widget.addNewItemCallback ?? () {},
    );
  }

  Widget _getDeleteCard() {
    if (widget.deleteItemCallback == null) {
      return Container();
    }
    return ListTile(
      title: Text('${widget.deleteItemText}'),
      leading: Icon(
        Icons.delete_outline,
        color: Colors.red,
      ),
      enabled: _selectedItem != null ? !_requestPending : false,
      onTap: _selectedItem == null
          ? null
          : () {
              _processRequest(
                context: context,
                requestFuture: widget.deleteItemCallback!(
                  _selectedItem!.extraData,
                ),
              );
            },
    );
  }

  Widget _getInfoButton(ThemeData theme) {
    if (widget.forInformationCallback == null) {
      return Container();
    }
    return ListTile(
      title: Text('${widget.forInformationText}'),
      leading: Icon(
        Icons.info,
        color: theme.primaryColor,
      ),
      onTap: widget.forInformationCallback,
    );
  }

  Widget _getDivider(ThemeData theme) {
    if (widget.forInformationCallback != null ||
        widget.deleteItemCallback != null ||
        widget.addNewItemCallback != null) {
      return Divider(color: theme.accentColor);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        _getAddNewItem(context, theme),
        _getDeleteCard(),
        _getInfoButton(theme),
        _getDivider(theme),
        Expanded(child: _getSelectableList()),
      ],
    );
  }
}
