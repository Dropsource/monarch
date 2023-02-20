import '../analytics/analytics.dart';
import '../utils/standard_output.dart';
import '../version_api/notification.dart';

void showNotifications(List<Notification> notifications, StandardOutput stdout_,
    Analytics analytics) {
  for (var notification in notifications) {
    stdout_.writeln();
    stdout_.writeln('*' * 80);
    stdout_.writeln(notification.message.trim());
    stdout_.writeln('*' * 80);
    analytics.notification_displayed(notification.id);
  }
}
