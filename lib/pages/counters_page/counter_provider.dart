import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/util/util.dart';
import 'package:uuid/uuid.dart';

final counterId = Provider<String>((ref) => throw UnimplementedError());

final counterProvider = NotifierProvider.autoDispose<Counter, int>(
  dependencies: [
    counterId,
    counterStorageProvider,
  ],
  name: 'counterProvider',
  Counter.new,
);

class Counter extends AutoDisposeNotifier<int> {
  @override
  int build() {
    id = ref.watch(counterId);
    ref
      ..listen(counterStorageProvider, (previous, next) {
        state = _storage.count(id: id);
      })
      ..onDispose(() {
        logger.info('disposed(id: $id, state: $state)');
      });
    return ref.watch(counterStorageProvider.notifier).count(id: id);
  }

  late final String id;

  CounterStorage get _storage => ref.read(counterStorageProvider.notifier);

  void increment() {
    _storage.update(
      id: id,
      count: state + 1,
    );
  }
}

final counterStorageProvider =
    NotifierProvider.autoDispose<CounterStorage, Map<String, int>>(
  CounterStorage.new,
);

class CounterStorage extends AutoDisposeNotifier<Map<String, int>> {
  @override
  Map<String, int> build() => Map.fromEntries(
        List.generate(
          100,
          (_) => MapEntry(
            _uuid.v4(),
            0,
          ),
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
