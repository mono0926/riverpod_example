import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/util/util.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:uuid/uuid.dart';

final counterProvider = AutoDisposeStateNotifierProvider<Counter>(
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
    AutoDisposeStateNotifierProviderFamily<Counter, String>(
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
    logger.info('disposed(state: $state)');
    _removeListener();
    super.dispose();
  }
}

final counterStorageProvider =
    AutoDisposeStateNotifierProvider((_) => CounterStorage());

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
