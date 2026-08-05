import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/haptics/haptic_service.dart';
import '../../providers/student_provider.dart';
import '../../providers/settings_provider.dart';

class EditStudentSheet extends ConsumerStatefulWidget {
  const EditStudentSheet({super.key, required this.studentId});
  final String studentId;

  @override
  ConsumerState<EditStudentSheet> createState() => _EditStudentSheetState();
}

class _EditStudentSheetState extends ConsumerState<EditStudentSheet> {
  final _nameController = TextEditingController();
  final _feeController = TextEditingController();
  final _subjectController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _targetClasses = 12;
  int _selectedColorIndex = 0;
  bool _saving = false;
  bool _loaded = false;

  @override
  void dispose() {
    _nameController.dispose();
    _feeController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  void _loadStudent() {
    if (_loaded) return;
    final students = ref.read(studentsProvider);
    final student = students.where((s) => s.id == widget.studentId).firstOrNull;
    if (student == null) return;
    _nameController.text = student.name;
    _feeController.text = student.monthlyFee.toStringAsFixed(0);
    _subjectController.text = student.subject ?? '';
    _targetClasses = student.targetClasses;
    _selectedColorIndex = AppColors.avatarPalette.indexWhere(
        (c) => c.toARGB32() == student.avatarColorValue);
    if (_selectedColorIndex < 0) _selectedColorIndex = 0;
    _loaded = true;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await HapticService.medium();

    final students = ref.read(studentsProvider);
    final existing = students.where((s) => s.id == widget.studentId).firstOrNull;
    if (existing == null) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final updated = existing.copyWith(
      name: _nameController.text.trim(),
      monthlyFee: double.parse(_feeController.text.trim()),
      targetClasses: _targetClasses,
      avatarColorValue: AppColors.avatarPalette[_selectedColorIndex].toARGB32(),
      subject: _subjectController.text.trim().isEmpty
          ? null
          : _subjectController.text.trim(),
    );

    await ref.read(studentsProvider.notifier).updateStudent(updated);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    _loadStudent();
    final isDark = context.isDark;
    final settings = ref.watch(settingsProvider);

    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
            border: Border.all(color: context.borderColor),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
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
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: context.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Update student information',
                      style: TextStyle(fontSize: 13, color: context.secondaryText),
                    ),
                    const SizedBox(height: 24),

                    // ── Name ─────────────────────────────────────────────────
                    _FieldLabel('Student Name'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Arham Khan',
                        prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Name is required'
                          : null,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),

                    // ── Subject / Notes ──────────────────────────────────────
                    _FieldLabel('Subject / Notes (optional)'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Math, Physics, SSC Batch...',
                        prefixIcon: Icon(Icons.book_outlined, size: 18),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),

                    // ── Monthly Fee ──────────────────────────────────────────
                    _FieldLabel('Monthly Fee'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _feeController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: 'e.g. 3000',
                        prefixIcon:
                            const Icon(Icons.account_balance_wallet_outlined, size: 18),
                        prefixText: '${settings.currencySymbol} ',
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Fee is required';
                        if (double.tryParse(v.trim()) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ── Target Classes ───────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _FieldLabel('Target Classes / Month'),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: context.accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$_targetClasses',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: context.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _targetClasses.toDouble(),
                      min: 1,
                      max: 30,
                      divisions: 29,
                      onChanged: (val) {
                        HapticService.selection();
                        setState(() => _targetClasses = val.toInt());
                      },
                    ),
                    const SizedBox(height: 16),

                    // ── Profile Theme Color ──────────────────────────────────
                    _FieldLabel('Profile Theme Color'),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 52,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: AppColors.avatarPalette.length,
                        itemBuilder: (context, i) {
                          final color = AppColors.avatarPalette[i];
                          final isSelected = _selectedColorIndex == i;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () {
                                HapticService.selection();
                                setState(() => _selectedColorIndex = i);
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? color
                                        : color.withValues(alpha: 0.4),
                                    width: isSelected ? 3.0 : 1.5,
                                  ),
                                ),
                                child: isSelected
                                    ? Center(
                                        child: Icon(
                                          Icons.check_rounded,
                                          color: color,
                                          size: 20,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Actions ──────────────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: context.borderColor),
                              minimumSize: const Size(0, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: context.secondaryText,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saving ? null : _save,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _saving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Save Changes'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: context.secondaryText,
          letterSpacing: 0.5,
        ),
      );
}
