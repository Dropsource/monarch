/// "Hard wraps" the [string] on or after the [lineLength]. It only replaces
/// white spaces with new lines.
///
/// It can be used to convert a long line into multiple lines where each line
/// is roughly the same length.
String hardWrap(String string, {int lineLength = 80}) {
  if (string.length <= lineLength) {
    return string;
  }

  var linebreaks = <int>[];

  var shouldReplace = false;
  var currentLength = 0;

  for (var i = 0; i < string.length; i++) {
    currentLength++;

    if (currentLength >= lineLength) {
      shouldReplace = true;
    }

    if (shouldReplace) {
      if (string[i] == ' ') {
        linebreaks.add(i);
        shouldReplace = false;
        currentLength = 0;
      }
    }
  }

  var buffer = StringBuffer();
  for (var i = 0; i < string.length; i++) {
    if (linebreaks.contains(i)) {
      buffer.write('\n');
    } else {
      buffer.write(string[i]);
    }
  }

  return buffer.toString();
}
