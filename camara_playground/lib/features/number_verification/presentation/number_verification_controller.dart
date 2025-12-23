import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/log_entry.dart';
import '../../../core/logging/log_service.dart';
import '../../../core/oauth/oauth_manager.dart';
import '../data/number_verification_repository_impl.dart';
import '../domain/usecases/get_device_phone_number_usecase.dart';
import '../domain/usecases/verify_number_usecase.dart';
import 'number_verification_state.dart';

final verifyNumberUseCaseProvider = Provider<VerifyNumberUseCase>((ref) {
  final repo = ref.watch(numberVerificationRepositoryProvider);
  return VerifyNumberUseCase(repo);
});

final getDevicePhoneNumberUseCaseProvider =
    Provider<GetDevicePhoneNumberUseCase>((ref) {
  final repo = ref.watch(numberVerificationRepositoryProvider);
  return GetDevicePhoneNumberUseCase(repo);
});

final numberVerificationControllerProvider =
    NotifierProvider<NumberVerificationController, NumberVerificationState>(
        NumberVerificationController.new);

class NumberVerificationController extends Notifier<NumberVerificationState> {
  late OAuthManager _oauthManager;
  late VerifyNumberUseCase _verifyNumberUseCase;
  late GetDevicePhoneNumberUseCase _getDevicePhoneNumberUseCase;
  
  // Track iteration/run number for grouping logs
  int _currentIteration = 0;

  @override
  NumberVerificationState build() {
    final oauthManager = ref.watch(oauthManagerProvider);
    final verifyUseCase = ref.watch(verifyNumberUseCaseProvider);
    final getDevicePhoneNumberUseCase =
        ref.watch(getDevicePhoneNumberUseCaseProvider);
    _oauthManager = oauthManager;
    _verifyNumberUseCase = verifyUseCase;
    _getDevicePhoneNumberUseCase = getDevicePhoneNumberUseCase;
    return const NumberVerificationState();
  }

  /// Helper method to safely access log service
  LogService get _logService => ref.read(logServiceProvider.notifier);

  void updateAuthorizationCode(String value) {
    // If we're in error state and user starts entering a new code, reset to idle
    // to allow retry. Also reset from authorizing state if user is entering a code.
    final newStatus = (state.status == NumberVerificationStatus.error ||
            (state.status == NumberVerificationStatus.authorizing &&
                value.isNotEmpty))
        ? NumberVerificationStatus.idle
        : state.status;

    state = state.copyWith(
      authorizationCode: value,
      status: newStatus,
      errorMessage: value.isNotEmpty ? null : state.errorMessage,
    );
  }

  /// Resets the verification state, allowing a fresh retry.
  void reset() {
    _logService.add(
      LogEntry(
        timestamp: DateTime.now(),
        source: 'NumberVerificationController',
        level: 'INFO',
        message: 'Resetting verification flow',
        stepIndex: 0,
        stepName: 'Start Verification',
        iterationId: _currentIteration,
      ),
    );
    
    // Reset iteration counter for a fresh start
    _currentIteration = 0;
    
    // Only reset OAuth if it's been initialized
    try {
      _oauthManager.resetAuthorizationFlow();
    } catch (e) {
      // If OAuth manager is not initialized, continue without resetting
    }
    
    // Explicitly reset all fields to ensure clean state
    state = NumberVerificationState(
      status: NumberVerificationStatus.idle,
      authorizationCode: '',
      errorMessage: null,
      browserLaunched: false,
      devicePhoneNumber: null,
      result: null,
    );
  }

  Future<void> verify() async {
    final isManualFlow = _oauthManager.requiresManualAuthorizationCodeFlow;
    
    // Increment iteration counter for each new verification attempt
    _currentIteration++;
    
    try {
      // Step 0: Start Verification
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'NumberVerificationController',
          level: 'INFO',
          message: 'Starting verification flow',
          metadata: {
            'flowType': isManualFlow ? 'manual' : 'automatic',
          },
          stepIndex: 0,
          stepName: 'Start Verification',
          iterationId: _currentIteration,
        ),
      );

      // If the current environment uses a web/backend redirect (http/https),
      // we follow the manual two-step browser + code entry flow.
      if (isManualFlow) {
        // First step: if we don't yet have an authorization code, launch the
        // operator consent page in the external browser. After launching,
        // immediately return to idle state with browserLaunched flag so flow
        // progresses to paste code step.
        if (state.authorizationCode.isEmpty) {
          // Step 1: Operator Consent
          _logService.add(
            LogEntry(
              timestamp: DateTime.now(),
              source: 'NumberVerificationController',
              level: 'INFO',
              message: 'Launching operator consent page in browser',
              stepIndex: 1,
              stepName: 'Operator Consent',
              iterationId: _currentIteration,
            ),
          );
          await _oauthManager.launchAuthorizationInBrowser();
          
          _logService.add(
            LogEntry(
              timestamp: DateTime.now(),
              source: 'NumberVerificationController',
              level: 'INFO',
              message: 'Browser launched successfully, waiting for user to copy authorization code',
            stepIndex: 2,
            stepName: 'Copy Authorization Code',
            iterationId: _currentIteration,
          ),
        );
          
          // Return to idle state immediately - the browser handles consent,
          // flow continues to paste code step
          state = state.copyWith(
            status: NumberVerificationStatus.idle,
            errorMessage: null,
            browserLaunched: true,
          );
          return;
        }

        // Step 3: Paste Code & Continue - we have an authorization code
        _logService.add(
          LogEntry(
            timestamp: DateTime.now(),
            source: 'NumberVerificationController',
            level: 'INFO',
            message: 'Processing authorization code',
            metadata: {
              'codeLength': state.authorizationCode.length,
            },
            stepIndex: 3,
            stepName: 'Paste Code & Continue',
            iterationId: _currentIteration,
          ),
        );
        
        state = state.copyWith(
          status: NumberVerificationStatus.verifying,
          errorMessage: null,
        );
        await _oauthManager.completeAuthorizationWithCode(
          state.authorizationCode,
        );
        
        _logService.add(
          LogEntry(
            timestamp: DateTime.now(),
            source: 'NumberVerificationController',
            level: 'INFO',
            message: 'Authorization code exchanged successfully',
            stepIndex: 3,
            stepName: 'Paste Code & Continue',
            iterationId: _currentIteration,
          ),
        );
      } else {
        // Mobile-app callback flow: the operator redirects back into the app
        // (custom scheme / app link) and flutter_web_auth_2 delivers the
        // final redirect URL, so no manual code entry is needed.
        // Step 1: Operator Consent
        _logService.add(
          LogEntry(
            timestamp: DateTime.now(),
            source: 'NumberVerificationController',
            level: 'INFO',
            message: 'Starting automatic authorization flow',
            stepIndex: 1,
            stepName: 'Operator Consent',
            iterationId: _currentIteration,
          ),
        );
        
        state = state.copyWith(
          status: NumberVerificationStatus.authorizing,
          errorMessage: null,
          authorizationCode: '',
        );
        await _oauthManager.startAuthorizationFlowAutomatic();
        
        _logService.add(
          LogEntry(
            timestamp: DateTime.now(),
            source: 'NumberVerificationController',
            level: 'INFO',
            message: 'Authorization completed, returned to app',
            stepIndex: 2,
            stepName: 'Automatic Return',
            iterationId: _currentIteration,
          ),
        );
      }

