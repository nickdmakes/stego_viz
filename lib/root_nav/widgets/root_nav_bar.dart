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
        selectedFontSize: 11.0,
        selectedIconTheme: const IconThemeData(size: 30),
        selectedLabelStyle: const TextStyle(color: Colors.white),
        showSelectedLabels: true,
        selectedItemColor: Colors.white,
        unselectedFontSize: 10.0,
        unselectedIconTheme: const IconThemeData(size: 25),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        currentIndex: currentIndex,
        onTap: (index) {
          onTabPressed(index);
        },
        items: [
          _buildItem(TabItem.message),
          _buildItem(TabItem.color),
          _buildItem(TabItem.embed),
          _buildItem(TabItem.stats),
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

enum TabItem { message, color, embed, stats }

Map<TabItem, String> tabName = {
  TabItem.message: 'message',
  TabItem.color: 'color',
  TabItem.embed: 'embed',
  TabItem.stats: 'stats',
};

Map<TabItem, Icon?> activeTabIcon = {
  TabItem.message: const Icon(Icons.mail_lock_outlined, color: Colors.white),
  TabItem.color: const Icon(Icons.color_lens_outlined, color: Colors.white),
  TabItem.embed: const Icon(Icons.mode_edit_outlined, color: Colors.white),
  TabItem.stats: const Icon(Icons.bar_chart_outlined, color: Colors.white),
};

Map<TabItem, Icon?> nonActiveTabIcon = {
  TabItem.message: Icon(Icons.mail_lock_outlined, color: Colors.grey[500]),
  TabItem.color: Icon(Icons.color_lens_outlined, color: Colors.grey[500]),
  TabItem.embed: Icon(Icons.mode_edit_outlined, color: Colors.grey[500]),
  TabItem.stats: Icon(Icons.bar_chart_outlined, color: Colors.grey[500]),
};
