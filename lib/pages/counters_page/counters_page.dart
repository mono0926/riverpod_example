import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/providers/providers.dart';
import 'package:riverpod_example/util/logger.dart';

import 'counter_provider.dart';
import 'detail_page.dart';

class CountersPage extends ConsumerWidget {
  const CountersPage({super.key});

  static const routeName = '/counters';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(
      counterStorageProvider.select((s) => s.keys.toList()),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(pascalCaseFromRouteName(routeName)),
      ),
      body: ListView.separated(
        itemCount: ids.length,
        itemBuilder: (context, index) {
          final id = ids[index];
          return ProviderScope(
            key: ValueKey(id),
            overrides: [
              counterId.overrideWithValue(id),
            ],
            child: const _Tile(),
          );
        },
        separatorBuilder: (context, _) => const Divider(height: 0),
      ),
    );
  }
}

class _Tile extends ConsumerWidget {
  const _Tile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(counterProvider.notifier);
    logger.info('id: ${notifier.id}');
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return ListTile(
      title: const Text('Counter'),
      subtitle: Text(notifier.id),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${ref.watch(counterProvider.select((s) => s))}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(width: 16),
          IconButton(
            color: colorScheme.primary,
            icon: const Icon(Icons.add),
            onPressed: notifier.increment,
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (routeContext) => ProviderScope(
              parent: ProviderScope.containerOf(context),
              child: const DetailPage(),
            ),
          ),
        );
      },
    );
  }
}
