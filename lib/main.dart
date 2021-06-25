import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/util/util.dart';

import 'app.dart';

void main() {
  runApp(
    const ProviderScope(
      observers: [
        _ProviderObserver(),
      ],
      child: App(),
    ),
  );
}

@immutable
class _ProviderObserver implements ProviderObserver {
  const _ProviderObserver();

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
  ) {
    logger.info('provider: $provider, value: $value');
  }

  @override
  void didDisposeProvider(
    ProviderBase provider,
  ) {
    logger.info('provider: $provider');
  }

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
  ) {
    logger.info('provider: $provider, newValue: $newValue');
  }
}
