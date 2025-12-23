import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'log_entry.dart';

final logServiceProvider =
    NotifierProvider<LogService, List<LogEntry>>(LogService.new);

class LogService extends Notifier<List<LogEntry>> {
  @override
  List<LogEntry> build() => const [];

  void add(LogEntry entry) {
    state = [
      entry,
      ...state,
    ].take(200).toList();
  }

  void clear() {
    state = const [];
  }
}


