import 'package:camara_playground/app/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: CamaraPlaygroundApp(),
    ),
  );
}
