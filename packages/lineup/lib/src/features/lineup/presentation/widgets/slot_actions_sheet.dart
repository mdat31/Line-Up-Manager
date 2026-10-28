import 'package:flutter/material.dart';
import 'package:lineup/src/features/lineup/presentation/bloc/lineup_cubit.dart';
import 'package:lineup/src/features/lineup/presentation/bloc/lineup_state.dart';
import 'package:lineup/src/features/team/presentation/team_labels.dart';

/// Tap alternative to dragging: pick who plays here, captain, or bench.
Future<void> showSlotActions(
  BuildContext context, {
  required LineupCubit cubit,
  required LineupReady state,
  required int slot,
}) {
  final current = state.playerAt(slot);
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
      void run(Future<void> Function() action) {
        Navigator.of(sheetContext).pop();
        action();
      }

      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.7,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              if (current != null) ...[
                ListTile(
                  leading: const Icon(Icons.copyright),
                  title: Text(
                    current.id == state.lineup.captainId
                        ? 'Bỏ băng đội trưởng'
                        : 'Đặt ${current.shortName} làm đội trưởng',
                  ),
                  onTap: () => run(
                    () => cubit.setCaptain(
                      current.id == state.lineup.captainId ? null : current.id,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.event_seat_outlined),
                  title: Text('Đưa ${current.shortName} ra dự bị'),
                  onTap: () => run(() => cubit.sendToBench(slot)),
                ),
                const Divider(),
              ],
              for (final p in state.players)
                if (p.id != current?.id)
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(p.number?.toString() ?? '-'),
                    ),
                    title: Text(p.name),
                    subtitle: Text(
                      state.lineup.starterIds.contains(p.id)
                          ? '${p.position.label} · đang đá chính (đổi chỗ)'
                          : '${p.position.label} · dự bị',
                    ),
                    onTap: () => run(() => cubit.assign(slot, p.id!)),
                  ),
            ],
          ),
        ),
      );
    },
  );
}
