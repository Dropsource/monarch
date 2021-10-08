const userLineMarker = '##usr-line##';

/// Prints a user message. It first splits it by new lines. Each line is then
/// prefixed with the [marker] so the CLI can display the message to the user.
void printUserMessage(String message, {String marker = userLineMarker}) {
  var lines = message.trimRight().split('\n');
  for (var line in lines) {
    print('$marker$line');
  }
  print(marker);
}
