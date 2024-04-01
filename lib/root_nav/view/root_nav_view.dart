import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stego_viz/core/stegoviz/stegoviz.dart';

import '../bloc/root_nav_cubit.dart';
import '../widgets/root_nav_bar.dart';

class RootNavComponents {
  RootNavComponents();

  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final List<Widget> _offstageList = [
    const StegoVizPage(),
    const StegoVizPage(),
    const StegoVizPage(),
  ];

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return _offstageList.elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(BuildContext context, int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _currentIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name]!(context),
          );
        },
      ),
    );
  }

  List<Widget> getOffstageNavigators(BuildContext context) {
    return [
      _buildOffstageNavigator(context, 0),
      _buildOffstageNavigator(context, 1),
      _buildOffstageNavigator(context, 2),
    ];
  }

  int get currentIndex => _currentIndex;
  set selectedIndex(newIndex) => _currentIndex = newIndex;
  List<GlobalKey<NavigatorState>> get navigatorKeys => _navigatorKeys;
}

class RootNavView extends StatelessWidget {
  RootNavView({super.key});

  final RootNavComponents rootNavComponents = RootNavComponents();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootNavCubit, RootNavState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: RootNavBar(
            currentIndex: state.navIndex,
            onTabPressed: (int index) {
              // If currently selected tab is selected again, return to the first page of the navigator
              if(rootNavComponents.currentIndex == index) {
                rootNavComponents.navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
              }
              rootNavComponents.selectedIndex = index;
              context.read<RootNavCubit>().navIndexChanged(index);
            },
          ),
          body: IndexedStack(
            index: rootNavComponents.currentIndex,
            children: rootNavComponents.getOffstageNavigators(context),
          ),
        );
      },
    );
  }
}
