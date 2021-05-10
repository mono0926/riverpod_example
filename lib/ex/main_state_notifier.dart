import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: _App(),
    ),
  );
}

final _controller = StateNotifierProvider<_Controller, Mutable>(
  (_) => _Controller(),
);

class Mutable {
  Mutable(this.value);
  int value;
}

class _Controller extends StateNotifier<Mutable> {
  _Controller() : super(Mutable(0));

  void increment() {
    state.value++;
    state = state;
  }
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _Home(),
    );
  }
}

class _Home extends HookWidget {
  const _Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = useProvider(_controller.notifier);
    final state = useProvider(_controller.select((s) => s));
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
