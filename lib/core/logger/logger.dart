import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

enum LogLevel { verbose, debug, info, warn, error }

extension on LogLevel {
  String get prefix => name.toUpperCase();
  int get value => index;
}

class Logger {
  static LogLevel get _minLevel => kReleaseMode ? LogLevel.info : LogLevel.verbose;

  final String name;
  Logger(this.name);

  bool _shouldLog(LogLevel level) => level.value >= _minLevel.value;

  void verbose(String msg, {Map<String, dynamic>? context, Object? error, StackTrace? stack}) => _log(LogLevel.verbose, msg, context: context, error: error, stack: stack);
  void debug(String msg, {Map<String, dynamic>? context, Object? error, StackTrace? stack}) => _log(LogLevel.debug, msg, context: context, error: error, stack: stack);
  void info(String msg, {Map<String, dynamic>? context, Object? error, StackTrace? stack}) => _log(LogLevel.info, msg, context: context, error: error, stack: stack);
  void warn(String msg, {Map<String, dynamic>? context, Object? error, StackTrace? stack}) => _log(LogLevel.warn, msg, context: context, error: error, stack: stack);
  void error(String msg, {Map<String, dynamic>? context, Object? error, StackTrace? stack}) => _log(LogLevel.error, msg, context: context, error: error, stack: stack);

  void _log(LogLevel level, String msg, {Map<String, dynamic>? context, Object? error, StackTrace? stack}) {
    if (!_shouldLog(level)) return;

    final ctxStr = context != null && context.isNotEmpty
        ? ' | ${context.entries.map((e) => '${e.key}=${e.value}').join(', ')}'
        : '';

    final now = DateTime.now().toUtc().toIso8601String().split('.')[0];
    final prefix = level.prefix;
    final loggerName = '$now [$prefix] $name';

    print('$loggerName: $msg$ctxStr');

    if (error != null) print('  ERROR: $error');
    if (stack != null) print(stack);

  }
}