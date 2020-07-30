import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _counterProvider = ChangeNotifierProvider((ref) => _CountNotifier());

class _CountNotifier with ChangeNotifier {
  var _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class ChangeNotifierCounterPage extends StatelessWidget {
  const ChangeNotifierCounterPage({Key key}) : super(key: key);

  static const routeName = '/change_notifier_counter';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Consumer(
              (context, read) => Text(
                '${read(_counterProvider).count}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            const _NotRebuiltCount(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read(_counterProvider).increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _NotRebuiltCount extends HookWidget {
  const _NotRebuiltCount({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Get controller(ChangeNotifier) without pointless rebuild
    final controller = useProvider(_counterProvider.select((s) => s));
    return Text(
      // Don't do this!
      '${controller.count}',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
