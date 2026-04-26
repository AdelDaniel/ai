# Bloc Guide

## Architecture

The app follows the official bloc architecture split:

- Presentation layer: screens, pages, widgets, and route shells.
- Business logic layer: BLoCs/Cubits that convert events into states.
- Data layer: repositories and data providers used by BLoCs.

Keep dependencies flowing in one direction:

```text
Presentation -> Bloc -> Repository -> Data Provider
```

### Data Layer

Data providers expose raw APIs for local storage, network calls, platform
services, or other asynchronous sources. They should be generic and reusable.

Repositories wrap one or more data providers, transform raw data into app data,
and expose APIs or streams to BLoCs. A BLoC should talk to repositories, not
directly to data providers, when the operation belongs to the data/domain layer.

### Business Logic Layer

A BLoC responds to events from presentation and emits states for presentation to
render. BLoCs may depend on repositories injected through their constructors.

Do not inject one BLoC into another BLoC. Sibling dependencies in the business
logic layer create tight coupling and make behavior harder to reason about and
test.

If one BLoC must react to another BLoC:

1. Prefer presentation coordination with `BlocListener` or `MultiBlocListener`
   when the reaction is UI-flow or lifecycle orchestration.
2. Prefer a shared repository stream when multiple BLoCs need the same domain
   data or must stay synchronized independently.

Example: keep sibling BLoCs decoupled through presentation:

```dart
MultiBlocListener(
  listeners: [
    BlocListener<FirstBloc, FirstState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        context.read<SecondBloc>().add(const SecondStarted());
      },
    ),
  ],
  child: const FeatureScreen(),
)
```

### Presentation Layer

Presentation renders UI from BLoC state, handles user input, dispatches initial
events, and coordinates application lifecycle events. It is the right place to
connect sibling BLoCs with listeners when no shared repository stream is needed.

Source: <https://bloclibrary.dev/architecture/>

---

## Structure

### Events (part of bloc) && States (part of bloc)

```text
lib/
  features/
    <feature_name>/
      presentation/
        bloc/        # Feature-specific BLoC
            [feature]_bloc.dart       # Main BLoC file
            [feature]_event.dart      # Events (part of bloc)
            [feature]_state.dart      # States (part of bloc)
        screens/     # Full screen widgets
        pages/       # Not needed all the time the pages of the screens
        widgets/     # Feature-specific components
```

---

## Naming

### Event Conventions

Events should be named in the past tense because events are things that have already occurred from the bloc’s perspective.

Anatomy
BlocSubject + Noun (optional) + Verb (event)

Initial load events should follow the convention: BlocSubject + Started

Note

The base event class should be name: BlocSubject + Event.

Examples
✅ Good

```dart
counter_event.dart
sealed class CounterEvent {}
final class CounterStarted extends CounterEvent {
  const CounterStarted();
}
final class CounterIncrementPressed extends CounterEvent {
  const CounterIncrementPressed();
}
final class CounterDecrementPressed extends CounterEvent {
  const CounterDecrementPressed();
}
final class CounterIncrementRetried extends CounterEvent {
  const CounterIncrementRetried();
}
```

❌ Bad

```dart
counter_event.dart
sealed class CounterEvent {}
final class Initial extends CounterEvent {}
final class CounterInitialized extends CounterEvent {}
final class Increment extends CounterEvent {}
final class DoIncrement extends CounterEvent {}
final class IncrementCounter extends CounterEvent {}
```

### State Conventions

States should be nouns because a state is just a snapshot at a particular point in time. There are two common ways to represent state: using subclasses or using a single class.

Anatomy
Subclasses
BlocSubject + Verb (action) + State

When representing the state as multiple subclasses State should be one of the following:

Initial | Success | Failure | InProgress

Note

Initial states should follow the convention: BlocSubject + Initial.

Single Class
BlocSubject + State

When representing the state as a single base class an enum named BlocSubject + Status should be used to represent the status of the state:

initial | success | failure | loading.

Note

The base state class should always be named: BlocSubject + State.

Examples
✅ Good

- Subclasses

```dart
counter_state.dart
sealed class CounterState {}
final class CounterInitialState extends CounterState {
  const CounterInitialState();
}
final class CounterLoadInProgressState extends CounterState {
  const CounterLoadInProgressState();
}
final class CounterLoadSuccessState extends CounterState {
  const CounterLoadSuccessState();
}
final class CounterLoadFailureState extends CounterState {
  const CounterLoadFailureState();
}
```

- Single Class

```dart
counter_state.dart
enum CounterStatus { initial, loading, success, failure }
final class CounterState {
  const CounterState({this.status = CounterStatus.initial});
  final CounterStatus status;
}
```

❌ Bad

