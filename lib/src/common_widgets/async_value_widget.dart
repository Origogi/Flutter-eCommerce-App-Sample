import 'package:ecommerce_app/src/common_widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({required this.value, required this.data, super.key});

  final AsyncValue<T> value;
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
        data: data,
        error: (error, st) =>
            Center(child: ErrorMessageWidget(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
