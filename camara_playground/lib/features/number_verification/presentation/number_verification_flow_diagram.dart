import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/log_service.dart';

/// Step location and automation type indicator.
enum FlowStepType {
  inAppAutomatic,
  inAppManual,
  outsideAppAutomatic,
  outsideAppManual,
}

/// Visual flow diagram showing the number verification process steps.
class NumberVerificationFlowDiagram extends ConsumerStatefulWidget {
  const NumberVerificationFlowDiagram({
    super.key,
    required this.isManualCodeFlow,
    this.currentStep,
    this.authorizationCode,
    this.onAuthorizationCodeChanged,
    this.onVerifyPressed,
    this.isVerifyButtonEnabled = false,
    this.onRestartPressed,
    this.showRestartButton = false,
    this.isLoading = false,
    this.loadingMessage,
    this.browserLaunched = false,
  });

  /// Whether this is the manual code entry flow (browser + paste code)
  /// vs automatic app callback flow.
  final bool isManualCodeFlow;

  /// Current step index (0-based) to highlight, or null if not in progress.
  final int? currentStep;

  /// Current authorization code value (for manual flow).
  final String? authorizationCode;

  /// Callback when authorization code changes.
  final ValueChanged<String>? onAuthorizationCodeChanged;

  /// Callback when Verify button is pressed.
  final VoidCallback? onVerifyPressed;

  /// Whether the Verify button should be enabled.
  final bool isVerifyButtonEnabled;

  /// Callback when Restart button is pressed.
  final VoidCallback? onRestartPressed;

  /// Whether to show the restart button.
  final bool showRestartButton;

  /// Whether a step is currently loading.
  final bool isLoading;

  /// Loading message to display in the active step.
  final String? loadingMessage;

  /// Whether the browser has been launched (for manual flow).
  /// When true, steps 1-3 (browser steps) are marked as completed.
  final bool browserLaunched;

  @override
  ConsumerState<NumberVerificationFlowDiagram> createState() =>
      _NumberVerificationFlowDiagramState();
}

