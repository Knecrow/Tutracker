import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/student.dart';
import '../../data/repositories/student_repository.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository();
});

final studentsProvider = StateNotifierProvider<StudentsNotifier, List<Student>>((ref) {
  return StudentsNotifier(ref.watch(studentRepositoryProvider));
});

class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier(this._repo) : super([]) {
    load();
  }

  final StudentRepository _repo;

  void load() {
    state = _repo.getAll();
  }

  Future<void> addStudent({
    required String name,
    required double monthlyFee,
    required int targetClasses,
    required int avatarColorValue,
    String? subject,
  }) async {
    await _repo.add(
      name: name,
      monthlyFee: monthlyFee,
      targetClasses: targetClasses,
      avatarColorValue: avatarColorValue,
      subject: subject,
    );
    load();
  }

  Future<void> updateStudent(Student student) async {
    await _repo.update(student);
    load();
  }

  Future<void> deleteStudent(String id) async {
    await _repo.delete(id);
    load();
  }
}
