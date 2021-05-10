import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'test.freezed.dart';

class Mutable {
  Mutable(this.value);
  int value;
  @override
  String toString() => 'value: $value';
}

class Immutable {
  Immutable(this.value);
  final int value;
}

// @immutableアノテーション付ける
@immutable
class Immutable2 {
  // 全てのフィールドがfinalだと生成後に不変であることが保証されるのでconstにできる。
  // (@immutableにより、constを付けないと警告がでて指定漏れを教えてくれる)
  const Immutable2(this.value);
  // finalが欠けるとimmutableとして成り立たないのでコンパイルエラー
  final int value;
}

@freezed
class Immutable3 with _$Immutable3 {
  const factory Immutable3(int value) = _Immutable3;
}

@freezed
class Immutable4 with _$Immutable4 {
  const factory Immutable4(List<int> values) = _Immutable4;
}

@freezed
abstract class Immutable5 with _$Immutable5 {
  const factory Immutable5(Immutable4 value) = _Immutable5;
}

void f() {
  var state = const Immutable5(
    Immutable4(
      [1, 2],
    ),
  );
  state = state.copyWith(
    value: state.value.copyWith(
      values: [1, 2],
    ),
  );
  state = state.copyWith.value(
    values: [1, 2],
  );
}

void main() {
  test('mutable', () {
    final x1 = Mutable(1);
    final x2 = x1;
    x1.value++;
    expect(x1.value, 2);
    // x2とx1の参照先は同一なのでx1のvalueが変更されるとm2も変更される
    expect(x2.value, 2);
    expect(x1 == x2, isTrue);
    expect(identical(x1, x2), isTrue);
  });

  test('immutable', () {
    var x1 = Immutable(1);
    final x2 = x1;
    // 後から変更不可能(=immutable)
    // x1.value++;

    // immutableなオブジェクトは変更操作ができず
    // 違う値を持たせたい場合は再生成が必要
    x1 = Immutable(x1.value + 1);
    expect(x1.value, 2);
    // x1を変更したわけではなく再生成したのでx2のvalueは元のまま
    expect(x2.value, 1);
    // 参照も違う
    expect(identical(x1, x2), isFalse);
  });

  test('immutable const', () {
    final x1 = Immutable2(1);
    final x2 = Immutable2(1);
    expect(identical(x1, x2), isFalse);

    const x3 = Immutable2(1);
    const x4 = Immutable2(1);
    expect(identical(x3, x4), isTrue);
  });

  test('immutable freezed', () {
    var x1 = const Immutable3(1);
    final x2 = x1;
    // freezedを使うと、特定のフィールドを更新しつつ
    // それ以外のフィールドの値は維持された
    // 新しいオブジェクトとしてコピーするメソッドを自動生成してくれる
    // (手動でももちろんそういうメソッドを定義すれば済むが、
    // 自動生成だと楽かつ実装ミスでのバグの心配も不要)
    x1 = x1.copyWith(value: x1.value + 1);
    expect(x1.value, 2);
    expect(x2.value, 1);
    expect(identical(x1, x2), isFalse);
  });

  test('list mutable', () {
    final list1 = [Mutable(1), Mutable(2)];
    final list2 = list1;
    list1[0] = Mutable(3);
    // list1の変更にlist2が完全に巻き込まれる
    print(list1); // [value: 3, value: 2]
    print(list2); // [value: 3, value: 2]
    expect(list1 == list2, isTrue);
  });

  test('list mutable shallow copy', () {
    var list1 = [Mutable(1), Mutable(2)];
    final list2 = list1;
    list1 = List.of(list1);
    list1[0] = Mutable(3);
    // list1はシャローコピーされてから変更されたため、
    // list2はその影響を受けない
    print(list1); // [value: 3, value: 2]
    print(list2); // [value: 1, value: 2]
    expect(list1 == list2, isFalse);
  });

  test('list mutable shallow copy broken', () {
    var list1 = [Mutable(1), Mutable(2)];
    final list2 = list1;
    list1 = List.of(list1);
    list1[0] = Mutable(3);
    list1[1].value = 4;
    // シャローコピー後でも、mutableな同一インスタンスの
    // 変更操作をされるとその影響を受けてしまう
    print(list1); // [value: 3, value: 4]
    print(list2); // [value: 1, value: 4]
    expect(list1 == list2, isFalse);
  });

  test('list immutable shallow copy', () {
    var list1 = const [Immutable3(1), Immutable3(2)];
    final list2 = list1;
    list1 = List.of(list1);
    list1[0] = const Immutable3(3);
    // mutate操作は不可能
    // list1[1].value = 4;
    // list2自体に触れずにその変更をすることは不可能
    print(list1); // [value: 3, value: 4]
    print(list2); // [value: 1, value: 2]
    expect(list1 == list2, isFalse);
  });
  test('list immutable shallow copy borken', () {
    var list1 = [
      [Immutable3(1)],
      [Immutable3(2)]
    ];
    final list2 = list1;
    list1 = List.of(list1);
    list1[0].clear();
    // list2自体に触れずにその変更をすることは不可能
    print(list1); // [[], [value: 2]]
    print(list2); // [[], [value: 2]]
    expect(list1 == list2, isFalse);
  });

  test('Immutable mutable list', () {
    final x1 = Immutable4([1, 2]);
    final x2 = x1;
    x1.values.clear();
    print(x1); // values: []
    print(x2); // values: []
  });

  test('lImmutable mutable unmodified list', () {
    final x1 = Immutable4(UnmodifiableListView([1, 2]));
    final x2 = x1;
    // 実行時エラー(Unsupported operation: Cannot clear an unmodifiable list)
    // x1.values.clear();
  });

  test('collection operation List', () {
    final x1 = [1, 2];
    final x2 = List.of(x1)..add(3);
    final x3 = [
      ...x1,
      3,
    ];
    expect(x1, [1, 2]);
    expect(x2, [1, 2, 3]);
    expect(x3, [1, 2, 3]);
  });

  test('collection operation Set', () {
    final x1 = {1, 2};
    final x2 = Set.of(x1)..add(2)..add(3);
    final x3 = [
      ...x1,
      2,
      3,
    ];
    expect(x1, {1, 2});
    expect(x2, {1, 2, 3});
    expect(x3, {1, 2, 3});
  });

  test('collection operation Map', () {
    final x1 = {'a': 1, 'b': 2};
    final x2 = Map.of(x1)..['c'] = 3;
    final x3 = {
      ...x1,
      'c': 3,
    };
    expect(x1, {'a': 1, 'b': 2});
    expect(x2, {'a': 1, 'b': 2, 'c': 3});
    expect(x3, {'a': 1, 'b': 2, 'c': 3});
  });
}

class FooNotifier extends StateNotifier<Immutable4> {
  FooNotifier() : super(const Immutable4([]));

  void add(int value) {
    state = state.copyWith(
      // 2. 外から `state.values`に対して直接mutate操作されることも防ぐ
      values: UnmodifiableListView(
        // 1. シャローコピーで元のvaluesと相互に変更の影響を受けないようにする
        [
          ...state.values,
          value,
        ],
      ),
    );
  }
}
