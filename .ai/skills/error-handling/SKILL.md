# Error Handling Guide

This project follows a strict error handling pattern using the **Either** type to represent success or failure, ensuring that exceptions never leak into the UI layer and are consistently logged.

## How to Act

You are a **Software Architect** and **Robustness Specialist** focused on system reliability.

Your job:
👉 **Enforce the separation between Data exceptions and Domain failures.**
👉 **Ensure every repository handles its own exceptions and converts them to the standardized `Failure` model.**
👉 **Guarantee that every error is logged to Crashlytics via `Failure.fromException`.**
👉 **Advocate for functional error handling using `Either` instead of scattered `try-catch` blocks.**

## 1. Core Architecture

The error handling system is built on three pillars:

- **Exceptions** (`lib/core/errors/exceptions.dart`): Low-level errors thrown in the **Data Layer** (API, Database, Firebase).
- **Failures** (`lib/core/errors/failures.dart`): Domain-level objects that wrap exceptions and provide user-friendly information.
- **Either** (`lib/core/utils/either.dart`): A disjoint union type used to return either a `Failure` (Left) or a `Success` value (Right).

## 2. Layer-by-Layer Implementation

### Data Layer (Data Sources)

Data sources should throw specialized `AppException` types when something goes wrong. Do not return `Either` here; use standard Dart `throw`.

```dart
if (response.statusCode != 200) {
  throw ServerException('Failed to fetch data', code: response.statusCode.toString());
}
```

### Repository Layer

Repositories catch exceptions and convert them into `Failure` objects using the centralized factory. They return `Future<Either<Failure, T>>`.

```dart
@override
Future<Either<Failure, User>> getUser() async {
  try {
    final user = await remoteDataSource.getUser();
    return Right(user);
  } catch (e, stackTrace) {
    // Failure.fromException handles Crashlytics logging automatically
    return Left(Failure.fromException(e, stackTrace));
  }
}
```

### BLoC Layer

BLoCs "fold" the `Either` result to determine which state to emit.

```dart
final result = await repository.getUser();
result.fold(
  (failure) => emit(UserError(failure: failure)),
  (user) => emit(UserLoaded(user: user)),
);
```

### UI Layer

The UI renders based on the state. It should use the `Failure` object's message or specialized properties.

```dart
if (state is UserError) {
  return ErrorView(
    message: state.failure.message,
    onRetry: () => context.read<UserBloc>().add(FetchUser()),
  );
}
```

## 3. Centralized Logging (Crashlytics)

**CRITICAL**: Always use `Failure.fromException(exception, stackTrace)` in repositories.
This factory method is the **single point of truth** for:

1. Converting raw exceptions into domain Failures.
2. Automatically recording the error in **Firebase Crashlytics**.
3. Normalizing error messages for the UI.

## 4. Best Practices

- ✅ **Use `Either` for all public Repository/Service APIs**: Make failures explicit in the method signature.
- ✅ **Favor `fold` or `when`**: Use these methods on `Either` to ensure both success and failure cases are handled.
- ✅ **Keep UI simple**: Do not perform deep type-checking on `Failure` in widgets; the BLoC should provide the necessary info.
- ❌ **Never use `print` or `log` for errors**: `Failure.fromException` already handles Crashlytics. For local debugging, the `_log` method in services should follow the `service-logger-validator` skill.
- ❌ **Don't swallow exceptions**: Always pass the caught exception and its stack trace to `Failure.fromException`.

## 5. Summary of Types

| Type           | Layer     | Purpose                                                                         |
| :------------- | :-------- | :------------------------------------------------------------------------------ |
| `AppException` | Data      | Low-level technical errors (Network, Server, Cache).                            |
| `Failure`      | Domain/UI | User-facing error representation with code and message.                         |
| `Either<L, R>` | All       | Functional way to handle optionality and errors without `try-catch` everywhere. |
