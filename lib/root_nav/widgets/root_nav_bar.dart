import 'package:flutter/material.dart';

class RootNavBar extends StatelessWidget {
  const RootNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabPressed,
  });

  final int currentIndex;
  final Function(int) onTabPressed;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // no splash when button is pressed
        iconSize: 28,
        selectedFontSize: 0.0,
        selectedLabelStyle: const TextStyle(color: Colors.white),
        showSelectedLabels: true,
        selectedItemColor: Colors.white,
        unselectedFontSize: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: currentIndex,
        onTap: (index) {
          onTabPressed(index);
        },
        items: [
          _buildItem(TabItem.picks),
          _buildItem(TabItem.rankings),
          _buildItem(TabItem.profile),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    return BottomNavigationBarItem(
      icon: (nonActiveTabIcon)[tabItem] ??
          const Icon(Icons.mood_bad, color: Colors.grey),
      activeIcon:
      (activeTabIcon)[tabItem] ?? const Icon(Icons.mood_bad, color: Colors.grey),
      label: tabName[tabItem],
    );
  }
}

enum TabItem { picks, rankings, sets, profile }

Map<TabItem, String> tabName = {
  TabItem.picks: 'Picks',
  TabItem.rankings: 'Rankings',
  TabItem.profile: 'profile'
};

Map<TabItem, Icon?> activeTabIcon = {
  TabItem.picks: const Icon(Icons.sports_football, color: Colors.white),
  TabItem.rankings: const Icon(Icons.emoji_events_rounded, color: Colors.white),
  TabItem.profile: const Icon(Icons.person, color: Colors.white),
};

Map<TabItem, Icon?> nonActiveTabIcon = {
  TabItem.picks: Icon(Icons.sports_football, color: Colors.grey[500]),
  TabItem.rankings: Icon(Icons.emoji_events_rounded, color: Colors.grey[500]),
  TabItem.profile: Icon(Icons.person, color: Colors.grey[500]),
};
