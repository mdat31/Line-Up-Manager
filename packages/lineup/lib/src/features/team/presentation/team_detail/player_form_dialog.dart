import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lineup/src/features/team/domain/entities/player.dart';
import 'package:lineup/src/features/team/presentation/team_labels.dart';

/// Add or edit a player; pops with the edited [Player] or null.
class PlayerFormDialog extends StatefulWidget {
  const PlayerFormDialog({super.key, required this.initial});

  final Player initial;

  static Future<Player?> show(BuildContext context, Player initial) =>
      showDialog<Player>(
        context: context,
        builder: (_) => PlayerFormDialog(initial: initial),
      );

  @override
  State<PlayerFormDialog> createState() => _PlayerFormDialogState();
}

class _PlayerFormDialogState extends State<PlayerFormDialog> {
  late final TextEditingController _name;
  late final TextEditingController _number;
  late PlayerPosition _position;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial.name);
    _number = TextEditingController(text: widget.initial.number?.toString());
    _position = widget.initial.position;
  }

  @override
  void dispose() {
    _name.dispose();
    _number.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final number = int.tryParse(_number.text);
    Navigator.of(context).pop(
      widget.initial.copyWith(
        name: _name.text.trim(),
        number: number,
        clearNumber: number == null,
        position: _position,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial.id == null ? 'Thêm cầu thủ' : 'Sửa cầu thủ'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Tên'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nhập tên' : null,
            ),
            TextFormField(
              controller: _number,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: const InputDecoration(labelText: 'Số áo'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PlayerPosition>(
              initialValue: _position,
              decoration: const InputDecoration(labelText: 'Vị trí'),
              items: [
                for (final p in PlayerPosition.values)
                  DropdownMenuItem(value: p, child: Text(p.label)),
              ],
              onChanged: (p) => setState(() => _position = p ?? _position),
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