```dart
counter_state.dart
sealed class CounterState {}
final class Initial extends CounterState {}
final class Loading extends CounterState {}
final class Success extends CounterState {}
final class Succeeded extends CounterState {}
final class Loaded extends CounterState {}
final class Failure extends CounterState {}
final class Failed extends CounterState {}
```

---

## Bloc File

```dart

// core/services/iap/presentation/bloc/iap_bloc.dart

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hush/core/services/iap/base/customer_info_model.dart';
import 'package:hush/core/services/iap/base/iap_product_model.dart';
import 'package:hush/core/services/iap/domain/iap_repository.dart';
import 'package:hush/core/errors/failures.dart';
import 'package:hush/core/utils/option.dart';

part 'iap_event.dart';
part 'iap_state.dart';

class IAPBloc extends Bloc<IAPEvent, IAPState> {
  final IAPRepository _iapRepository;

  IAPBloc({required IAPRepository iapRepository})
    : _iapRepository = iapRepository,
      super(const IAPState.initial()) {
    on<IAPGetCustomerInfo>(_onIAPGetCustomerInfo);
    on<IAPLoadProductsRequested>(_onIAPLoadProductsRequested);
    on<IAPPurchaseRequested>(_onIAPPurchaseRequested);
    on<IAPRestoreRequested>(_onIAPRestoreRequested);
  }

  late final StreamSubscription<IAPCustomerInfo> _purchasedSub;

  Future<void> _onIAPGetCustomerInfo(
    IAPGetCustomerInfo event,
    Emitter<IAPState> emit,
  ) async {
    emit(state.loading());
    final result = await _iapRepository.getCustomerInfo();
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (customerInfo) => emit(
        state.copyWith(
          status: IAPStatus.initial,
          purchasedProductIds: customerInfo.purchases
              .map((p) => p.productId)
              .toSet(),
          isSubscribed: true,
        ),
      ),
    );

    emit(state.copyWith(purchasedProductIds: state.purchasedProductIds));
  }

  Future<void> _onIAPLoadProductsRequested(
    IAPLoadProductsRequested event,
    Emitter<IAPState> emit,
  ) async {
    emit(state.loading());
    final result = await _iapRepository.loadProducts();
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (products) => emit(
        state.copyWith(products: products, status: IAPStatus.loadedProducts),
      ),
    );
  }

  Future<void> _onIAPPurchaseRequested(
    IAPPurchaseRequested event,
    Emitter<IAPState> emit,
  ) async {
    emit(state.loading());
    final result = await _iapRepository.purchase(event.product);

    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (_) => emit(state.copyWith(status: IAPStatus.purchaseSuccess)),
    );
  }

  Future<void> _onIAPRestoreRequested(
    IAPRestoreRequested event,
    Emitter<IAPState> emit,
  ) async {
    emit(state.loading());
    final result = await _iapRepository.restorePurchases();

    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (_) => emit(state.copyWith(status: IAPStatus.restoreSuccess)),
    );
  }
}

```

---

## State File

### If you are using One State Class

- Add Factory constructor for the init

```dart
/// In the bloc file:
super(const IAPBlocState.initial())

/// in the state file
/// Be like this or Factory Constructor
const IAPBlocState.initial() : products = const [];
```

- Examples

```dart
// core/services/iap/presentation/bloc/iap_state.dart
part of 'iap_bloc.dart';

enum IAPStatus {
  initial,
  loading,
  failure,
  loadedProducts,
  purchaseSuccess,
  restoreSuccess,
}

class IAPState extends Equatable {
  const IAPState({
    required this.status,
    required this.products,
    required this.purchasedProductIds,
    required this.isSubscribed,
    required this.failure,
  });

  final IAPStatus status;
  final List<IAPProductModel> products;
  final Set<String> purchasedProductIds;
  final bool isSubscribed;
  final Option<Failure> failure;

  const IAPState.initial()
    : status = IAPStatus.initial,
      products = const [],
      purchasedProductIds = const <String>{},
      isSubscribed = false,
      failure = const None();

  IAPState loading() {
    return copyWith(status: IAPStatus.loading, failure: const None());
  }

  IAPState withFailure(Failure failure) {
    return copyWith(status: IAPStatus.failure, failure: Some(failure));
  }

  IAPState copyWith({
    IAPStatus? status,
    List<IAPProductModel>? products,
    Set<String>? purchasedProductIds,
    bool? isSubscribed,
    Option<Failure>? failure,
  }) {
    return IAPState(
      status: status ?? this.status,
      products: products ?? this.products,
      purchasedProductIds: purchasedProductIds ?? this.purchasedProductIds,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    purchasedProductIds,
    isSubscribed,
    failure,
  ];

  @override
  String toString() {
    return 'IAPBlocState(status: $status, products: $products, purchasedProductIds: $purchasedProductIds, isSubscribed: $isSubscribed, failure: $failure)';
  }
}

```

