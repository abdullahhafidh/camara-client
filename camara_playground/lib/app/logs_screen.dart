import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/logging/log_service.dart';

class LogsScreen extends ConsumerWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(logServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_all),
            tooltip: 'Copy all logs',
            onPressed: logs.isEmpty
                ? null
                : () async {
                    final text = logs.map(_formatEntryForShare).join('\n');
                    await Clipboard.setData(ClipboardData(text: text));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All logs copied to clipboard'),
                        ),
                      );
                    }
                  },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => ref.read(logServiceProvider.notifier).clear(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final entry = logs[index];
          return ListTile(
            dense: true,
            title: Text(
              '[${entry.level}] ${entry.source}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${entry.timestamp.toIso8601String()} - ${entry.message}',
                ),
                if (entry.metadata != null && entry.metadata!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatMetadata(entry.metadata!),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              tooltip: 'Copy this log',
              onPressed: () async {
                final text = _formatEntryForShare(entry);
                await Clipboard.setData(ClipboardData(text: text));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Log entry copied to clipboard'),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  static String _formatMetadata(Map<String, Object?> metadata) {
    return metadata.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(' | ');
  }

  static String _formatEntryForShare(entry) {
    final buffer = StringBuffer()
      ..writeln(
          '[${entry.level}] ${entry.source} - ${entry.timestamp.toIso8601String()}')
      ..writeln(entry.message);

    if (entry.metadata != null && entry.metadata!.isNotEmpty) {
      buffer.writeln('Metadata:');
      entry.metadata!.forEach((key, value) {
        buffer.writeln('- $key: $value');
      });
    }

    return buffer.toString().trimRight();
  }
}


