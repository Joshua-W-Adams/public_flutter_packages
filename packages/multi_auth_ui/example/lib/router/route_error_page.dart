import 'package:flutter/material.dart';
import 'package:general_widgets/general_widgets.dart';

class RouteErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: 'Error',
        backButton: false,
      ),
      body: Center(
        child: ShowError(error: 'Url does not exist.'),
      ),
    );
  }
}
