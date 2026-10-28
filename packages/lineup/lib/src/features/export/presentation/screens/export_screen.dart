import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lineup/src/features/export/domain/entities/export_template.dart';
import 'package:lineup/src/features/export/domain/entities/lineup_card.dart';
import 'package:lineup/src/features/export/presentation/bloc/export_cubit.dart';
import 'package:lineup/src/features/export/presentation/bloc/export_state.dart';
import 'package:lineup/src/features/export/presentation/widgets/lineup_card_view.dart';
import 'package:lineup/src/lineup_scope.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key, required this.card});

  final LineupCard card;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExportCubit(LineupScope.of(context).exporter, card),
      child: const _ExportView(),
    );
  }
}

class _ExportView extends StatefulWidget {
  const _ExportView();

  @override
  State<_ExportView> createState() => _ExportViewState();
}

class _ExportViewState extends State<_ExportView> {
  /// 360 x 450 logical at 3x gives 1080 x 1350, the 4:5 feed size.
  static const _pixelRatio = 3.0;

  final _boundaryKey = GlobalKey();

  Future<Uint8List> _capture() async {
    final boundary =
        _boundaryKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: _pixelRatio);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      return data!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  }

  void _showOutcome(BuildContext context, ExportOutcome outcome) {
    final message = switch (outcome) {
      ExportOutcome.saved => 'Đã lưu vào thư viện ảnh',
      ExportOutcome.denied =>
        'Chưa có quyền lưu ảnh. Hãy cấp quyền trong Cài đặt.',
      ExportOutcome.failed => 'Xuất ảnh thất bại, thử lại nhé',
      ExportOutcome.shared || ExportOutcome.none => null,
    };
    if (message == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExportCubit>();
    return BlocConsumer<ExportCubit, ExportState>(
      listenWhen: (a, b) => a.outcome != b.outcome,
      listener: (context, state) => _showOutcome(context, state.outcome),
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Xuất ảnh đội hình')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FittedBox(
                child: RepaintBoundary(
                  key: _boundaryKey,
                  child: LineupCardView(
                    card: state.card,
                    template: state.template,
                    headline: state.headline,
                    showSubstitutes: state.showSubstitutes,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                for (final t in ExportTemplate.values)
                  ChoiceChip(
                    label: Text(t.label),
                    selected: state.template == t,
                    onSelected: (_) => cubit.selectTemplate(t),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Thông tin trận (tuỳ chọn)',
                hintText: 'vs FC Phủi · 20:00 T7 · Sân Chảo Lửa',
              ),
              onChanged: cubit.setHeadline,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Hiện cầu thủ dự bị'),
              value: state.showSubstitutes,
              onChanged: cubit.toggleSubstitutes,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: state.busy ? null : () => cubit.save(_capture),
                    icon: const Icon(Icons.download),
                    label: const Text('Lưu ảnh'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: state.busy ? null : () => cubit.share(_capture),
                    icon: const Icon(Icons.share),
                    label: const Text('Chia sẻ'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
