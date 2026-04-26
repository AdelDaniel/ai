---
name: analytics
description: Design or implement Flutter analytics using a provider-agnostic AnalyticsService, typed events, feature-level event mapping, Firebase Analytics, Mixpanel, consent handling, and QA validation.
---

# Analytics

Use this skill when adding, reviewing, or refactoring analytics in a Flutter app. The default architecture is provider-agnostic app code with one `AnalyticsService` that forwards typed events to one or more analytics clients, such as Firebase Analytics and Mixpanel.

## Core Architecture

Use this flow:

```text
Feature UI / BLoC / Cubit / ViewModel
  -> typed AnalyticsEvent
  -> AnalyticsService
  -> FirebaseAnalyticsClient, MixpanelAnalyticsClient, or other providers
```

Do not call provider SDKs directly throughout screens, BLoCs, Cubits, or repositories. Keep Firebase, Mixpanel, PostHog, Segment, and similar SDK details behind client implementations.

## Folder Structure

```text
lib/
  core/
    analytics/
      analytics_client.dart
      analytics_consent.dart
      analytics_event.dart
      analytics_events.dart
      analytics_params.dart
      analytics_service.dart
      analytics_user.dart
      providers/
        firebase_analytics_client.dart
        mixpanel_analytics_client.dart
  features/
    <feature_name>/
      analytics/
        <feature_name>_analytics_events.dart
```

Keep cross-feature analytics contracts in `core/analytics/`. Keep feature-specific events near the feature.

## Event Contract

Define typed events instead of passing raw strings and maps around the app.

```dart
abstract interface class AnalyticsEvent {
  String get name;
  Map<String, Object> get parameters;
}
```

Example:

```dart
final class CourseOpenedEvent implements AnalyticsEvent {
  const CourseOpenedEvent({
    required this.courseId,
    required this.courseName,
    required this.instructorId,
  });

  final String courseId;
  final String courseName;
  final String instructorId;

  @override
  String get name => AnalyticsEvents.courseOpened;

  @override
  Map<String, Object> get parameters => {
        AnalyticsParams.courseId: courseId,
        AnalyticsParams.courseName: courseName,
        AnalyticsParams.instructorId: instructorId,
      };
}
```

Centralize names and parameter keys to prevent typo drift:

```dart
abstract final class AnalyticsEvents {
  static const courseOpened = 'course_opened';
  static const courseStarted = 'course_started';
  static const lessonCompleted = 'lesson_completed';
  static const paymentCompleted = 'payment_completed';
}

abstract final class AnalyticsParams {
  static const courseId = 'course_id';
  static const courseName = 'course_name';
  static const instructorId = 'instructor_id';
  static const lessonId = 'lesson_id';
  static const revenue = 'revenue';
  static const currency = 'currency';
}
```

## Client Interface

```dart
abstract interface class AnalyticsClient {
  Future<void> track(AnalyticsEvent event);

  Future<void> identify({
    required String userId,
    Map<String, Object?> properties = const {},
  });

  Future<void> setConsent(AnalyticsConsent consent);

  Future<void> reset();
}
```

```dart
final class AnalyticsConsent {
  const AnalyticsConsent({
    required this.analyticsStorageAllowed,
    required this.adsStorageAllowed,
  });

  final bool analyticsStorageAllowed;
  final bool adsStorageAllowed;
}
```

## AnalyticsService

The service owns fan-out, enablement, consent, and error isolation.

```dart
import 'dart:async';

final class AnalyticsService {
  AnalyticsService({
    required List<AnalyticsClient> clients,
    bool enabled = true,
  })  : _clients = clients,
        _enabled = enabled;

  final List<AnalyticsClient> _clients;
  bool _enabled;

  Future<void> track(AnalyticsEvent event) async {
    if (!_enabled) return;

    for (final client in _clients) {
      unawaited(
        client.track(event).catchError((error, stackTrace) {
          // Send to the app logger or crash reporter if available.
        }),
      );
    }
  }

  Future<void> identify({
    required String userId,
    Map<String, Object?> properties = const {},
  }) async {
    if (!_enabled) return;

    for (final client in _clients) {
      await client.identify(userId: userId, properties: properties);
    }
  }

  Future<void> setConsent(AnalyticsConsent consent) async {
    for (final client in _clients) {
      await client.setConsent(consent);
    }
  }

  Future<void> reset() async {
    for (final client in _clients) {
      await client.reset();
    }
  }

  void enable() => _enabled = true;
  void disable() => _enabled = false;
}
```

## Firebase Client

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

final class FirebaseAnalyticsClient implements AnalyticsClient {
  FirebaseAnalyticsClient(this._firebaseAnalytics);

  final FirebaseAnalytics _firebaseAnalytics;

  @override
  Future<void> track(AnalyticsEvent event) {
    return _firebaseAnalytics.logEvent(
      name: event.name,
      parameters: event.parameters,
    );
  }

