import 'package:flutter/material.dart';

import '../domain/entities.dart';

class NumberVerificationResultView extends StatelessWidget {
  const NumberVerificationResultView({
    super.key,
    required this.result,
  });

  final VerificationResult result;

  @override
  Widget build(BuildContext context) {
    final match = result.match;
    final deviceNumber = result.devicePhoneNumber;
    final correlationId = result.correlationId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (match)
          Text(
            deviceNumber != null
                ? 'Your number is verified. Device number matches $deviceNumber.'
                : 'Your number is verified and matches this device.',
            style: Theme.of(context).textTheme.bodyLarge,
          )
        else
          Text(
            'Number does not match this device. Please check and try again.',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        if (correlationId != null) ...[
          const SizedBox(height: 8),
          Text(
            'Correlation ID: $correlationId',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}


