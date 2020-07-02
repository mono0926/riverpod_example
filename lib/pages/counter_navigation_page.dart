import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _counterProvider = StateProvider((ref) => 0);

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
            _Counter(),
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

class _Counter extends HookWidget {
  const _Counter({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      '${useProvider(_counterProvider).state}',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class _Dialog extends StatelessWidget {
  const _Dialog({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
              const _Counter(),
              const Gap(16),
              RaisedButton.icon(
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: const Text('INCREMENT'),
                onPressed: () => _counterProvider.read(context).state++,
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
