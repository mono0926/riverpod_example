import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _counterProvider = StateProvider((ref) => 0);

class CounterPage extends HookWidget {
  const CounterPage({Key? key}) : super(key: key);

  static const routeName = '/counter';

  @override
  Widget build(BuildContext context) {
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
        onPressed: () => context.read(_counterProvider).state++,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Counter extends HookWidget {
  const _Counter({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      '${useProvider(_counterProvider).state}',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
