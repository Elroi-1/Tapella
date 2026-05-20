import 'package:flutter/widgets.dart';

class TabSelector extends StatefulWidget {
  final String selectedTab;
  final ValueChanged<String> onTabChanged;
  final List<String> tabs;

  const TabSelector({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    this.tabs = const ['All', 'Accepted', 'Pending', 'Rejected', 'Completed'],
  });

  @override
  State<StatefulWidget> createState() {
    return _TabSelectorState();
  }
}

class _TabSelectorState extends State<TabSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(children: widget.tabs.map((tab) => _buildTab(tab)).toList());
  }

  Widget _buildTab(String title) {
    final bool active = widget.selectedTab == title;

    return GestureDetector(
      onTap: () {
        widget.onTabChanged(title);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 18),
        child: Column(
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: active
                    ? const Color(0xFF60A5FA)
                    : const Color(0xFF94A3B8),
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
                fontFamily: 'Inter',
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 16),
            if (active)
              Container(width: 65, height: 2, color: const Color(0xFF60A5FA)),
          ],
        ),
      ),
    );
  }
}
