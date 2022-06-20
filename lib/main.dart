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
    ProviderBase<dynamic> provider,
    Object? value,
    ProviderContainer container,
  ) {
    logger.info('provider: $provider, value: $value');
  }

  @override
  void didDisposeProvider(
    ProviderBase<dynamic> provider,
    ProviderContainer container,
  ) {
    logger.info('provider: $provider');
  }

  @override
  void didUpdateProvider(
    ProviderBase<dynamic> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    logger.info('provider: $provider, newValue: $newValue');
  }

  @override
  void providerDidFail(
    ProviderBase<dynamic> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    logger.info(
      'provider: $provider'
      ', error: $error'
      ', stackTrace: $stackTrace'
      ', container: $container',
    );
  }
}
