part of premo_table;

/// [Cell] is a generic widget for displaying any type of cell in a table. Be it
/// a content cell, column header, row header or the special case legend cell
/// (position 0,0).
///
/// Cell is effectively an extension of the [TextFormField] base flutter class.
class Cell extends StatefulWidget {
  final String value;
  final double width;
  final double height;
  final bool visible;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final Alignment cellAlignment;
  final BoxDecoration decoration;
  final Function onTap;
  final bool isEditable;
  final bool enabled;
  final void Function(String value) onEditingComplete;

  /// padding for container that wraps each type of cell. Note that onClick
  /// events will not operate if the user clicks on this area of padding.
  final EdgeInsetsGeometry padding;

  /// contentPadding will override the input decoratation content padding values
  /// for the textFormField and Switch cell types. For dropdowns the padding
  /// will be applied to each dropdown element.
  final EdgeInsetsGeometry contentPadding;

  final bool isDense;
  final String dataFormat;
  final String Function(String) validator;
  final int minLines;
  final int maxLines;
  final TextInputType keyboardType;
  // label text, hint text, helper text, prefix icon, suffix icon
  final InputDecoration inputDecoration;
  final void Function(String) onChanged;
  final bool supressDidUpdateWidget;

  /// if dropdown list is specified a form field with a dropdown button will be
  /// returned in preference to a standard text form field.
  final List<String> dropdownList;

  /// Type of cell to be returned. Currently supported types are standard,
  /// dropdown and switch
  final String type;

  /// Will override the cell value displayed and make any revelant properties
  /// redundant. Enables populating cells with other widgets, such as icons.
  final Widget contentWidget;

  /// default function defination for all cell callback functions to handle null
  /// case in user provided callbacks
  static void defaultOnTap() {}
  static void defaultOnEditingComplete(String value) {}
  static void defaultOnChanged(String value) {}

  /// [Cell.content] is a named constructor for building a content cell in a
  /// table, i.e. any cell that is not a row header, column header or legend.
  Cell.content({
    Key key,
    this.value,
    this.width = 70,
    this.height = 50,
    this.visible = true,
    this.textStyle,
    this.textAlign = TextAlign.center,
    this.cellAlignment = Alignment.centerLeft,
    this.decoration = const BoxDecoration(
      border: Border(
        right: BorderSide(
          color: Colors.grey,
        ),
        bottom: BorderSide(
          color: Colors.grey,
        ),
      ),
    ),
    this.onTap = defaultOnTap,
    this.isEditable = true,
    this.enabled = true,
    this.onEditingComplete = defaultOnEditingComplete,
    this.contentWidget,
    this.padding,
    this.contentPadding = const EdgeInsets.only(
      left: 4.0,
      right: 4.0,
      top: 2.0,
      bottom: 2.0,
    ),
    this.isDense = false,
    this.dataFormat = 'text',
    this.validator,
    this.minLines,
    this.maxLines,
    this.keyboardType = TextInputType.text,
    this.inputDecoration = const InputDecoration(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(0),
    ),
    this.onChanged = defaultOnChanged,
    this.supressDidUpdateWidget = false,
    this.dropdownList,
    this.type = 'standard',
  })  : assert(
          ['text', 'number', 'currency', 'date'].contains(dataFormat),
          'Must use supported data format: text, number, currency or date',
        ),
        assert(
          ['standard', 'dropdown', 'switch'].contains(type),
          'Must be a supported cell type: standard, dropdown or switch',
        ),
        super(key: key);

