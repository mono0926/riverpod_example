import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/util/util.dart';

final _counterProvider =
    NotifierProvider.autoDispose<_Counter, int>(_Counter.new);

class _Counter extends AutoDisposeNotifier<int> {
  _Counter();
  @override
  int build() {
    ref.onDispose(() => logger.info('disposed(state: $state)'));
    return 0;
  }

  void increment() => state++;
}

class CounterDialogPage extends ConsumerWidget {
  const CounterDialogPage({super.key});

  static const routeName = '/counter_dialog';

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

class _CountText extends ConsumerWidget {
  const _CountText();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      '${ref.watch(_counterProvider)}',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class _Dialog extends ConsumerWidget {
  const _Dialog();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              ElevatedButton.icon(
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: const Text('INCREMENT'),
                onPressed: ref.read(_counterProvider.notifier).increment,
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    );
  }
}
