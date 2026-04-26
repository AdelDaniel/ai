# Screen Builder

## Example 1

- Screen StatelessWidget
- The arrangement of the UI ScreenContext
  - Screen Widget
    - Private Constants
    - Private Variables
    - Overrides
    - Build Method
    - Bloc
    - State Handlers
    - Helpers
    - Navigation

```dart
// features/[feature_name]/screens/screen_name.dart
import 'package:flutter/material.dart';

class ScreenName extends StatelessWidget {
  const ScreenName({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeatureBloc(),
      child: ScreenNameContent(),
    );
  }
}


class ScreenNameContent extends StatefulWidget {
  const ScreenNameContent({super.key});

  @override
  State<ScreenNameContent> createState() => _ScreenNameContentState();
}

class _ScreenNameContentState extends State<ScreenNameContent> with LoaderOverlayMixin {

  /// Private Constants

  /// Private Variables

  /// Overrides
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeatureNameBloc, FeatureNameState>(
      listener: (context, state) {
        if (state.status == IAPStatus.loading) {
          showLoader();
        } else {
          hideLoader();
        }
        if (state.failure.isSome) {
          context.showFailureToast(state.failure.toNullable());
        } else if () {
          _handleFirstState();
        } else if () {
          _handleSecondState();
        }
      },
      builder: (context, state) {
        return OnboardingBackgroundWrapper(
          child: Scaffold(
            appBar: PaywallAppBar(
              onPressedClose: _onPressedClose,
              onPressedRestore: _onPressRestore,
            ),
            body: Container(),
            ),
        );
      }
    );
  }

  ///////////////////////////////////////////////////////////
  ////////////? Bloc
  ///////////////////////////////////////////////////////////

  IAPBloc get _iAPBloc => context.read<IAPBloc>();

  void _getProducts() {
    _iAPBloc.add(const IAPLoadProductsRequested());
  }

  void _handlePurchase() {
    _iAPBloc.add(IAPPurchaseRequested(_selectedProductNotifier.value!));
  }

  void _onPressRestore() {
    _iAPBloc.add(const IAPRestoreRequested());
  }

  ///////////////////////////////////////////////////////////
  ////////////? State Handlers
  ///////////////////////////////////////////////////////////

  void _handleFirstState() {
    if (!mounted) return;
  }

  void _handleSecondState() {
    if (!mounted) return;
  }

  ///////////////////////////////////////////////////////////
  ////////////? Helpers
  ///////////////////////////////////////////////////////////

  void _onPressedClose() {
    _navigateToHome();
  }

  void _onSelectProduct(IAPProductModel productModel) {
    _selectedProductNotifier.value = productModel;
  }

  ///////////////////////////////////////////////////////////
  ////////////? Navigation
  ///////////////////////////////////////////////////////////

  void _navigateToHome() {
    if (!mounted) return;
    context.goToHomeScreen();
  }
}

```
