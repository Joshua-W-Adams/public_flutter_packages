import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:step_process/step_process.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StepProcessExample(),
    );
  }
}

class StepProcessExample extends StatefulWidget {
  @override
  _StepProcessExampleState createState() => _StepProcessExampleState();
}

class _StepProcessExampleState extends State<StepProcessExample> {
  // define keys for child widgets so their state functions can be accessed
  GlobalKey<StepProcessState> _stepperKey = GlobalKey<StepProcessState>();
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  StepModel _getStepTemplate({
    String title,
    String subtitle,
    Widget content,
    Function validator,
    bool persistState = true,
  }) {
    return StepModel(
      persistState: persistState,
      content: Column(
        children: [
          PageTitle(
            title: title,
            subtitle: subtitle,
            icon: Icon(Icons.ac_unit),
          ),
          Expanded(
            child: content,
          ),
        ],
      ),
      validator: validator,
    );
  }

  StepModel _getUserProfileStep() {
    return _getStepTemplate(
      title: 'User Profile',
      subtitle: 'Please complete all user profile information provided below',
      content: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // Add TextFormFields and ElevatedButton here.
          ],
        ),
      ),
      validator: () async {
        if (!_formKey.currentState.validate()) {
          return 'Please correct all user form errors';
        }
        // else some operation on successful form completion
        return null;
      },
    );
  }

  Widget _getWebDisplay(Widget child) {
    if (kIsWeb) {
      return Center(
        child: AspectRatio(
          aspectRatio: 9.0 / 16.0,
          child: child,
        ),
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final List<StepModel> steps = [
      _getUserProfileStep(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding'),
        actions: [
          FlatButton(
            child: Text(
              'Skip',
              style: TextStyle(
                fontSize: 20.0,
                color: theme.primaryTextTheme.bodyText1.color,
              ),
            ),
            onPressed: () {
              _stepperKey.currentState.skipStep();
              if (_stepperKey.currentState.onLastStep()) {
                // some on last step operation
              }
            },
          ),
        ],
      ),
      body: _getWebDisplay(
        StepProcess(
          key: _stepperKey,
          onCompleted: () {
            return null;
          },
          steps: steps,
          footerIndicatorType: 'dots',
        ),
      ),
    );
  }
}