class _NumberVerificationFlowDiagramState
    extends ConsumerState<NumberVerificationFlowDiagram> {
  late TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.authorizationCode ?? '');
  }

  @override
  void didUpdateWidget(NumberVerificationFlowDiagram oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.authorizationCode != oldWidget.authorizationCode) {
      _codeController.text = widget.authorizationCode ?? '';
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.isManualCodeFlow ? _manualFlowSteps : _automaticFlowSteps;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_tree,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Verification Flow',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final currentStepValue = widget.currentStep;
              final isActive = currentStepValue != null && currentStepValue == index;
              // For manual flow: if browser launched and we're at step 4 (index 3) or beyond,
              // mark steps 0-2 as completed since they're done (step 0 clicked, steps 1-2 in browser)
              bool isCompleted = currentStepValue != null && currentStepValue > index;
              if (widget.isManualCodeFlow &&
                  widget.browserLaunched &&
                  currentStepValue != null &&
                  currentStepValue >= 3 &&
                  index < 3) {
                isCompleted = true;
              }

              // Step 1 (index 0) - Show Verify button when idle or at step 0
              // Only show if browser hasn't been launched yet (otherwise we're at step 4)
              if (index == 0 && 
                  !widget.browserLaunched && 
                  (currentStepValue == null || currentStepValue == 0)) {
                return _StepWithButton(
                  stepWidget: _FlowStepContentOnly(
                    title: step.title,
                    description: step.description,
                    icon: step.icon,
                    isActive: isActive,
                    stepType: step.stepType,
                    stepIndex: index,
                    isLoading: widget.isLoading && isActive,
                    loadingMessage: widget.isLoading && isActive ? widget.loadingMessage : null,
                  ),
                  button: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: widget.isVerifyButtonEnabled && !widget.isLoading
                          ? widget.onVerifyPressed
                          : null,
                      icon: widget.isLoading && isActive
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.verified_user, size: 18),
                      label: const Text('Verify Now'),
                    ),
                  ),
                  stepNumber: index + 1,
                  isActive: isActive,
                  isCompleted: isCompleted,
                  isLast: index == steps.length - 1,
                );
              }

              // Step 4 (index 3) in manual flow - Always show input field when idle or active
              // This step appears after clicking verify (browser launches, then user pastes code)
              if (widget.isManualCodeFlow && index == 3) {
                // Show input when: active (step 3), idle (step 0 - after browser launch), or error
                final currentStepValue = widget.currentStep;
                final shouldShowInput = isActive || 
                    currentStepValue == null || 
                    currentStepValue == 0;
                
                return _StepWithButton(
                  stepWidget: _FlowStepContentOnly(
                    title: step.title,
                    description: step.description,
                    icon: step.icon,
                    isActive: isActive,
                    stepType: step.stepType,
                    stepIndex: index,
                    isLoading: widget.isLoading && isActive,
                    loadingMessage: widget.isLoading && isActive ? widget.loadingMessage : null,
                  ),
                  extraContent: shouldShowInput ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Authorization code',
                          hintText: 'Paste code from callback page',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.key),
                          filled: isActive,
                          fillColor: isActive
                              ? colorScheme.primaryContainer.withOpacity(0.3)
                              : null,
                        ),
                        onChanged: widget.onAuthorizationCodeChanged,
                        controller: _codeController,
                        enabled: !widget.isLoading,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: !widget.isLoading &&
                                  widget.isVerifyButtonEnabled && 
                                  (widget.authorizationCode?.isNotEmpty ?? false)
                              ? widget.onVerifyPressed
                              : null,
                          icon: widget.isLoading && isActive
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.arrow_forward, size: 18),
                          label: const Text('Verify Code'),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ) : null,
                  stepNumber: index + 1,
                  isActive: isActive,
                  isCompleted: isCompleted,
                  isLast: index == steps.length - 1,
                );
              }

              return _FlowStepWidget(
                stepNumber: index + 1,
                title: step.title,
                description: step.description,
                icon: step.icon,
                isActive: isActive,
                isCompleted: isCompleted,
                isLast: index == steps.length - 1,
                stepType: step.stepType,
                stepIndex: index,
                isLoading: widget.isLoading && isActive,
                loadingMessage: widget.isLoading && isActive ? widget.loadingMessage : null,
              );
            }),
            // Restart button at the end
            if (widget.showRestartButton && widget.onRestartPressed != null) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: widget.onRestartPressed,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Restart Flow'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              // Add bottom padding to avoid Android navigation buttons
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  static const List<_FlowStep> _manualFlowSteps = [
    _FlowStep(
      title: 'Start Verification',
      description: 'Tap "Verify Now" to begin',
      icon: Icons.play_arrow,
      stepType: FlowStepType.inAppManual,
    ),
    _FlowStep(
      title: 'Operator Consent',
      description: 'Browser opens for operator authorization',
      icon: Icons.lock_open,
      stepType: FlowStepType.outsideAppAutomatic,
    ),
    _FlowStep(
      title: 'Copy Authorization Code',
      description: 'Copy code from callback page',
      icon: Icons.content_copy,
      stepType: FlowStepType.outsideAppManual,
    ),
    _FlowStep(
      title: 'Paste Code & Continue',
      description: 'Paste code in app and tap "Verify Now" again',
      icon: Icons.paste,
      stepType: FlowStepType.inAppManual,
    ),
    _FlowStep(
      title: 'Get Automatic Phone Number',
      description: 'Retrieve phone number from SIM card',
      icon: Icons.sim_card,
      stepType: FlowStepType.inAppAutomatic,
    ),
    _FlowStep(
      title: 'Get Device Number',
      description: 'Retrieve phone number from id_token',
      icon: Icons.phone_android,
      stepType: FlowStepType.inAppAutomatic,
    ),
    _FlowStep(
      title: 'Verify Number',
      description: 'Call CAMARA verify-msisdn API',
      icon: Icons.verified,
      stepType: FlowStepType.inAppAutomatic,
    ),
    _FlowStep(
      title: 'Show Result',
      description: 'Display verification result',
      icon: Icons.check_circle,
      stepType: FlowStepType.inAppAutomatic,
    ),
  ];

  static const List<_FlowStep> _automaticFlowSteps = [
    _FlowStep(
      title: 'Start Verification',
      description: 'Tap "Verify Now" to begin',
      icon: Icons.play_arrow,
      stepType: FlowStepType.inAppManual,
    ),
    _FlowStep(
      title: 'Operator Consent',
      description: 'App opens operator authorization page',
      icon: Icons.lock_open,
      stepType: FlowStepType.outsideAppAutomatic,
    ),
    _FlowStep(
      title: 'Automatic Return',
      description: 'Operator redirects back to app',
      icon: Icons.arrow_back,
      stepType: FlowStepType.outsideAppAutomatic,
    ),
    _FlowStep(
      title: 'Get Automatic Phone Number',
      description: 'Retrieve phone number from SIM card',
      icon: Icons.sim_card,
      stepType: FlowStepType.inAppAutomatic,
    ),
    _FlowStep(
      title: 'Get Device Number',
      description: 'Retrieve phone number from id_token',
      icon: Icons.phone_android,
      stepType: FlowStepType.inAppAutomatic,
    ),
    _FlowStep(
      title: 'Verify Number',
      description: 'Call CAMARA verify-msisdn API',
      icon: Icons.verified,
      stepType: FlowStepType.inAppAutomatic,
    ),
    _FlowStep(
      title: 'Show Result',
      description: 'Display verification result',
      icon: Icons.check_circle,
      stepType: FlowStepType.inAppAutomatic,
    ),
  ];
}

