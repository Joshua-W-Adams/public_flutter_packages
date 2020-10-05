part of general_widgets;

class Avatar extends StatelessWidget {
  final String photoUrl;
  final double radius;
  final Color borderColor;
  final double borderWidth;
  final VoidCallback onPressed;

  const Avatar({
    @required this.photoUrl,
    this.radius = 50.0,
    this.borderColor,
    this.borderWidth = 1,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _borderDecoration(context),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: photoUrl == null
                  ? null
                  : DecorationImage(
                      image: NetworkImage(photoUrl),
                      fit: BoxFit.cover,
                    ),
            ),
            height: radius,
            width: radius,
            child: photoUrl == null ? ShowError(error: 'No image') : null,
          ),
        ),
      ),
    );
  }

  Decoration _borderDecoration(BuildContext context) {
    return BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border.all(
        color: borderColor ?? Theme.of(context).accentColor,
        width: borderWidth,
      ),
    );
  }
}
