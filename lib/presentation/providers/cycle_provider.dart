import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/billing_cycle.dart';
import '../../data/repositories/cycle_repository.dart';
import 'student_provider.dart';
import 'attendance_provider.dart';

final cycleRepositoryProvider = Provider<CycleRepository>((ref) {
  return CycleRepository();
});

/// Family provider: one CycleNotifier per student ID
final cycleProvider =
    StateNotifierProvider.family<CycleNotifier, BillingCycle?, String>(
  (ref, studentId) => CycleNotifier(studentId, ref.watch(cycleRepositoryProvider)),
);

final archivedCyclesProvider = Provider.family<List<BillingCycle>, String>((ref, studentId) {
  return ref.watch(cycleRepositoryProvider).getArchivedCycles(studentId);
});

class ArchivedCyclesNotifier extends StateNotifier<List<BillingCycle>> {
  ArchivedCyclesNotifier(this._repo) : super(_repo.getAllArchivedCycles());

  final CycleRepository _repo;

  void reload() {
    state = _repo.getAllArchivedCycles();
  }

  Future<void> togglePaidStatus(String cycleId) async {
    await _repo.togglePaidStatus(cycleId);
    reload();
  }
}

final allArchivedCyclesProvider =
    StateNotifierProvider<ArchivedCyclesNotifier, List<BillingCycle>>((ref) {
  return ArchivedCyclesNotifier(ref.watch(cycleRepositoryProvider));
});

class CycleNotifier extends StateNotifier<BillingCycle?> {
  CycleNotifier(this.studentId, this._repo) : super(null) {
    _load();
  }

  final String studentId;
  final CycleRepository _repo;

  void _load() {
    state = _repo.getActiveCycle(studentId);
  }

  Future<void> rollover(WidgetRef ref) async {
    final newCycle = await _repo.rollover(studentId);
    state = newCycle;

    // Invalidate downstream providers to refresh all UIs
    ref.invalidate(studentsProvider);
    ref.read(attendanceProvider(studentId).notifier).reload();
    ref.read(allArchivedCyclesProvider.notifier).reload();
  }
}
