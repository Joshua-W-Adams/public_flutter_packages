part of step_process;

class PageTitle extends StatelessWidget {
  final String title;
  final TextStyle? titleTextStyle;
  final String subtitle;
  final TextStyle? subtitleTextStyle;
  final Color? backgroundColor;
  final Icon? icon;

  PageTitle({
    required this.title,
    this.titleTextStyle,
    required this.subtitle,
    this.subtitleTextStyle,
    this.backgroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.accentColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: titleTextStyle ??
                      TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: theme.accentTextTheme.bodyText1!.color,
                      ),
                  maxLines: 2,
                ),
              ),
              SizedBox(width: 5.0),
              icon ?? Container(),
            ],
          ),
          SizedBox(height: 5.0),
          Text(
            subtitle,
            style: subtitleTextStyle ??
                TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: theme.accentTextTheme.bodyText1!.color,
                ),
          ),
        ],
      ),
    );
  }
}
