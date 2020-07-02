import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recase/recase.dart';
import 'package:riverpod_example/home_page.dart';
import 'package:riverpod_example/pages/counter_page.dart';

final routerProvider = Provider((_) => _Router());

class _Router {
  final Map<String, WidgetBuilder> pushRoutes = {
    HomePage.routeName: (_) => const HomePage(),
    CounterPage.routeName: (_) => const CounterPage(),
  };

  Route onGenerateRoute(RouteSettings settings) {
    final pushPage = pushRoutes[settings.name];
    return MaterialPageRoute<void>(
      settings: settings,
      builder: pushPage,
    );
  }
}

String pascalCaseFromRouteName(String name) => name.substring(1).pascalCase;

@immutable
class PageInfo {
  const PageInfo({
    @required this.routeName,
  });

  final String routeName;

  static List<PageInfo> get all => <String>[
        CounterPage.routeName,
      ].map((rn) => PageInfo(routeName: rn)).toList();
}