---

### Multi States

```dart
sealed class CounterState {}
class CounterInitialState extends CounterState {
  const CounterInitialState();
}
class CounterLoadInProgressState extends CounterState {
  const CounterLoadInProgressState();
}
class CounterLoadSuccessState extends CounterState {
  const CounterLoadSuccessState();
}
class CounterLoadFailureState extends CounterState {
  const CounterLoadFailureState();
}
```

## documentation Note:

### Modeling State

description:
An overview of several ways to model states when using package:bloc.

There are many different approaches when it comes to structuring application
state. Each has its own advantages and drawbacks. In this section, we'll take a
look at several approaches, their pros and cons, and when to use each one.

The following approaches are simply recommendations and are completely optional.
Feel free to use whatever approach you prefer. You may find some of the
examples/documentation do not follow the approaches mainly for
simplicity/conciseness.

:::tip

The following code snippets are focused on the state structure. In practice, you
may also want to:

- Extend `Equatable` from
  [`package:equatable`](https://pub.dev/packages/equatable)
- Annotate the class with `@Data()` from
  [`package:data_class`](https://pub.dev/packages/data_class)
- Annotate the class with **@immutable** from
  [`package:meta`](https://pub.dev/packages/meta)
- Implement a `copyWith` method
- Use the `const` keyword for constructors

:::

### Concrete Class and Status Enum

This approach consists of a **single concrete class** for all states along with
an `enum` representing different statuses. Properties are made nullable and are
handled based on the current status. This approach works best for states which
are not strictly exclusive and/or contain lots of shared properties.

```dart
enum TodoStatus { initial, loading, success, failure }
final class TodoState {
  const TodoState({
    this.status = TodoStatus.initial,
    this.todos = const <Todo>[],
    this.exception = null,
  });
  final TodoStatus status;
  final List<Todos> todos;
  final Exception? exception;
}
```

#### Pros

- **Simple**: Easy to manage a single class and a status enum and all properties
  are readily accessible.
- **Concise**: Generally requires fewer lines of code as compared to other
  approaches.

#### Cons

- **Not Type Safe**: Requires checking the `status` before accessing properties.
  It's possible to `emit` a malformed state which can lead to bugs. Properties
  for specific states are nullable, which can be cumbersome to manage and
  requires either force unwrapping or performing null checks. Some of these cons
  can be mitigated by writing unit tests and writing specialized, named
  constructors.
- **Bloated**: Results in a single state that can become bloated with many
  properties over time.

#### Verdict

This approach works best for simple states or when the requirements call for
states that aren't exclusive (e.g. showing a snackbar when an error occurs while
still showing old data from the last success state). This approach provides
flexibility and conciseness at the cost of type safety.

## Sealed Class and Subclasses

This approach consists of a **sealed class** that holds any shared properties
and multiple subclasses for the separate states. This approach is great for
separate, exclusive states.

```dart
sealed class WeatherState {
  const WeatherState();
}
final class WeatherInitial extends WeatherState {
  const WeatherInitial();
}
final class WeatherLoadInProgress extends WeatherState {
  const WeatherLoadInProgress();
}
final class WeatherLoadSuccess extends WeatherState {
  const WeatherLoadSuccess({required this.weather});
  final Weather weather;
}
final class WeatherLoadFailure extends WeatherState {
  const WeatherLoadFailure({required this.exception});
  final Exception exception;
}
```

#### Pros

- **Type Safe**: The code is compile-safe and it's not possible to accidentally
  access an invalid property. Each subclass holds its own properties, making it
  clear which properties belong to which state.
- **Explicit:** Separates shared properties from state-specific properties.
- **Exhaustive**: Using a `switch` statement for exhaustiveness checks to ensure
  that each state is explicitly handled.
  - If you don't want
    [exhaustive switching](https://dart.dev/language/branches#exhaustiveness-checking)
    or want to be able to add subtypes later without breaking the API, use the
    [final](https://dart.dev/language/class-modifiers#final) modifier.
  - See the
    [sealed class documentation](https://dart.dev/language/class-modifiers#sealed)
    for more details.

#### Cons

- **Verbose**: Requires more code (one base class and a subclass per state).
  Also may require duplicate code for shared properties across subclasses.
- **Complex**: Adding new properties requires updating each subclass and the
  base class, which can be cumbersome and lead to increases in complexity of the
  state. In addition, may require unnecessary/excessive type checking to access
  properties.

#### Verdict

This approach works best for well-defined, exclusive states with unique
properties. This approach provides type safety & exhaustiveness checks and
emphasizes safety over conciseness and simplicity.
