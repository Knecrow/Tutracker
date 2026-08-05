import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/extensions/context_ext.dart';
import '../../core/theme/color_tokens.dart';
import '../../core/haptics/haptic_service.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  static const _routes = ['/', '/analytics', '/history', '/settings'];
  static const _icons = [
    Icons.home_rounded,
    Icons.bar_chart_rounded,
    Icons.history_rounded,
    Icons.settings_rounded,
  ];
  static const _labels = ['Home', 'Insights', 'History', 'Settings'];

  int _indexFromLocation(String loc) {
    for (var i = _routes.length - 1; i >= 0; i--) {
      if (loc.startsWith(_routes[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _indexFromLocation(location);

    return Scaffold(
      backgroundColor: context.background,
      body: child,
      bottomNavigationBar: _FloatingNavBar(
        selectedIndex: selectedIndex,
        onTap: (i) {
          HapticService.light();
          context.go(_routes[i]);
        },
        onAdd: () {
          HapticService.medium();
          context.push('/add-student');
        },
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({
    required this.selectedIndex,
    required this.onTap,
    required this.onAdd,
  });

  final int selectedIndex;
  final void Function(int) onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    const orangeAccent = Color(0xFFFF9800); // Samsung One UI Warm Amber
    final navBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 72 + bottomPad,
      padding: EdgeInsets.only(bottom: bottomPad, left: 16, right: 16, top: 4),
      decoration: BoxDecoration(
        color: navBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _NavItem(icon: AppShell._icons[0], label: AppShell._labels[0], selected: selectedIndex == 0, onTap: () => onTap(0)),
          _NavItem(icon: AppShell._icons[1], label: AppShell._labels[1], selected: selectedIndex == 1, onTap: () => onTap(1)),

          // ── Samsung One UI Center FAB ────────────────────────────────────
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.orangeGradient,
                boxShadow: [
                  BoxShadow(
                    color: orangeAccent.withValues(alpha: isDark ? 0.45 : 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
            ),
          ),

          _NavItem(icon: AppShell._icons[2], label: AppShell._labels[2], selected: selectedIndex == 2, onTap: () => onTap(2)),
          _NavItem(icon: AppShell._icons[3], label: AppShell._labels[3], selected: selectedIndex == 3, onTap: () => onTap(3)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const orangeAccent = Color(0xFFFF9800); // Samsung One UI Warm Amber

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 44,
              height: 30,
              decoration: BoxDecoration(
                color: selected ? orangeAccent.withValues(alpha: 0.18) : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 20, color: selected ? orangeAccent : context.secondaryText),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                color: selected ? orangeAccent : context.secondaryText,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
