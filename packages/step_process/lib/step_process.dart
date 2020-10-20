library step_process;

import 'package:flutter/material.dart';

part 'page_title.dart';
part 'persist_state_widget.dart';

/// [StepProcess] is a widget for guiding a user through a list of steps.
/// Intented to be used for user onboarding, signing up to subscription plans or
/// any other step based process.
class StepProcess extends StatefulWidget {
  final List<StepModel> steps;

  final VoidCallback onCompleted;

  /// supports 'dots' or text
  final String footerIndicatorType;

  /// Back button text. Default is 'BACK'
  final String backText;

  /// Next button text. Default is 'NEXT'
  final String nextText;

  /// Prefix text to step numbers. Default is 'STEP'
  final String stepPrefixText;

  /// Text inserted in between step numbers. Default is 'OF'
  final String stepBetweenText;

  /// Final step button text. Overrides nextText. Default is 'FINISH'
  final String finalText;

  final EdgeInsets footerPadding;

  StepProcess({
    Key key,
    @required this.steps,
    @required this.onCompleted,
    this.footerIndicatorType = 'text',
    this.backText = 'PREV',
    this.nextText = 'NEXT',
    this.stepPrefixText = 'STEP',
    this.stepBetweenText = 'OF',
    this.finalText = 'FINISH',
    this.footerPadding = const EdgeInsets.all(8.0),
  })  : assert(['text', 'dots'].contains(footerIndicatorType)),
        super(key: key);

  @override
  _StepProcessState createState() => _StepProcessState();
}

class _StepProcessState extends State<StepProcess> {
  PageController _controller = PageController();
  int _currentStep = 0;

  @override
  void dispose() {
    // clean up state variables
    _controller.dispose();
    _controller = null;
    super.dispose();
  }

  void switchToPage(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  bool _isFirst(int index) {
    return index == 0;
  }

  bool _isLast(int index) {
    return widget.steps.length - 1 == index;
  }

  void onStepNext() {
    // call validator method for moving to next step
    String validation = widget.steps[_currentStep].validator();
    if (validation == null) {
      // on validation passed
      if (!_isLast(_currentStep)) {
        setState(() {
          _currentStep++;
        });
        FocusScope.of(context).unfocus();
        switchToPage(_currentStep);
      } else {
        widget.onCompleted();
      }
    } else {
      // Validation failed - do Nothing
    }
  }

  void onStepBack() {
    if (!_isFirst(_currentStep)) {
      setState(() {
        _currentStep--;
      });
      switchToPage(_currentStep);
    }
  }

  Widget _getDotIndicator(ThemeData theme) {
    List<Widget> list = [];
    for (int i = 0; i < widget.steps.length; i++) {
      list.add(
        i == _currentStep ? _indicator(true, theme) : _indicator(false, theme),
      );
    }
    return Row(
      children: list,
    );
  }

  Widget _indicator(bool isActive, ThemeData theme) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 12.0,
      decoration: BoxDecoration(
        color: isActive ? theme.accentColor : theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  String getNextLabel() {
    String nextLabel;
    if (_isLast(_currentStep)) {
      nextLabel = widget.finalText;
    } else {
      nextLabel = widget.nextText;
    }
    return nextLabel;
  }

  String getPrevLabel() {
    String backLabel;
    if (_isFirst(_currentStep)) {
      backLabel = '';
    } else {
      backLabel = widget.backText;
    }
    return backLabel;
  }

  Widget _getTextIndicator() {
    return Container(
      child: Text(
        '${widget.stepPrefixText} ${_currentStep + 1} ${widget.stepBetweenText} ${widget.steps.length}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _getPreviousButton() {
    if (_isFirst(_currentStep)) {
      return Container(
        // standard raised button width
        width: 88,
      );
    }
    return RaisedButton(
      onPressed: onStepBack,
      child: Text(
        getPrevLabel(),
      ),
    );
  }

  Widget _getNextButton() {
    return RaisedButton(
      onPressed: onStepNext,
      child: Text(
        getNextLabel(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final content = Expanded(
      child: PageView(
        controller: _controller,
        // disable user swiping to prevent proceeding to the next step before
        // current step validation is completed.
        physics: NeverScrollableScrollPhysics(),
        children: widget.steps.map((step) {
          if (step.persistState == true) {
            return PersistStateWidget(
              child: step.content,
            );
          } else {
            return step.content;
          }
        }).toList(),
      ),
    );

    final indicator = widget.footerIndicatorType == 'text'
        ? _getTextIndicator()
        : _getDotIndicator(theme);

    final footer = Container(
      padding: widget.footerPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _getPreviousButton(),
          indicator,
          _getNextButton(),
        ],
      ),
    );

    return Column(
      children: [
        content,
        footer,
      ],
    );
  }
}

/// [StepModel] is the generic class for an individual step used in the
/// [StepProcess] widget.
class StepModel {
  // content to be loaded into page
  final Widget content;
  // validation required before allowing moving to the next step. Return null if
  // validation passed.
  final String Function() validator;
  // whether the state of the step will be peristed on moving between steps.
  // default is true.
  final bool persistState;

  StepModel({
    @required this.content,
    @required this.validator,
    this.persistState = true,
  });
}
