import 'package:ecommerce_app/src/exceptions/app_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stackTrace) {
    debugPrint('$error, $stackTrace');
  }

  void logAppException(AppException exception) {
    debugPrint('$exception');

  }
}

final errorLoggerProvider = Provider<ErrorLogger>((ref) {
  return ErrorLogger();
});