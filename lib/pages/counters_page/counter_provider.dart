import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final counterProviderFamily =
    AutoDisposeStateNotifierProviderFamily<Counter, int>(
  (_ref, _index) => Counter(),
);

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;

  @override
  void dispose() {
    print('disposed(state: $state)');
    super.dispose();
  }
}
