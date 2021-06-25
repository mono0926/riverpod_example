import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'counter_provider.dart';

class DetailPage extends HookWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = selectedCounterProvider(useProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Detail'),
      ),
      body: Center(
        child: Text(
          'count: ${useProvider(provider)}',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.read(provider.notifier).increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
