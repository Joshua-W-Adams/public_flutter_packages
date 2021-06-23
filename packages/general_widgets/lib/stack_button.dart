part of general_widgets;

class StackButton extends CustomRaisedButton {
  StackButton({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    Color? textColor,
    Color? disabledColor,
    double height = 50.0,
    Widget? child,
  }) : super(
          key: key,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                width: 250,
                child: Center(
                  child: Text(
                    text,
                  ),
                ),
              ),
              child ?? Container(),
            ],
          ),
          textColor: textColor,
          disabledColor: disabledColor,
          onPressed: onPressed,
        );
}
