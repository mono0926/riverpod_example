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
    ProviderBase<dynamic, dynamic> provider,
    Object value,
  ) {
    logger.info('provider: $provider, value: $value');
  }

  @override
  void didDisposeProvider(
    ProviderBase<dynamic, dynamic> provider,
  ) {
    logger.info('provider: $provider');
  }

  @override
  void didUpdateProvider(
    ProviderBase<dynamic, dynamic> provider,
    Object newValue,
  ) {
    logger.info('provider: $provider, newValue: $newValue');
  }

  @override
  void mayHaveChanged(ProviderBase<dynamic, dynamic> provider) {
    logger.info('provider: $provider');
  }
}
