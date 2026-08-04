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
    final accent = context.accent;
    final navBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 68 + bottomPad,
      padding: EdgeInsets.only(bottom: bottomPad, left: 12, right: 12, top: 0),
      decoration: BoxDecoration(
        color: navBg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _NavItem(icon: AppShell._icons[0], label: AppShell._labels[0], selected: selectedIndex == 0, onTap: () => onTap(0)),
          _NavItem(icon: AppShell._icons[1], label: AppShell._labels[1], selected: selectedIndex == 1, onTap: () => onTap(1)),

          // ── Centre FAB ──────────────────────────────────────────────────
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [accent, accent.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: isDark
                    ? [BoxShadow(color: accent.withValues(alpha: 0.35), blurRadius: 14, offset: const Offset(0, 4))]
                    : [BoxShadow(color: accent.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
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
    final accent = context.accent;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 36,
              height: 28,
              decoration: BoxDecoration(
                color: selected ? accent.withValues(alpha: 0.14) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 19, color: selected ? accent : context.secondaryText),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? accent : context.secondaryText,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
