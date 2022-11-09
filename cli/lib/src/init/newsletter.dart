import 'package:monarch_utils/log.dart';

import '../analytics/analytics.dart';
import '../utils/standard_input.dart';
import '../utils/standard_output.dart';
import '../config/application_support_directory.dart';

const _emailCapturedFlag = '1';

class Newsletter with Log {
  final Analytics analytics;

  Newsletter(this.analytics);

  Future<void> askToJoin({required bool checkIfEmailAlreadyCaptured}) async {
    var isEmailCaptured =
        checkIfEmailAlreadyCaptured && await _isEmailCaptured();
    if (!isEmailCaptured) {
      var email = _captureEmail();
      if (email != null && email.isNotEmpty) {
        stdout_default.writeln('Thanks!');
        await analytics.newsletter_joined(email);
        await _saveEmailCaptured();
      } else {
        analytics.newsletter_skipped();
      }
    }
    _printSocialLinks();
  }

  Future<bool> _isEmailCaptured() async {
    if (await ApplicationSupportDirectory.emailCapturedFile.exists()) {
      var contents =
          await ApplicationSupportDirectory.emailCapturedFile.readAsString();
      return contents == _emailCapturedFlag;
    } else {
      return false;
    }
  }

  Future<void> _saveEmailCaptured() async {
    await ApplicationSupportDirectory.emailCapturedFile
        .writeAsString(_emailCapturedFlag);
  }

  String? _captureEmail() {
    stdout_default.write('''

## Join our newsletter
Sign up to receive low frequency emails on the latest Monarch updates, 
features and news!

''');
    stdout_default.write('Enter email (optional): ');
    return stdin_default.readLineSync(shouldLogLine: true);
  }

  void _printSocialLinks() {
    stdout_default.write('''

## Stay in touch
- GitHub: https://github.com/Dropsource/monarch
- Twitter: https://twitter.com/monarch_app
- Newsletter: https://monarchapp.io/docs/community

''');
  }
}
