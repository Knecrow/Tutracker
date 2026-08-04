import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/haptics/haptic_service.dart';
import '../../providers/student_provider.dart';
import '../../providers/settings_provider.dart';

class AddStudentSheet extends ConsumerStatefulWidget {
  const AddStudentSheet({super.key});

  @override
  ConsumerState<AddStudentSheet> createState() => _AddStudentSheetState();
}

class _AddStudentSheetState extends ConsumerState<AddStudentSheet> {
  final _nameController = TextEditingController();
  final _feeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _targetClasses = 12;
  int _selectedColorIndex = 0;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await HapticService.medium();

    await ref.read(studentsProvider.notifier).addStudent(
          name: _nameController.text.trim(),
          monthlyFee: double.parse(_feeController.text.trim()),
          targetClasses: _targetClasses,
          avatarColorValue:
              AppColors.avatarPalette[_selectedColorIndex].toARGB32(),
        );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final settings = ref.watch(settingsProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppConstants.radiusXL),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: context.themeExt.glassBlur * 1.5,
          sigmaY: context.themeExt.glassBlur * 1.5,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: (isDark ? const Color(0xFF131929) : const Color(0xFFF8FAFC))
                .withValues(alpha: 0.8),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusXL),
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
                      'New Tuition Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: context.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Add a student to start tracking attendance',
                      style: TextStyle(fontSize: 13, color: context.secondaryText),
                    ),
                    const SizedBox(height: 24),

                    // ── Name ────────────────────────────────────────────────
                    const _FieldLabel('Student Name'),
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

                    // ── Monthly Fee ─────────────────────────────────────────
                    const _FieldLabel('Monthly Fee'),
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
                        if (double.tryParse(v.trim()) == null)
                          return 'Enter a valid number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ── Target Classes ──────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _FieldLabel('Target Classes / Month'),
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

                    // ── Profile Theme Color ───────────────────────────────
                    const _FieldLabel('Profile Theme Color'),
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

                    // ── Actions ─────────────────────────────────────────────
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
                                : const Text('Save Profile'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
