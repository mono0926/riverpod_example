import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: _App(),
    ),
  );
}

final _controller = NotifierProvider<_Controller, Mutable>(_Controller.new);

class Mutable {
  Mutable(this.value);
  int value;
}

class _Controller extends Notifier<Mutable> {
  @override
  Mutable build() => Mutable(0);

  void increment() {
    state.value++;
    state = state;
  }
}

class _App extends StatelessWidget {
  const _App();
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _Home(),
    );
  }
}

class _Home extends ConsumerWidget {
  const _Home();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(_controller.notifier);
    final state = ref.watch(_controller.select((s) => s));
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: controller.increment,
          child: Text('${state.value}'),
        ),
      ),
    );
  }
}
