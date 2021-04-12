import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/providers/providers.dart';
import 'package:riverpod_example/util/logger.dart';

import 'counter_provider.dart';
import 'detail_page.dart';

class CountersPage extends HookWidget {
  const CountersPage({Key? key}) : super(key: key);

  static const routeName = '/counters';

  @override
  Widget build(BuildContext context) {
    final ids = useProvider(
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

class _Tile extends HookWidget {
  const _Tile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = useProvider(counterId);
    logger.info('id: $id');
    final counterProvider = counterProviders(id);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return ListTile(
      title: const Text('Counter'),
      subtitle: Text(id),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${useProvider(counterProvider.select((s) => s))}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(width: 16),
          IconButton(
            color: colorScheme.primary,
            icon: const Icon(Icons.add),
            onPressed: context.read(counterProvider.notifier).increment,
          ),
        ],
      ),
      onTap: () {
        context.read(selectedIdProvider).state = id;
        Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (context) => const DetailPage(),
          ),
        );
      },
    );
  }
}
