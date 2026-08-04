import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/extensions/context_ext.dart';
import '../../core/theme/color_tokens.dart';
import '../../core/constants/app_constants.dart';
import '../../core/haptics/haptic_service.dart';

/// Shell widget that wraps the main tab routes and provides:
/// - Floating bottom navigation sheet
/// - FAB for adding a new student
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  static const _routes = ['/', '/analytics', '/history', '/settings'];
  static const _icons = [
    Icons.home_rounded,
    Icons.bar_chart_rounded,
    Icons.calendar_month_rounded,
    Icons.settings_rounded,
  ];
  static const _labels = ['Home', 'Insights', 'History', 'Settings'];

  int _indexFromLocation(String location) {
    // Match by prefix so nested routes still highlight the right tab
    for (var i = _routes.length - 1; i >= 0; i--) {
      if (location.startsWith(_routes[i])) return i;
    }
    return 0;
  }

  void _onTap(int index, BuildContext context) {
    HapticService.light();
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    // Sync tab with actual GoRouter location — no internal state needed
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _indexFromLocation(location);

    return Scaffold(
      backgroundColor: context.background,
      body: child,
      floatingActionButton: _buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(context, isDark, selectedIndex),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [context.accent, context.accentBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: context.isDark
            ? [
                BoxShadow(
                  color: context.accent.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: context.accent.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            HapticService.medium();
            context.push('/add-student');
          },
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildBottomNav(
      BuildContext context, bool isDark, int selectedIndex) {
    return Container(
      height: 72 + context.padding.bottom,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Left items
            _NavItem(
              icon: _icons[0],
              label: _labels[0],
              selected: selectedIndex == 0,
              onTap: () => _onTap(0, context),
            ),
            _NavItem(
              icon: _icons[1],
              label: _labels[1],
              selected: selectedIndex == 1,
              onTap: () => _onTap(1, context),
            ),
            // FAB gap
            const SizedBox(width: 56),
            // Right items
            _NavItem(
              icon: _icons[2],
              label: _labels[2],
              selected: selectedIndex == 2,
              onTap: () => _onTap(2, context),
            ),
            _NavItem(
              icon: _icons[3],
              label: _labels[3],
              selected: selectedIndex == 3,
              onTap: () => _onTap(3, context),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: AppConstants.minTouchTarget + 8,
        height: AppConstants.minTouchTarget + 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: selected
                    ? accent.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 22,
                color: selected ? accent : context.secondaryText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? accent : context.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
