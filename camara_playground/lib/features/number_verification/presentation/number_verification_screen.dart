import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/environment_manager.dart';
import 'number_verification_controller.dart';
import 'number_verification_flow_diagram.dart';
import 'number_verification_result_view.dart';
import 'number_verification_state.dart';

class NumberVerificationScreen extends ConsumerStatefulWidget {
  const NumberVerificationScreen({super.key});

  @override
  ConsumerState<NumberVerificationScreen> createState() =>
      _NumberVerificationScreenState();
}

class _NumberVerificationScreenState
    extends ConsumerState<NumberVerificationScreen> with WidgetsBindingObserver {
  NumberVerificationStatus? _previousStatus;
  String? _previousErrorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // When app comes back to foreground, the restart button will be visible
    // if we're stuck in authorizing state, allowing user to reset manually
  }

  @override
  Widget build(BuildContext context) {
    final envState = ref.watch(environmentManagerProvider);
    final env = envState.current.environment;
    final isManualCodeFlow = Uri.parse(env.redirectUri).scheme == 'http' ||
        Uri.parse(env.redirectUri).scheme == 'https';
    final state = ref.watch(numberVerificationControllerProvider);
    final controller = ref.read(numberVerificationControllerProvider.notifier);

    // Show validation banner only when status or error message changes
    if (_previousStatus != state.status || _previousErrorMessage != state.errorMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showValidationBanner(context, state, controller);
        _previousStatus = state.status;
        _previousErrorMessage = state.errorMessage;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Verification'),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify your mobile number',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                isManualCodeFlow
                    ? 'Follow the steps below to verify your mobile number. You will need to authorize with your operator and paste the authorization code.\n\n'
                        'Redirection Behavior: This flow uses http/https redirect URIs. When you tap "Verify Now", the app opens your browser for operator consent. After authorization, the operator redirects to a callback page where you must manually copy the authorization code and paste it back into the app to continue.'
                    : 'Follow the steps below to verify your mobile number. The app will automatically handle the authorization flow.\n\n'
                        'Redirection Behavior: This flow uses custom scheme/app links (e.g., myapp://callback). When you tap "Verify Now", the app opens the operator consent page. After authorization, the operator automatically redirects back to the app using a deep link, and the flow continues seamlessly without manual code entry.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              NumberVerificationFlowDiagram(
                isManualCodeFlow: isManualCodeFlow,
                currentStep: _getCurrentStep(state, isManualCodeFlow),
                authorizationCode: state.authorizationCode,
                onAuthorizationCodeChanged: controller.updateAuthorizationCode,
                onVerifyPressed: () => controller.verify(),
                isVerifyButtonEnabled: _isButtonEnabled(state, isManualCodeFlow),
                onRestartPressed: () {
                  // Clear banner and reset previous status tracking before resetting
                  ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
                  _previousStatus = null;
                  _previousErrorMessage = null;
                  controller.reset();
                },
                showRestartButton: _shouldShowRestartButton(state),
                isLoading: state.status == NumberVerificationStatus.authorizing ||
                    state.status == NumberVerificationStatus.verifying,
                loadingMessage: _getLoadingMessage(state, isManualCodeFlow),
                browserLaunched: state.browserLaunched,
              ),
              if (state.status == NumberVerificationStatus.success && state.result != null) ...[
                const SizedBox(height: 24),
                NumberVerificationResultView(result: state.result!),
              ],
              // Add bottom padding to avoid Android navigation buttons
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  /// Gets the loading message for the current step.
  static String? _getLoadingMessage(
    NumberVerificationState state,
    bool isManualCodeFlow,
  ) {
    switch (state.status) {
      case NumberVerificationStatus.authorizing:
        return isManualCodeFlow
            ? 'Browser opened. Complete authorization and copy the code.'
            : 'Opening operator consent page...';
      case NumberVerificationStatus.verifying:
        return 'Verifying your number...';
      default:
        return null;
    }
  }

  /// Determines if the restart button should be shown.
  static bool _shouldShowRestartButton(NumberVerificationState state) {
    // Always show restart button from the beginning
    return true;
  }

  /// Determines if the Verify Now button should be enabled.
  static bool _isButtonEnabled(
    NumberVerificationState state,
    bool isManualCodeFlow,
  ) {
    // Always disable during active verification
    if (state.status == NumberVerificationStatus.verifying) {
      return false;
    }

    // For manual code flow: enable if we're idle/error/success, OR if we're
    // authorizing but have a code entered (user can retry with new code)
    if (isManualCodeFlow) {
      if (state.status == NumberVerificationStatus.authorizing) {
        // Enable if user has entered a code (they can retry)
        return state.authorizationCode.isNotEmpty;
      }
      // Enable for idle, error, or success states
      return true;
    }

    // For automatic flow: enable only when not authorizing or verifying
    return state.status != NumberVerificationStatus.authorizing;
  }

  /// Maps the current verification state to a step index in the flow diagram.
  /// For manual flow, automatically jumps to next manual step (skipping browser steps).
  static int? _getCurrentStep(
    NumberVerificationState state,
    bool isManualCodeFlow,
  ) {
    switch (state.status) {
      case NumberVerificationStatus.idle:
        // For manual flow: if browser was launched (step 0 clicked), jump to step 4 (paste code)
        // This is the next manual step within app control, skipping browser steps (1-3)
        if (isManualCodeFlow) {
          return state.browserLaunched ? 3 : 0; // Step 4 (index 3) if browser launched, else step 0
        }
        return 0; // Start Verification
      case NumberVerificationStatus.authorizing:
        // Only for automatic flow
        return 1; // Operator Consent
      case NumberVerificationStatus.verifying:
        // During verification, we're at "Get Automatic Phone Number", "Get Device Number", or "Verify Number"
        // These are automatic steps, so show them normally
        // We show "Get Automatic Phone Number" step during verifying
        return isManualCodeFlow ? 4 : 3;
      case NumberVerificationStatus.success:
        // All steps completed
        return isManualCodeFlow ? 7 : 6;
      case NumberVerificationStatus.error:
        // Don't highlight any step on error
        return null;
    }
  }

  void _showValidationBanner(
    BuildContext context,
    NumberVerificationState state,
    NumberVerificationController controller,
  ) {
    // Remove any existing banners first
    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

    switch (state.status) {
      case NumberVerificationStatus.error:
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
              leading: const Icon(Icons.error_outline, color: Colors.white),
              actions: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    controller.reset();
                  },
                  child: const Text(
                    'Reset & Retry',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  },
                ),
              ],
            ),
          );
        }
        break;
      case NumberVerificationStatus.idle:
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orange,
              leading: const Icon(Icons.warning_amber_rounded, color: Colors.white),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  },
                ),
              ],
            ),
          );
        } else {
          // Hide banner if no error
          ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
        }
        break;
      case NumberVerificationStatus.success:
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: const Text(
              'Verification completed successfully!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            leading: const Icon(Icons.check_circle, color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                },
              ),
            ],
          ),
        );
        break;
      default:
        // Hide banner for other states
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
        break;
    }
  }
}


