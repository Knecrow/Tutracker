class AppConstants {
  AppConstants._();

  // Touch targets
  static const double minTouchTarget = 48.0;
  static const double fabSize = 56.0;

  // Border radii
  static const double radiusXS = 8.0;
  static const double radiusSM = 12.0;
  static const double radiusMD = 16.0;
  static const double radiusLG = 20.0;
  static const double radiusXL = 28.0;
  static const double radiusFull = 100.0;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Glassmorphic card padding
  static const double cardPaddingH = 16.0;
  static const double cardPaddingV = 14.0;

  // Home screen student card grid
  static const double attendanceCardSize = 56.0;
  static const double attendanceGridSpacing = 8.0;
  static const int attendanceGridCrossAxisCount = 4;

  // Animation durations
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animMedium = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
  static const Duration animChartDraw = Duration(milliseconds: 800);

  // Hive box names
  static const String studentsBox = 'students';
  static const String attendanceBox = 'attendance_logs';
  static const String cyclesBox = 'billing_cycles';
  static const String settingsBox = 'app_settings';

  // Currency symbol (configurable)
  static const String currencySymbol = '৳';

  // Max students per app
  static const int maxStudents = 20;
}
