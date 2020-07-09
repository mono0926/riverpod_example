import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/util/util.dart';

import 'app.dart';

void main() {
  runApp(
    const ProviderScope(
      observers: [
        ProviderObserver(),
      ],
      child: App(),
    ),
  );
}

@immutable
class ProviderObserver implements ProviderStateOwnerObserver {
  const ProviderObserver();

  @override
  void didAddProvider(
    ProviderBase<ProviderDependencyBase, Object> provider,
    Object value,
  ) {
    logger.info('provider: $provider, value: $value');
  }

  @override
  void didDisposeProvider(
    ProviderBase<ProviderDependencyBase, Object> provider,
  ) {
    logger.info('provider: $provider');
  }

  @override
  void didUpdateProvider(
    ProviderBase<ProviderDependencyBase, Object> provider,
    Object newValue,
  ) {
    logger.info('provider: $provider, newValue: $newValue');
  }
}