  /// [Cell.legend] is a named constructor for building the cell in position
  /// (0,0).
  Cell.legend({
    Key key,
    this.value,
    this.width = 50,
    this.height = 50,
    this.visible = true,
    this.textStyle,
    this.textAlign = TextAlign.center,
    this.cellAlignment = Alignment.centerLeft,
    this.decoration = const BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Colors.grey,
        ),
        right: BorderSide(
          color: Colors.grey,
        ),
        bottom: BorderSide(
          color: Colors.grey,
        ),
        left: BorderSide(
          color: Colors.grey,
        ),
      ),
    ),
    this.onTap = defaultOnTap,
    this.isEditable = false,
    this.enabled = true,
    this.onEditingComplete = defaultOnEditingComplete,
    this.contentWidget,
    this.padding,
    this.contentPadding = const EdgeInsets.only(
      left: 4.0,
      right: 4.0,
      top: 2.0,
      bottom: 2.0,
    ),
    this.isDense = false,
    this.dataFormat = 'text',
    this.validator,
    this.minLines,
    this.maxLines,
    this.keyboardType = TextInputType.text,
    this.inputDecoration = const InputDecoration(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(0),
    ),
    this.onChanged = defaultOnChanged,
    this.supressDidUpdateWidget = false,
    this.dropdownList,
    this.type = 'standard',
  })  : assert(
          ['text', 'number', 'currency', 'date'].contains(dataFormat),
          'Must use supported data format: text, number, currency or date',
        ),
        assert(
          ['standard', 'dropdown', 'switch'].contains(type),
          'Must be a supported cell type: standard, dropdown or switch',
        ),
        super(key: key);

  /// [Cell.rowHeader] is a named constructor for building all row header cells
  /// (cells in column 1) with the exeption of the legend cell.
  Cell.rowHeader({
    Key key,
    this.value,
    this.width = 50,
    this.height = 50,
    this.visible = true,
    this.textStyle,
    this.textAlign = TextAlign.center,
    this.cellAlignment = Alignment.centerLeft,
    this.decoration = const BoxDecoration(
      border: Border(
        right: BorderSide(
          color: Colors.grey,
        ),
        bottom: BorderSide(
          color: Colors.grey,
        ),
        left: BorderSide(
          color: Colors.grey,
        ),
      ),
    ),
    this.onTap = defaultOnTap,
    this.isEditable = false,
    this.enabled = true,
    this.onEditingComplete = defaultOnEditingComplete,
    this.contentWidget,
    this.padding,
    this.contentPadding = const EdgeInsets.only(
      left: 4.0,
      right: 4.0,
      top: 2.0,
      bottom: 2.0,
    ),
    this.isDense = false,
    this.dataFormat = 'text',
    this.validator,
    this.minLines,
    this.maxLines,
    this.keyboardType = TextInputType.text,
    this.inputDecoration = const InputDecoration(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(0),
    ),
    this.onChanged = defaultOnChanged,
    this.supressDidUpdateWidget = false,
    this.dropdownList,
    this.type = 'standard',
  })  : assert(
          ['text', 'number', 'currency', 'date'].contains(dataFormat),
          'Must use supported data format: text, number, currency or date',
        ),
        assert(
          ['standard', 'dropdown', 'switch'].contains(type),
          'Must be a supported cell type: standard, dropdown or switch',
        ),
        super(key: key);

  /// [Cell.columnHeader] is a named constructor for building all column header
  /// cells (cells in row 1) with the exeption of the legend cell.
  Cell.columnHeader({
    Key key,
    this.value,
    this.width = 70,
    this.height = 50,
    this.visible = true,
    this.textStyle,
    this.textAlign = TextAlign.center,
    this.cellAlignment = Alignment.centerLeft,
    this.decoration = const BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Colors.grey,
        ),
        right: BorderSide(
          color: Colors.grey,
        ),
        bottom: BorderSide(
          color: Colors.grey,
        ),
      ),
    ),
    this.onTap = defaultOnTap,
    this.isEditable = false,
    this.enabled = true,
    this.onEditingComplete = defaultOnEditingComplete,
    this.contentWidget,
    this.padding,
    this.contentPadding = const EdgeInsets.only(
      left: 4.0,
      right: 4.0,
      top: 2.0,
      bottom: 2.0,
    ),
    this.isDense = false,
    this.dataFormat = 'text',
    this.validator,
    this.minLines,
    this.maxLines,
    this.keyboardType = TextInputType.text,
    this.inputDecoration = const InputDecoration(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(0),
    ),
    this.onChanged = defaultOnChanged,
    this.supressDidUpdateWidget = false,
    this.dropdownList,
    this.type = 'standard',
  })  : assert(
          ['text', 'number', 'currency', 'date'].contains(dataFormat),
          'Must use supported data format: text, number, currency or date',
        ),
        assert(
          ['standard', 'dropdown', 'switch'].contains(type),
          'Must be a supported cell type: standard, dropdown or switch',
        ),
        super(key: key);

  /// [Cell.formField] is a named constructor for building a cell presented as a
  /// [FormField]. This is used in preference to the default Flutter [FormField]
  /// widget in forms to add the additional inbuilt functionality of a [Cell].
  /// e.g. onchange animations, detecting when focus is lost etc.
  Cell.formField({
    Key key,
    this.value,
    this.width,
    this.height,
    this.visible = true,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.cellAlignment = Alignment.centerLeft,
    this.decoration = const BoxDecoration(),
    this.onTap = defaultOnTap,
    this.isEditable = true,
    this.enabled = true,
    this.onEditingComplete = defaultOnEditingComplete,
    this.contentWidget,
    this.padding = const EdgeInsets.only(
      left: 4.0,
      right: 4.0,
      top: 2.0,
      bottom: 2.0,
    ),
    this.contentPadding,
    this.isDense = true,
    this.dataFormat = 'text',
    this.validator,
    this.minLines,
    this.maxLines,
    this.keyboardType = TextInputType.text,
    this.inputDecoration,
    this.onChanged = defaultOnChanged,
    this.supressDidUpdateWidget = false,
    this.dropdownList,
    this.type = 'standard',
  })  : assert(
          ['text', 'number', 'currency', 'date'].contains(dataFormat),
          'Must use supported data format: text, number, currency or date',
        ),
        assert(
          ['standard', 'dropdown', 'switch'].contains(type),
          'Must be a supported cell type: standard, dropdown or switch',
        ),
        super(key: key);

  @override
  _CellState createState() => _CellState();
}

