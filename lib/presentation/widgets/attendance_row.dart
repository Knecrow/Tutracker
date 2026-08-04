import 'package:flutter/material.dart';
import '../../../core/extensions/context_ext.dart';
// removed unused import

class AttendanceRow extends StatelessWidget {
  const AttendanceRow({
    super.key,
    required this.index,
    required this.isChecked,
    required this.timestamp,
    required this.onTapCalendar,
    required this.onToggle,
    required this.accentColor,
  });

  final int index;
  final bool isChecked;
  final String? timestamp;
  final VoidCallback onTapCalendar;
  final VoidCallback onToggle;
  final Color accentColor;

  String _formatDate(String isoString) {
    final dt = DateTime.parse(isoString);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color:
            isChecked ? accentColor.withValues(alpha: 0.08) : context.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isChecked
              ? accentColor.withValues(alpha: 0.3)
              : context.borderColor,
        ),
      ),
      child: Row(
        children: [
          // Class number and date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Class ${index + 1}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isChecked ? accentColor : context.primaryText,
                  ),
                ),
                if (isChecked && timestamp != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'Attended on ${_formatDate(timestamp!)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: context.secondaryText,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Calendar Button
          IconButton(
            onPressed: onTapCalendar,
            icon: Icon(
              Icons.calendar_month_rounded,
              color: isChecked ? accentColor : context.secondaryText,
              size: 20,
            ),
            tooltip: 'Select custom date',
          ),

          // Toggle Switch / Checkbox
          Switch.adaptive(
            value: isChecked,
            onChanged: (_) => onToggle(),
            activeThumbColor: accentColor,
          ),
        ],
      ),
    );
  }
}
