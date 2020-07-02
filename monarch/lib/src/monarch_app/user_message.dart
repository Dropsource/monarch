const userMessageMarker = '###user-message###';

void printUserMessage(String message, {String marker = userMessageMarker}) {
  print('$marker$message');
}
