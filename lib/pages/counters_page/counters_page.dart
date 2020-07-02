import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/pages/counters_page/detail_page.dart';
import 'package:riverpod_example/providers/providers.dart';

import 'counter_provider.dart';

class CountersPage extends HookWidget {
  const CountersPage({Key key}) : super(key: key);

  static const routeName = '/counters';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pascalCaseFromRouteName(routeName)),
      ),
      body: ListView.separated(
        itemCount: 100,
        itemBuilder: (context, i) => ProviderScope(
          overrides: [
            counterProvider.overrideAs(
              Provider((ref) => ref.read(counterProviderFamily(i))),
            ),
          ],
          child: _Tile(
            index: i,
          ),
        ),
        separatorBuilder: (context, _) => const Divider(height: 0),
      ),
    );
  }
}

class _Tile extends HookWidget {
  const _Tile({
    Key key,
    @required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final controller = useProvider(counterProvider);
    return ListTile(
      title: Text('Counter $index'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${useProvider(counterProvider.state)}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(width: 16),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: const Icon(Icons.add),
            onPressed: controller.increment,
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (context) => ProviderScope(
              overrides: [
                counterProvider.overrideAs(
                  Provider((ref) => ref.read(counterProviderFamily(index))),
                ),
              ],
              child: const DetailPage(),
            ),
          ),
        );
      },
    );
  }
}
