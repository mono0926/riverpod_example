import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/util/util.dart';
import 'package:state_notifier/state_notifier.dart';

final counterProvider = StateNotifierProvider.autoDispose<Counter>(
  (_ref) {
    assert(
      false,
      'Should be overridden by AutoDisposeStateNotifierProviderFamily '
      'by using ProviderScope',
    );
    return null;
  },
);

final counterProviderFamily =
    StateNotifierProvider.autoDispose.family<Counter, int>(
  (_ref, _index) => Counter(),
);

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;

  @override
  void dispose() {
    logger.info('disposed(state: $state)');
    super.dispose();
  }
}
