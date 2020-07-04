import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'counter_provider.dart';

final selectedIdProvider = StateProvider<String>((_) => null);

final _detailPageCounterProvider = AutoDisposeStateNotifierProvider(
  (ref) => Counter(
    ref,
    id: ref.read(selectedIdProvider).state,
  ),
);

class DetailPage extends HookWidget {
  const DetailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useProvider(_detailPageCounterProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Detail'),
      ),
      body: Center(
        child: Text(
          'count: ${useProvider(_detailPageCounterProvider.state)}',
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