/// [SingleTickerProviderStateMixin] mixin class is required to "mix in" the
/// additional functionality required to animate a widget.
class _CellState extends State<Cell> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();

  /// required to enforce data formats for dates and currencies.
  final DataFormatter _dataFormatter = DataFormatter();

  /// key required to perform validation on cell when the value changes
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  /// prevents user spamming changes on a single cell while request is still
  /// processing with the server
  bool _requestPending = false;

  /// Animation objects to change cell colours when [onEditingComplete]
  /// functions have sucessfully run with no errors
  AnimationController _animationController;
  Animation _colorTween;
  Animation _successTween;
  Animation _failureTween;
  Animation _serverChangeTween;

  /// Ensures onEditingComplete is called whenever the cell focus is lost.
  /// Allows sending updates of cells to database when the user clicks out of
  /// cell.
  FocusNode _focusNode = FocusNode();

  /// Ensure correct build context is made available to all state functions
  BuildContext _context;

  @override
  void initState() {
    // Ensure the correct datatype is displayed. (e.g currency or date)
    _textController.text = _setValueFormat(widget.value);

    /// Configure animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 1000,
      ),
    );

    /// Configure animation interpolation
    _setColorTweens();

    /// Configure focus node assigned to [Cell] to listen for events when it no
    /// longer has focus.
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // if cell looses focus process the change
        _processChange();
      }
    });

    super.initState();
  }

  @override
  void didUpdateWidget(Cell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // reset animations everytime the cell selection changes
    _setColorTweens();
    // check if the cell value has changed. If so, update the widget
    if (!widget.supressDidUpdateWidget &&
        _hasValueChanged() &&
        !_requestPending &&
        !_focusNode.hasFocus) {
      // parse new value
      String newValue = _setValueFormat(widget.value);

      /// Appears not to be necessary in flutter version 2.0
      /// In some cases when setState is called during the didUpdate widget
      /// process a widget tree rebuild is already in progress. This function
      /// supresses this error.
      /// https://stackoverflow.com/questions/47592301/setstate-or-markneedsbuild-called-during-build
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      /// set state inherentially called by didUpdateWidget
      // setState(() {
      /// Can't set a null value to the text controller. Trying to set a null
      /// causes the text property to maintain its original value.
      _textController.text = newValue == null ? '' : newValue;

      /// Change detected from external source (e.g. server or another user)
      _colorTween = _serverChangeTween;
      _animate();
      // });
      // });
    }
  }

  /// call dispose method to cleanup all cell state variables to eliminate any
  /// memory leaks.
  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    _focusNode.dispose();
    _requestPending = null;
    _colorTween = null;
    _successTween = null;
    _failureTween = null;
    _context = null;
    super.dispose();
  }

  /// Configure animation TWEENS. A Tween is a linear interpolation between two
  /// values. A ttween is a key process in all animation. It is effectively the
  /// process of generating the frames between two images to create an animation.
  void _setColorTweens() {
    _successTween = ColorTween(
      begin: Colors.green,
      end: widget.decoration.color,
    ).animate(_animationController);
    _failureTween = ColorTween(
      begin: Colors.red,
      end: widget.decoration.color,
    ).animate(_animationController);
    _serverChangeTween = ColorTween(
      begin: Colors.orange,
      end: widget.decoration.color,
    ).animate(_animationController);
  }

  bool _hasValueChanged() {
    String currentValue =
        widget.value == '' ? null : _setValueFormat(widget.value);
    String newValue = _textController.text == '' ? null : _textController.text;
    if (currentValue != newValue) {
      return true;
    }
    return false;
  }

  /// [_processRequest] is a generic ui function for handling server requests.
  /// Preventing users from performing additional requests while one is
  /// processing.
  void _processRequest({
    Future<void> requestFuture,
    VoidCallback onSuccess,
    VoidCallback onFailure,
  }) {
    // check if request has already been issued
    if (!_requestPending) {
      // prevent user sending additional request while one is already underway
      setState(() {
        _requestPending = true;
      });
      // perform request
      requestFuture.then((_) {
        // request successful
        _requestPending = false;
        if (onSuccess != null) {
          onSuccess();
        }
      }).catchError((e) {
        // request complete. allow user to send new request.
        _requestPending = false;
        if (onFailure != null) {
          onFailure();
        }
      });
    }
    // pending result of request. Do nothing.
  }

  /// [_clearFocus] is a generic function that clears focus by creating a dummy
  /// focus node and applying focus to it.
  void _clearFocus() {
    FocusScope.of(context).unfocus();
  }

  /// [_setValueFormat] is used to parse the cell value provided to a specific
  /// format on initalising of the cell state or when the cell chansing in the
  /// database through the [didUpdateWidget] override.
  String _setValueFormat(String value) {
    if (widget.dataFormat == 'currency') {
      return _dataFormatter.toCurrency(value);
    } else if (widget.dataFormat == 'date') {
      return _dataFormatter.toDate(value);
    }
    return value;
  }

  /// [_removeValueFormat] removes any applied formatting before the current
  /// value of the cell is passed to the [onEditingComplete] function
  String _removeValueFormat(String value) {
    if (widget.dataFormat == 'currency') {
      return _dataFormatter.toNumber(value);
    }
    return value;
  }

  /// [_animate] ensures the animation is always reset before attempting to run
  /// again.
  void _animate() {
    _animationController.reset();
    _animationController.forward();
  }

  /// [_processChange] processes the user defined [widget.onEditingComplete]
  /// function and reports the success or failure of the function to the user
  /// via defined animations.
  ///
  /// Will also prevent the user spamming multiple async editing complete
  /// events and only fire when the current cell value differs from that in the
  /// database.
  void _processChange() {
    /// only fire completion function if the form field has passed validation
    /// this prevents unverified data from being sent to the database
    if (widget.onEditingComplete is Function &&
        _hasValueChanged() &&
        _key.currentState.validate()) {
      // clean up formatted data
      String returnValue = _removeValueFormat(_textController.text);
      _processRequest(
        requestFuture: Future<void>(() async {
          await widget.onEditingComplete(returnValue);
        }),
        // No on success function provided. As when the user onboarding value is
        // updated the user_onboarding_widget is discarded and the state no longer
        // exists
        onSuccess: () {
          setState(() {
            _colorTween = _successTween;
            _animate();
          });
        },
        onFailure: () {
          // set state to re-enable buttons
          setState(() {
            _colorTween = _failureTween;
            _animate();
          });
        },
      );
    }
  }

  Future<void> _selectDate() async {
    DateTime initialDate;
    if (_textController.text != null) {
      initialDate = DateTime.tryParse(_textController.text);
    }
    if (initialDate == null) {
      initialDate = DateTime.now();
    }

    final DateTime pickedDate = await showDatePicker(
      context: _context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(
        Duration(days: 20 * 365),
      ),
    );

    _textController.text = _dataFormatter.toDate(pickedDate?.toString()) ?? '';
    _processChange();
  }

  void _onTap() {
    if (widget.dataFormat == 'date') {
      _selectDate();
    }
    widget.onTap();
  }

  List<TextInputFormatter> _getInputFormaters() {
    if (widget.dataFormat == 'currency') {
      return [
        InputFormatter(
          formatterCallback: _dataFormatter.toCurrency,
        ),
      ];
    }
    return null;
  }

  TextInputType _getKeyboardType() {
    if (widget.dataFormat == 'currency' || widget.dataFormat == 'number') {
      /// Numeric keyboard causes the 'backspace' or delete button to delete
      /// two numbers at a time as opposed to one using the standard text
      /// keyboard.
      return TextInputType.number;
    }
    return widget.keyboardType;
  }

  /// [_getReadOnly] is used to disable the keyboard and text editing for date
  /// fields as this functionality is made redundant by the date selector
  /// applied to the onTap event for date cells.
  bool _getReadOnly() {
    if (widget.dataFormat == 'date') {
      return true;
    }
    return false;
  }

  /// [_getDropDownCell] is used to build a standard dropdown cell based on a
  /// dropdownList provided to the constructor of the [Cell] class.
  Widget _getDropDownCell() {
    return FormField<String>(
      key: _key,
      enabled: widget.enabled &&
          widget.isEditable &&
          !_requestPending &&
          !_getReadOnly(),
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: widget.inputDecoration,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              /// Expand dropdown button to size of parent widget
              isExpanded: true,

              /// conditional application of isDense. False required for correct
              /// operation on onclick events in tables. True required for
              /// correct display of dropdowns in formfields.
              isDense: widget.isDense,
              hint: Text(
                widget.inputDecoration.hintText ?? '',
                overflow: TextOverflow.ellipsis,
              ),
              value: _textController.text != '' ? _textController.text : null,
              style: widget.textStyle,
              onTap: () {
                _clearFocus();
                _onTap();
              },
              onChanged: (String val) {
                // set the controller value
                _textController.text = val;

                /// store changed value in local dropdown state
                state.setState(() {});
                widget.onChanged(val);
                _processChange();
              },
              items: widget.dropdownList.map((String value) {
                /// an instance of dropmenu item is returned for each item in
                /// the dropdown menu but ALSO the displayed selected item.
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    padding: widget.contentPadding,
                    child: Text(
                      value,
                      // Dropdownmenu items must all be aligned left as per the
                      // issue currently logged on the git flutter repo.
                      // https://github.com/flutter/flutter/issues/3759
                      // textAlign: widget.textAlign,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  /// [_getTextCell] returns a standard input cell based on the provided
  /// constructor options.
  TextFormField _getTextCell() {
    return TextFormField(
      key: _key,
      focusNode: _focusNode,
      onTap: _onTap,
      textAlign: widget.textAlign,
      style: widget.textStyle,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      autocorrect: false,
      controller: _textController,
      decoration: widget.contentPadding != null
          ? widget.inputDecoration
              .copyWith(contentPadding: widget.contentPadding)
          : widget.inputDecoration,
      inputFormatters: _getInputFormaters(),
      keyboardType: _getKeyboardType(),
      enabled: widget.enabled,
      readOnly: !widget.isEditable || _requestPending || _getReadOnly(),
      onChanged: (String val) {
        // validate current field
        _key.currentState.validate();
        widget.onChanged(val);
      },

      /// focus node has a listener for the on focus lost event.
      /// therefore when the focus is lost on the text field by
      /// either completion of editing or selecting a new field
      /// the _processChange function is always called.
      onEditingComplete: _clearFocus,
      validator: widget.validator,
    );
  }

  /// [_getSwitchCell] returns a toggleable switch
  Widget _getSwitchCell() {
    return FormField<String>(
      key: _key,
      enabled: widget.enabled &&
          widget.isEditable &&
          !_requestPending &&
          !_getReadOnly(),
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: widget.contentPadding != null
              ? widget.inputDecoration
                  .copyWith(contentPadding: widget.contentPadding)
              : widget.inputDecoration,
          child: Row(
            children: [
              Switch(
                value: _textController.text == 'true' ? true : false,
                onChanged: (bool val) {
                  _clearFocus();
                  _onTap();
                  // set the controller value
                  _textController.text = val.toString();
                  widget.onChanged(val.toString());
                  _processChange();
                },
              ),

              /// Allow switch to collapse to its natural size
              Expanded(child: Container())
            ],
          ),
        );
      },
    );
  }

  /// [_getCellType] conditionally returns a specific type of cell based on the
  /// [widget.type] property passed in the constructor.
  Widget _getCellType() {
    if (widget.contentWidget != null) {
      return widget.contentWidget;
    } else if (widget.type == 'dropdown') {
      return _getDropDownCell();
    } else if (widget.type == 'switch') {
      return _getSwitchCell();
    } else {
      return _getTextCell();
    }
  }

  /// [_getCell] is the main ui template for generating a cell.
  ///
  /// It is conditionally wrapped with an [AnimationBuilder] widget to produce
  /// the animation effects for success and failure of [widget.onEditingComplete]
  /// function calls.
  Widget _getCell({@required BoxDecoration decoration}) {
    return Visibility(
      visible: widget.visible,

      /// https://stackoverflow.com/questions/54717748/why-flutter-container-does-not-respects-its-width-and-height-constraints-when-it
      /// for the container widget inherently in the cell to respect the height
      /// and width constraints passed, it must be wrapped in an alignment widget
      /// so that it has a height, width, x and y position and can be painted correctly.
      child: Align(
        alignment: widget.cellAlignment,
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          decoration: decoration ?? null,
          child: _getCellType(),
        ),
      ),
    );
  }

  bool _isAnimationComplete() {
    if (_colorTween != null && _colorTween.isCompleted) {
      return true;
    }
    return false;
  }

  /// [build] method is always returns the results of the [_getCell] method, but
  /// will conditionally wrap it with a [AnimatedBuilder] to apply animations
  /// for successful and failing results of [onEditingComplete] function
  /// executions. i.e. if on editing complete successfully writes to the
  /// database the cell will turn green, if it fails, the cell will turn red.
  @override
  Widget build(BuildContext context) {
    _context = context;
    if (_isAnimationComplete()) {
      // reset color tween to prevent cell being wrapped in AnimatedBuilder when
      // no longer needed.
      _colorTween = null;
    }
    return _colorTween != null
        ? AnimatedBuilder(
            animation: _colorTween,
            builder: (_, child) {
              return _getCell(
                decoration: widget.decoration.copyWith(
                  color: _colorTween.isCompleted
                      ? widget.decoration.color
                      : _colorTween.value,
                ),
              );
            })
        : _getCell(
            decoration: widget.decoration,
          );
  }
}
