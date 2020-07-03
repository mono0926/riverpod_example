import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/util/util.dart';
import 'package:state_notifier/state_notifier.dart';

final _counterProvider = AutoDisposeStateNotifierProvider<_Counter>(
  (_ref) => _Counter(),
);

class _Counter extends StateNotifier<int> {
  _Counter() : super(0);

  void increment() => state++;

  @override
  void dispose() {
    logger.info('disposed(state: $state)');
    super.dispose();
  }
}

class CounterDialogPage extends HookWidget {
  const CounterDialogPage({Key key}) : super(key: key);

  static const routeName = '/counter_dialog';

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
            _CountText(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (context) => const _Dialog(),
          );
        },
        child: const Icon(Icons.open_in_new),
      ),
    );
  }
}

class _CountText extends HookWidget {
  const _CountText({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      '${useProvider(_counterProvider.state)}',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class _Dialog extends HookWidget {
  const _Dialog({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = useProvider(_counterProvider);
    return AlertDialog(
      title: const Text('Dialog'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('This BuildContext is independent of the page'),
          const Gap(8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _CountText(),
              const Gap(16),
              RaisedButton.icon(
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: const Text('INCREMENT'),
                onPressed: controller.increment,
              ),
            ],
          ),
        ],
      ),
      actions: [
        FlatButton(
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
          onPressed: Navigator.of(context).pop,
        ),
      ],
    );
  }
}
