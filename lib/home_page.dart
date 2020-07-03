import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/providers/providers.dart';

import 'providers/providers.dart';

class HomePage extends HookWidget {
  const HomePage({Key key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(useProvider(titleProvider)),
        actions: const [
          _PopupMenuButton(),
        ],
      ),
      body: ListView(
        children: [
          ...PageInfo.all.map((info) {
            return ListTile(
              title: Text(info.pageName),
              subtitle: info.subTitle == null ? null : Text(info.subTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).pushNamed(info.routeName),
            );
          }),
        ],
      ),
    );
  }
}

class _PopupMenuButton extends HookWidget {
  const _PopupMenuButton({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_Menu>(
      itemBuilder: (context) => _Menu.values
          .map((menu) => PopupMenuItem(
                value: menu,
                child: Text(describeEnum(menu)),
              ))
          .toList(),
      onSelected: (menu) async {
        switch (menu) {
          case _Menu.theme:
            themeProvider.read(context).showThemeSelection();
            break;
        }
      },
    );
  }
}

enum _Menu {
  theme,
}
