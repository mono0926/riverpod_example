import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/providers/providers.dart';

import 'counter_provider.dart';
import 'detail_page.dart';

class CountersPage extends HookWidget {
  const CountersPage({Key key}) : super(key: key);

  static const routeName = '/not_recommended_counters';

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
            ProviderOverride(
              Provider<Counter>((ref) => ref.read(counterProviderFamily(i))),
              counterProvider,
            )
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
            color: colorScheme.primary,
            icon: const Icon(Icons.add),
            onPressed: controller.increment,
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push<void>(
          MaterialPageRoute(
            // How to pass the provider overridden by using ProviderScope
            // Not recommended actually:
            // https://twitter.com/remi_rousselet/status/1278592878638436353
            builder: (context) => ProviderScope(
              overrides: [
                ProviderOverride(
                  Provider<Counter>(
                    (ref) => ref.read(counterProviderFamily(index)),
                  ),
                  counterProvider,
                )
              ],
              child: const DetailPage(),
            ),
          ),
        );
      },
    );
  }
}
