import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final counterProvider = AutoDisposeStateNotifierProviderFamily<Counter, int>(
  (_ref, _index) => Counter(),
);

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
}
