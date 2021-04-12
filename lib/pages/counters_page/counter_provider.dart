import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/util/util.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:uuid/uuid.dart';

final selectedIdProvider = StateProvider<String>((_) => '');

AutoDisposeStateNotifierProvider<Counter, int> selectedCounterProvider(
        Reader read) =>
    counterProviders(read(selectedIdProvider).state);

final counterId = ScopedProvider<String>((ref) => throw UnimplementedError());

final counterProviders =
    StateNotifierProvider.autoDispose.family<Counter, int, String>(
  (ref, id) => Counter(ref.read, id: id),
);

class Counter extends StateNotifier<int> {
  Counter(
    this._read, {
    required this.id,
  }) : super(_read(counterStorageProvider.notifier).count(id: id)) {
    _removeListener = _storage.addListener((_) {
      state = _storage.count(id: id);
    });
  }

  final Reader _read;
  final String id;

  late RemoveListener _removeListener;

  CounterStorage get _storage => _read(counterStorageProvider.notifier);

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
    StateNotifierProvider.autoDispose<CounterStorage, Map<String, int>>(
  (_) => CounterStorage(),
);

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

  static const _uuid = Uuid();

  int count({required String id}) => state[id]!;

  void update({
    required String id,
    required int count,
  }) {
    state = {
      ...state,
      id: count,
    };
  }
}
