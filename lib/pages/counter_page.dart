import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _counterProvider = StateProvider((ref) => 0);

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  static const routeName = '/counter';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'You have pushed the button this many times:',
            ),
            _Counter(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ref.read(_counterProvider.notifier).update((state) => state + 1),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Counter extends ConsumerWidget {
  const _Counter();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      '${ref.watch(_counterProvider)}',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
