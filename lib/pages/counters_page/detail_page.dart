import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'counter_provider.dart';

class DetailPage extends HookWidget {
  const DetailPage({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<Counter> provider;

  @override
  Widget build(BuildContext context) {
    final controller = useProvider(provider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Detail'),
      ),
      body: Center(
        child: Text(
          'count: ${useProvider(provider.state)}',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: controller.increment,
      ),
    );
  }
}
