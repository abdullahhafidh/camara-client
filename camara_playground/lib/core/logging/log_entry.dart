class LogEntry {
  LogEntry({
    required this.timestamp,
    required this.source,
    required this.level,
    required this.message,
    this.metadata,
    this.stepIndex,
    this.stepName,
    this.iterationId,
  });

  final DateTime timestamp;
  final String source;
  final String level;
  final String message;
  final Map<String, Object?>? metadata;
  final int? stepIndex;
  final String? stepName;
  final int? iterationId;
}


