import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/constants/app_constants.dart';
import 'data/models/student.dart';
import 'data/models/attendance_log.dart';
import 'data/models/billing_cycle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(StudentAdapter());
  Hive.registerAdapter(AttendanceLogAdapter());
  Hive.registerAdapter(BillingCycleAdapter());

  await Hive.openBox<Student>(AppConstants.studentsBox);
  await Hive.openBox<AttendanceLog>(AppConstants.attendanceBox);
  await Hive.openBox<BillingCycle>(AppConstants.cyclesBox);
  await Hive.openBox(AppConstants.settingsBox);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF14243B),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: TuTrackerApp()));
}

class TuTrackerApp extends ConsumerWidget {
  const TuTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Tutracker',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
