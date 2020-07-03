import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/util/util.dart';
import 'package:state_notifier/state_notifier.dart';

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
    AutoDisposeStateNotifierProviderFamily<Counter, int>(
  (ref, index) => Counter(ref, index: index),
);

class Counter extends StateNotifier<int> {
  Counter(
    this._ref, {
    @required this.index,
  }) : super(_ref.read(_dataSourceProvider).count(index: index)) {
    _removeListener = _dataSource.addListener((_) {
      state = _dataSource.count(index: index);
    });
  }

  final ProviderReference _ref;
  final int index;

  RemoveListener _removeListener;

  _DataSource get _dataSource => _ref.read(_dataSourceProvider);

  void increment() {
    _dataSource.update(
      index: index,
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

final _dataSourceProvider =
    AutoDisposeStateNotifierProvider((_) => _DataSource());

class _DataSource extends StateNotifier<Map<int, int>> {
  _DataSource() : super(<int, int>{});

  int count({@required int index}) => state[index] ?? 0;

  void update({
    @required int index,
    @required int count,
  }) {
    state = {
      ...state,
      index: count,
    };
  }
}
