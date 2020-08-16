import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recase/recase.dart';
import 'package:riverpod_example/home_page.dart';
import 'package:riverpod_example/pages/change_notofier_counter_page.dart';
import 'package:riverpod_example/pages/counter_navigation_page.dart';
import 'package:riverpod_example/pages/counter_page.dart';
import 'package:riverpod_example/pages/counters_page/counters_page.dart';

final routerProvider = Provider((_) => _Router());

class _Router {
  final Map<String, WidgetBuilder> pushRoutes = {
    HomePage.routeName: (_) => const HomePage(),
    CounterPage.routeName: (_) => const CounterPage(),
    ChangeNotifierCounterPage.routeName: (_) =>
        const ChangeNotifierCounterPage(),
    CounterDialogPage.routeName: (_) => const CounterDialogPage(),
    CountersPage.routeName: (_) => const CountersPage(),
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
  PageInfo({
    @required this.routeName,
    String pageName,
    this.subTitle,
  }) : pageName = pageName ?? pascalCaseFromRouteName(routeName);

  final String routeName;
  final String pageName;
  final String subTitle;

  static List<PageInfo> get all => [
        ...[
          CounterPage.routeName,
          ChangeNotifierCounterPage.routeName,
          CounterDialogPage.routeName,
        ].map((rn) => PageInfo(routeName: rn)),
        PageInfo(
          routeName: CountersPage.routeName,
          pageName: 'Counters',
          subTitle: 'Update Selection',
        ),
      ];
}