  @override
  Future<void> identify({
    required String userId,
    Map<String, Object?> properties = const {},
  }) async {
    await _firebaseAnalytics.setUserId(id: userId);

    for (final entry in properties.entries) {
      final value = entry.value;
      if (value == null) continue;

      await _firebaseAnalytics.setUserProperty(
        name: entry.key,
        value: value.toString(),
      );
    }
  }

  @override
  Future<void> setConsent(AnalyticsConsent consent) {
    return _firebaseAnalytics.setConsent(
      analyticsStorageConsentGranted: consent.analyticsStorageAllowed,
      adStorageConsentGranted: consent.adsStorageAllowed,
    );
  }

  @override
  Future<void> reset() async {
    await _firebaseAnalytics.setUserId(id: null);
  }
}
```

Firebase is a good fit for standard app analytics, GA4, attribution, BigQuery export, recommended events, screen views, and Firebase ecosystem integration.

## Mixpanel Client

```dart
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

final class MixpanelAnalyticsClient implements AnalyticsClient {
  MixpanelAnalyticsClient(this._mixpanel);

  final Mixpanel _mixpanel;

  @override
  Future<void> track(AnalyticsEvent event) async {
    _mixpanel.track(event.name, properties: event.parameters);
  }

  @override
  Future<void> identify({
    required String userId,
    Map<String, Object?> properties = const {},
  }) async {
    _mixpanel.identify(userId);

    if (properties.isNotEmpty) {
      _mixpanel.getPeople().set(properties);
    }
  }

  @override
  Future<void> setConsent(AnalyticsConsent consent) async {
    if (consent.analyticsStorageAllowed) {
      _mixpanel.optInTracking();
    } else {
      _mixpanel.optOutTracking();
    }
  }

  @override
  Future<void> reset() async {
    _mixpanel.reset();
  }
}
```

Mixpanel is a good fit for product analytics, funnels, retention, cohorts, user journeys, feature usage, experiments, and deeper behavior analysis.

## Where To Track

Prefer tracking from:

- BLoCs or Cubits after successful state transitions.
- ViewModels or controllers after actions complete.
- Use cases only when the event is domain-level and not presentation-specific.
- Route observers for screen views.
- Widgets only for pure UI interactions such as tab changes, button taps, carousel swipes, or control toggles.

Example:

```dart
final class CourseDetailsCubit extends Cubit<CourseDetailsState> {
  CourseDetailsCubit({
    required AnalyticsService analytics,
    required CourseRepository repository,
  })  : _analytics = analytics,
        _repository = repository,
        super(const CourseDetailsState.initial());

  final AnalyticsService _analytics;
  final CourseRepository _repository;

  Future<void> loadCourse(String courseId) async {
    emit(const CourseDetailsState.loading());

    final course = await _repository.getCourse(courseId);
    emit(CourseDetailsState.loaded(course));

    await _analytics.track(
      CourseOpenedEvent(
        courseId: course.id,
        courseName: course.name,
        instructorId: course.instructorId,
      ),
    );
  }
}
```

## Naming Rules

Use `object_action` event names:

- `course_opened`
- `course_started`
- `lesson_completed`
- `quiz_submitted`
- `payment_started`
- `payment_completed`
- `search_performed`
- `filter_applied`
- `bookmark_added`
- `bookmark_removed`

Avoid vague or inconsistent names such as `open`, `click_button`, `user_click`, `CourseOpened`, or `courseOpen`.

## Privacy And Consent

- Do not log email, phone, tokens, passwords, raw addresses, or sensitive personal data.
- Use an internal stable user ID or privacy-safe derived ID. Do not use personally identifiable values as analytics IDs.
- Respect consent before tracking.
- Call `identify` only after login or account creation.
- Call `reset` on logout, especially when multiple users may use the same device.
- Keep provider-specific consent behavior inside analytics clients.

## QA Checklist

- Event name matches the tracking plan.
- Parameters match the tracking plan.
- No sensitive data is logged.
- Event fires once, not duplicated.
- Event fires after successful action when success is required.
- Error, cancel, and retry states are tracked separately when meaningful.
- Firebase and Mixpanel both receive the expected event.
- User identity is set only after valid login or account creation.
- Logout calls `reset`.
- Consent is respected.
- Debug and release builds are checked on Android and iOS.

## Provider Notes

- Firebase event names are case-sensitive. Different casing creates distinct events.
- Firebase app data streams have collection limits; verify current event, parameter, and user-property limits in official docs before creating large taxonomies.
- Firebase user IDs apply to future events and must not contain information that can identify a person outside your own system.
- Mixpanel Flutter supports initialization, event tracking, `identify`, People profile updates through `getPeople()`, opt-in, opt-out, super properties, feature flags, and reset behavior.

Official references:

- Firebase Analytics events: https://firebase.google.com/docs/analytics/cpp/events
- Firebase user ID guidance: https://firebase.google.com/docs/analytics/userid
- Google Analytics event collection limits: https://support.google.com/analytics/answer/9267744
- Firebase Android consent API: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics
- Mixpanel Flutter SDK: https://github.com/mixpanel/mixpanel-flutter
- Mixpanel Flutter API: https://mixpanel.github.io/mixpanel-flutter/mixpanel_flutter/Mixpanel-class.html
