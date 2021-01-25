part of general_widgets;

/// [TextHightlighter] will use a provided regular expression to search through
/// a text string then return a [RichText] widget with any regular expression
/// matches highlighted in the [highlightColor] specified.
class TextHighlighter extends StatelessWidget {
  final String text;
  final RegExp query;
  final TextStyle style;
  final int maxLines;
  final TextOverflow overflow;
  final Color baseColor;
  final Color highlightColor;
  final TextSpan prefixSpan;
  final TextSpan suffixSpan;
  final Function(String matchedText) matchOnTap;

  TextHighlighter({
    @required this.text,
    @required this.query,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.baseColor,
    this.highlightColor,
    this.prefixSpan,
    this.suffixSpan,
    this.matchOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return _highlightAllText(text, query);
  }

  TextSpan _getBaseTextSpan(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: baseColor == null ? Colors.grey : baseColor,
      ),
    );
  }

  TextSpan _getHighlightTextSpan(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: highlightColor == null ? Colors.black : highlightColor,
        fontWeight: FontWeight.bold,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          if (matchOnTap != null) {
            matchOnTap(text);
          }
        },
    );
  }

  Widget _highlightAllText(String text, RegExp query) {
    // array to store found text
    List<TextSpan> hightlightedText = [];

    // append a prefix if required - e.g. a username.
    if (prefixSpan != null) {
      hightlightedText.add(prefixSpan);
    }

    // check user inputs for errors
    if (text != null && query != null && text != "" && query.pattern != "") {
      _getHighlightedText(text, query).forEach((element) {
        hightlightedText.add(element);
      });
    } else {
      hightlightedText.add(
        _getBaseTextSpan(
          text,
        ),
      );
    }

    // append suffix if required
    if (suffixSpan != null) {
      hightlightedText.add(suffixSpan);
    }

    return RichText(
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(
        style: style,
        children: hightlightedText,
      ),
    );
  }

  List<TextSpan> _getHighlightedText(String text, RegExp query) {
    int position;
    List<TextSpan> hightlightedText = [];
    List<TextSpan> segment;

    // loop through all characters in string
    for (int i = 0; i < text.length; i++) {
      // find first occurance of regex
      position = text.toLowerCase().indexOf(query, i);
      // check of string was found
      if (position != -1) {
        // get length of matched regualr expression
        int matchLength = query.stringMatch(text.substring(position)).length;
        // create the segment (prefix and matched)
        segment = _getHighlightSegment(text, matchLength, query, i);
        // append segment to hightlight text array
        segment.forEach((element) {
          hightlightedText.add(element);
        });
        // update poistion in str to search from
        i = position + matchLength - 1;
      } else {
        // no more matches get suffix string
        String suffixStr = text.substring(i, text.length);
        hightlightedText.add(
          _getBaseTextSpan(
            suffixStr,
          ),
        );
        // end loop execution
        break;
      }
      // i increments self
    }

    return hightlightedText;
  }

  List<TextSpan> _getHighlightSegment(
    String text,
    int matchLength,
    RegExp query,
    int start,
  ) {
    int location = text.toLowerCase().indexOf(query, start);

    // case 1 -string is not found - return str
    if (location == -1) {
      return [
        _getBaseTextSpan(text),
      ];
      // case 2 - string found - highlight value
    } else {
      String prefixStr = text.substring(start, location);
      String foundStr = text.substring(location, location + matchLength);
      return [
        // prefix
        _getBaseTextSpan(prefixStr),
        // found
        _getHighlightTextSpan(foundStr),
      ];
    }
  }
}