      // Step 4 (manual) / Step 3 (auto): Get Automatic Phone Number
      final stepIndexGetAuto = isManualFlow ? 4 : 3;
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'NumberVerificationController',
          level: 'INFO',
          message: 'Attempting to retrieve phone number from SIM',
          stepIndex: stepIndexGetAuto,
          stepName: 'Get Automatic Phone Number',
          iterationId: _currentIteration,
        ),
      );
      
      final deviceNumber = await _getDevicePhoneNumberUseCase();
      
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'NumberVerificationController',
          level: 'INFO',
          message: 'Phone number retrieved',
          metadata: {
            'phoneNumber': deviceNumber.phoneNumber,
            'source': deviceNumber.phoneNumber.contains('+') ? 'SIM' : 'id_token',
          },
          stepIndex: stepIndexGetAuto,
          stepName: 'Get Automatic Phone Number',
          iterationId: _currentIteration,
        ),
      );
      
      state = state.copyWith(
        devicePhoneNumber: deviceNumber.phoneNumber,
      );
      
      // Step 5 (manual) / Step 4 (auto): Get Device Number (if SIM failed, fallback to id_token)
      final stepIndexGetDevice = isManualFlow ? 5 : 4;
      if (!deviceNumber.phoneNumber.contains('+')) {
        _logService.add(
          LogEntry(
            timestamp: DateTime.now(),
            source: 'NumberVerificationController',
            level: 'INFO',
            message: 'Retrieved phone number from id_token',
            stepIndex: stepIndexGetDevice,
            stepName: 'Get Device Number',
            iterationId: _currentIteration,
          ),
        );
      }
      
      // Step 6 (manual) / Step 5 (auto): Verify Number
      final stepIndexVerify = isManualFlow ? 6 : 5;
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'NumberVerificationController',
          level: 'INFO',
          message: 'Calling verify-msisdn API',
          metadata: {
            'msisdn': deviceNumber.phoneNumber,
          },
          stepIndex: stepIndexVerify,
          stepName: 'Verify Number',
          iterationId: _currentIteration,
        ),
      );
      
      final result = await _verifyNumberUseCase(deviceNumber.phoneNumber);
      
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'NumberVerificationController',
          level: 'INFO',
          message: 'Verification completed',
          metadata: {
            'match': result.match,
            'devicePhoneNumber': result.devicePhoneNumber,
            'correlationId': result.correlationId,
          },
          stepIndex: stepIndexVerify,
          stepName: 'Verify Number',
          iterationId: _currentIteration,
        ),
      );
      
      // Step 7 (manual) / Step 6 (auto): Show Result
      final stepIndexResult = isManualFlow ? 7 : 6;
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'NumberVerificationController',
          level: 'INFO',
          message: 'Verification successful',
          metadata: {
            'match': result.match,
          },
          stepIndex: stepIndexResult,
          stepName: 'Show Result',
          iterationId: _currentIteration,
        ),
      );
      
      state = state.copyWith(
        status: NumberVerificationStatus.success,
        result: result,
      );
    } on AuthorizationCancelledException {
      // User cancelled the authorization flow - reset state so they can retry
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'NumberVerificationController',
          level: 'WARN',
          message: 'Authorization cancelled by user',
          stepIndex: isManualFlow ? 1 : 1,
          stepName: 'Operator Consent',
          iterationId: _currentIteration,
        ),
      );
      
      _oauthManager.resetAuthorizationFlow();
      state = state.copyWith(
        status: NumberVerificationStatus.idle,
        errorMessage: 'Authorization cancelled. You can try again.',
        authorizationCode: '',
        browserLaunched: false,
      );
    } catch (e) {
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'NumberVerificationController',
          level: 'ERROR',
          message: 'Verification failed: ${e.toString()}',
          metadata: {
            'error': e.toString(),
            'errorType': e.runtimeType.toString(),
          },
          iterationId: _currentIteration,
        ),
      );
      
      state = state.copyWith(
        status: NumberVerificationStatus.error,
        errorMessage: 'Verification failed. Please try again.',
      );
    }
  }
}


