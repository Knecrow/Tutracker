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
      backgroundColor: AppColors.headerBackground,
      body: Stack(
        children: [
          child,
          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom + 12,
            child: _FloatingNavBar(
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
          ),
        ],
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
    const orangeAccent = Color(0xFFFF9800); // Samsung One UI Warm Amber

    return Container(
      height: 64,
      clipBehavior: Clip.none,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.headerBackground, // Deep Steel Blue capsule
        borderRadius: BorderRadius.circular(32), // Fully rounded floating pill
        border: Border.all(color: AppColors.headerBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _NavItem(icon: AppShell._icons[0], label: AppShell._labels[0], selected: selectedIndex == 0, onTap: () => onTap(0)),
          _NavItem(icon: AppShell._icons[1], label: AppShell._labels[1], selected: selectedIndex == 1, onTap: () => onTap(1)),

          // ── Center FAB (Popping Out of Pill, Clean & NO Glow) ───────────
          Transform.translate(
            offset: const Offset(0, -12),
            child: GestureDetector(
              onTap: onAdd,
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.orangeGradient,
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
              ),
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
        width: 58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 42,
              height: 28,
              decoration: BoxDecoration(
                color: selected ? orangeAccent.withValues(alpha: 0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 19, color: selected ? orangeAccent : AppColors.headerTextSecondary),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected ? orangeAccent : AppColors.headerTextSecondary,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
