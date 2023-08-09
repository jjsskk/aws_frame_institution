
import 'analytics_events.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class AnalyticsService {
  static void log(AbstractAnalyticsEvent event) {
    Amplify.Analytics.recordEvent(event: event.value);
  }
}