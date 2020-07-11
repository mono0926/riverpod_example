import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/util/util.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:uuid/uuid.dart';
// ignore: implementation_imports
import 'package:riverpod/src/state_notifier_provider/auto_dispose_state_notifier_provider.dart';

final selectedIdProvider = StateProvider<String>((_) => null);

typedef SelectionConsumer<T> = StateController<T> Function(
  StateProvider<T> selectedProvider,
);

AutoDisposeStateNotifierProvider<Counter> selectedCounterProvider(
  SelectionConsumer<String> consumer,
) =>
    counterProviders(consumer(selectedIdProvider).state);

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

final counterProviders =
    StateNotifierProvider.autoDispose.family<Counter, String>(
  (ref, id) => Counter(ref, id: id),
);

class Counter extends StateNotifier<int> {
  Counter(
    this._ref, {
    @required this.id,
  }) : super(_ref.read(counterStorageProvider).count(id: id)) {
    _removeListener = _storage.addListener((_) {
      state = _storage.count(id: id);
    });
  }

  final ProviderReference _ref;
  final String id;

  RemoveListener _removeListener;

  CounterStorage get _storage => _ref.read(counterStorageProvider);

  void increment() {
    _storage.update(
      id: id,
      count: state + 1,
    );
  }

  @override
  void dispose() {
    logger.info('disposed(id: $id, state: $state)');
    _removeListener();
    super.dispose();
  }
}

final counterStorageProvider =
    StateNotifierProvider.autoDispose((_) => CounterStorage());

class CounterStorage extends StateNotifier<Map<String, int>> {
  CounterStorage()
      : super(
          Map.fromEntries(
            List.generate(
                100,
                (_) => MapEntry(
                      _uuid.v4(),
                      0,
                    )),
          ),
        );

  static final _uuid = Uuid();

  int count({@required String id}) => state[id];

  void update({
    @required String id,
    @required int count,
  }) {
    state = {
      ...state,
      id: count,
    };
  }
}
