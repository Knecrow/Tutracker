import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/haptics/haptic_service.dart';
import '../../../data/models/student.dart';
import '../../providers/student_provider.dart';

class AddStudentSheet extends ConsumerStatefulWidget {
  const AddStudentSheet({super.key});

  @override
  ConsumerState<AddStudentSheet> createState() => _AddStudentSheetState();
}

class _AddStudentSheetState extends ConsumerState<AddStudentSheet> {
  final _nameCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _feeCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _selectedColorIndex = 0;
  double _targetClasses = 8;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _subjectCtrl.dispose();
    _feeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.avatarPalette;
    final accent = context.accent;

    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: context.borderColor)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 24, top: 8, left: 20, right: 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: context.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text('Add Student', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                  color: context.primaryText, letterSpacing: -0.5)),
              const SizedBox(height: 20),

              // Color picker
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: palette.length,
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () { setState(() => _selectedColorIndex = i); HapticService.selection(); },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 36,
                      height: 36,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: palette[i],
                        shape: BoxShape.circle,
                        border: _selectedColorIndex == i
                            ? Border.all(color: context.primaryText, width: 2.5)
                            : Border.all(color: Colors.transparent, width: 2.5),
                      ),
                      child: _selectedColorIndex == i
                          ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Name
              TextFormField(
                controller: _nameCtrl,
                style: TextStyle(color: context.primaryText),
                decoration: InputDecoration(
                  hintText: 'Student name',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),

              // Subject
              TextFormField(
                controller: _subjectCtrl,
                style: TextStyle(color: context.primaryText),
                decoration: InputDecoration(
                  hintText: 'Subject / batch (optional)',
                  prefixIcon: const Icon(Icons.book_outlined),
                ),
              ),
              const SizedBox(height: 12),

              // Fee
              TextFormField(
                controller: _feeCtrl,
                style: TextStyle(color: context.primaryText),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Monthly fee',
                  prefixIcon: const Icon(Icons.monetization_on_outlined),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Fee is required';
                  if (double.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Target classes slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Target classes / month', style: TextStyle(fontSize: 13, color: context.secondaryText)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('${_targetClasses.toInt()}',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: accent)),
                  ),
                ],
              ),
              Slider(
                value: _targetClasses,
                min: 1,
                max: 31,
                divisions: 30,
                onChanged: (v) { setState(() => _targetClasses = v); HapticService.selection(); },
              ),
              const SizedBox(height: 20),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Add Student'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    HapticService.medium();
    final student = Student(
      id: const Uuid().v4(),
      name: _nameCtrl.text.trim(),
      subject: _subjectCtrl.text.trim().isEmpty ? null : _subjectCtrl.text.trim(),
      monthlyFee: double.parse(_feeCtrl.text),
      targetClasses: _targetClasses.toInt(),
      avatarColorValue: AppColors.avatarPalette[_selectedColorIndex].toARGB32(),
      createdAt: DateTime.now().toIso8601String(),
    );
    await ref.read(studentsProvider.notifier).addStudent(student);
    if (mounted) Navigator.pop(context);
  }
}
