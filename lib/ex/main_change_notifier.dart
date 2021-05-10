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

final _controller = ChangeNotifierProvider((_) => _Controller());

class _Controller extends ChangeNotifier {
  final mutable = Mutable(1);

  void increment() {
    mutable.value++;
    notifyListeners();
  }
}

class Mutable {
  Mutable(this.value);
  int value;
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
    final mutable = useProvider(_controller.select((c) => c.mutable));
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.read(_controller).increment(),
          child: Text('${mutable.value}'),
        ),
      ),
    );
  }
}