class _FlowStep {
  const _FlowStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.stepType,
  });

  final String title;
  final String description;
  final IconData icon;
  final FlowStepType stepType;
}

class _FlowStepWidget extends ConsumerWidget {
  const _FlowStepWidget({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.icon,
    required this.isActive,
    required this.isCompleted,
    required this.isLast,
    required this.stepType,
    required this.stepIndex,
    this.isLoading = false,
    this.loadingMessage,
  });

  final int stepNumber;
  final String title;
  final String description;
  final IconData icon;
  final bool isActive;
  final bool isCompleted;
  final bool isLast;
  final FlowStepType stepType;
  final int stepIndex;
  final bool isLoading;
  final String? loadingMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color getStepColor() {
      if (isCompleted) return colorScheme.primary;
      if (isActive) return colorScheme.primary;
      return Colors.grey;
    }

    final stepColor = getStepColor();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number circle
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive || isCompleted
                      ? stepColor.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  border: Border.all(
                    color: stepColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(
                          Icons.check,
                          size: 18,
                          color: stepColor,
                        )
                      : Text(
                          '$stepNumber',
                          style: TextStyle(
                            color: stepColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? stepColor : Colors.grey.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Step content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: stepColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: stepColor,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _showStepLogs(context, ref, stepIndex, title),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.article,
                          size: 16,
                          color: stepColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildStepTypeBadge(stepType),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: stepColor.withOpacity(0.7),
                  ),
                ),
                if (isLoading && loadingMessage != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(stepColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          loadingMessage!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: stepColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildStepTypeBadge(FlowStepType stepType) {
    String label;
    IconData icon;
    Color color;

    switch (stepType) {
      case FlowStepType.inAppAutomatic:
        label = 'In App Auto';
        icon = Icons.auto_awesome;
        color = Colors.green;
        break;
      case FlowStepType.inAppManual:
        label = 'In App Manual';
        icon = Icons.touch_app;
        color = Colors.blue;
        break;
      case FlowStepType.outsideAppAutomatic:
        label = 'Outside Auto';
        icon = Icons.open_in_browser;
        color = Colors.purple;
        break;
      case FlowStepType.outsideAppManual:
        label = 'Outside Manual';
        icon = Icons.content_copy;
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showStepLogs(BuildContext context, WidgetRef ref, int stepIndex, String stepName) {
    final allLogs = ref.read(logServiceProvider);
    final stepLogs = allLogs.where((log) => 
      log.stepIndex == stepIndex || log.stepName == stepName
    ).toList();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logs: $stepName'),
        content: SizedBox(
          width: double.maxFinite,
          child: stepLogs.isEmpty
              ? const Text('No logs available for this step.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: stepLogs.length,
                  itemBuilder: (context, index) {
                    final log = stepLogs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getLogColor(log.level).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  log.level,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _getLogColor(log.level),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                log.source,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _formatTime(log.timestamp),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            log.message,
                            style: theme.textTheme.bodyMedium,
                          ),
                          if (log.metadata != null && log.metadata!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            ...log.metadata!.entries.map((e) => Padding(
                              padding: const EdgeInsets.only(left: 8, top: 2),
                              child: Text(
                                '${e.key}: ${e.value}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[700],
                                  fontFamily: 'monospace',
                                ),
                              ),
                            )),
                          ],
                        ],
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getLogColor(String level) {
    switch (level.toUpperCase()) {
      case 'ERROR':
      case 'SEVERE':
        return Colors.red;
      case 'WARN':
      case 'WARNING':
        return Colors.orange;
      case 'INFO':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }
}

/// Step content only (without circle and line) - used when wrapping with buttons/inputs.
class _FlowStepContentOnly extends ConsumerWidget {
  const _FlowStepContentOnly({
    required this.title,
    required this.description,
    required this.icon,
    required this.isActive,
    required this.stepType,
    required this.stepIndex,
    this.isLoading = false,
    this.loadingMessage,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool isActive;
  final FlowStepType stepType;
  final int stepIndex;
  final bool isLoading;
  final String? loadingMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final stepColor = isActive ? colorScheme.primary : Colors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: stepColor,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: stepColor,
                ),
              ),
            ),
            InkWell(
              onTap: () => _showStepLogs(context, ref, stepIndex, title),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.article,
                  size: 16,
                  color: stepColor.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _buildStepTypeBadge(stepType, stepColor),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: stepColor.withOpacity(0.7),
          ),
        ),
        if (isLoading && loadingMessage != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(stepColor),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  loadingMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: stepColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStepTypeBadge(FlowStepType stepType, Color stepColor) {
    String label;
    IconData icon;
    Color color;

    switch (stepType) {
      case FlowStepType.inAppAutomatic:
        label = 'In App Auto';
        icon = Icons.auto_awesome;
        color = Colors.green;
        break;
      case FlowStepType.inAppManual:
        label = 'In App Manual';
        icon = Icons.touch_app;
        color = Colors.blue;
        break;
      case FlowStepType.outsideAppAutomatic:
        label = 'Outside Auto';
        icon = Icons.open_in_browser;
        color = Colors.purple;
        break;
      case FlowStepType.outsideAppManual:
        label = 'Outside Manual';
        icon = Icons.content_copy;
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showStepLogs(BuildContext context, WidgetRef ref, int stepIndex, String stepName) {
    final allLogs = ref.read(logServiceProvider);
    final stepLogs = allLogs.where((log) => 
      log.stepIndex == stepIndex || log.stepName == stepName
    ).toList();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logs: $stepName'),
        content: SizedBox(
          width: double.maxFinite,
          child: stepLogs.isEmpty
              ? const Text('No logs available for this step.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: stepLogs.length,
                  itemBuilder: (context, index) {
                    final log = stepLogs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getLogColor(log.level).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  log.level,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _getLogColor(log.level),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                log.source,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _formatTime(log.timestamp),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(log.message, style: theme.textTheme.bodyMedium),
                          if (log.metadata != null && log.metadata!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            ...log.metadata!.entries.map((e) => Padding(
                              padding: const EdgeInsets.only(left: 8, top: 2),
                              child: Text(
                                '${e.key}: ${e.value}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[700],
                                  fontFamily: 'monospace',
                                ),
                              ),
                            )),
                          ],
                        ],
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getLogColor(String level) {
    switch (level.toUpperCase()) {
      case 'ERROR':
      case 'SEVERE':
        return Colors.red;
      case 'WARN':
      case 'WARNING':
        return Colors.orange;
      case 'INFO':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }
}

/// Helper widget that wraps a step widget with buttons/inputs while keeping the connecting line intact.
class _StepWithButton extends StatelessWidget {
  const _StepWithButton({
    required this.stepWidget,
    this.button,
    this.extraContent,
    required this.isCompleted,
    required this.isLast,
    required this.stepNumber,
    required this.isActive,
  });

  final Widget stepWidget;
  final Widget? button;
  final Widget? extraContent;
  final bool isCompleted;
  final bool isLast;
  final int stepNumber;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final stepColor = isCompleted ? colorScheme.primary : (isActive ? colorScheme.primary : Colors.grey);
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle and extending line
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted || isActive
                      ? stepColor.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  border: Border.all(
                    color: stepColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(Icons.check, size: 18, color: stepColor)
                      : Text(
                          '$stepNumber',
                          style: TextStyle(
                            color: stepColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? stepColor : Colors.grey.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step widget without its own circle/line (we'll modify _FlowStepWidget to support this)
                stepWidget,
                if (button != null) ...[
                  const SizedBox(height: 12),
                  button!,
                  const SizedBox(height: 8),
                ],
                if (extraContent != null) extraContent!,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

