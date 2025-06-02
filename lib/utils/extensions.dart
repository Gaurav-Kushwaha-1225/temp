import 'package:intl/intl.dart';

extension DateTimeExtensions on String {
  String toFormattedDateTime() {
    try {
      final dateTime = DateTime.parse(this);
      return DateFormat('MMM d, y h:mm a').format(dateTime);
    } catch (e) {
      return this;
    }
  }

  String toRelativeTime() {
    try {
      final dateTime = DateTime.parse(this);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 7) {
        return DateFormat('MMM d, y').format(dateTime);
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return this;
    }
  }
}
