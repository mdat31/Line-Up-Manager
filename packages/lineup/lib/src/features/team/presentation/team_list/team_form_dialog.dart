import 'package:flutter/material.dart';
import 'package:lineup/src/features/team/domain/entities/team.dart';
import 'package:lineup/src/features/team/presentation/team_labels.dart';

/// Create or edit a team; pops with the edited [Team] or null.
class TeamFormDialog extends StatefulWidget {
  const TeamFormDialog({super.key, this.initial});

  final Team? initial;

  static Future<Team?> show(BuildContext context, {Team? initial}) =>
      showDialog<Team>(
        context: context,
        builder: (_) => TeamFormDialog(initial: initial),
      );

  @override
  State<TeamFormDialog> createState() => _TeamFormDialogState();
}

class _TeamFormDialogState extends State<TeamFormDialog> {
  late final TextEditingController _name;
  late final TextEditingController _coach;
  late TeamFormat _format;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial?.name);
    _coach = TextEditingController(text: widget.initial?.coachName);
    _format = widget.initial?.format ?? TeamFormat.sevenASide;
  }

  @override
  void dispose() {
    _name.dispose();
    _coach.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final base = widget.initial ?? Team(name: '', format: _format);
    Navigator.of(context).pop(
      base.copyWith(
        name: _name.text.trim(),
        coachName: _coach.text.trim(),
        format: _format,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial == null ? 'Tạo đội' : 'Sửa đội'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Tên đội'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nhập tên đội' : null,
            ),
            TextFormField(
              controller: _coach,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'HLV / đội trưởng (tuỳ chọn)',
              ),
            ),
            const SizedBox(height: 16),
            SegmentedButton<TeamFormat>(
              segments: [
                for (final f in TeamFormat.values)
                  ButtonSegment(value: f, label: Text(f.label)),
              ],
              selected: {_format},
              onSelectionChanged: (s) => setState(() => _format = s.first),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Huỷ'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Lưu')),
      ],
    );
  }
}
