import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lineup/src/features/lineup/presentation/bloc/lineup_cubit.dart';
import 'package:lineup/src/features/lineup/presentation/widgets/drag_payload.dart';
import 'package:lineup/src/features/lineup/presentation/widgets/pitch_board.dart';
import 'package:lineup/src/features/lineup/presentation/widgets/player_token.dart';
import 'package:lineup/src/features/team/domain/entities/player.dart';

/// Substitutes strip. Drag a sub onto the pitch to bring them on; drag a
/// starter here to take them off.
class BenchBar extends StatelessWidget {
  const BenchBar({super.key, required this.bench});

  final List<Player> bench;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DragTarget<DragPayload>(
      onWillAcceptWithDetails: (d) => d.data is SlotDrag,
      onAcceptWithDetails: (d) =>
          context.read<LineupCubit>().sendToBench((d.data as SlotDrag).slot),
      builder: (context, candidates, _) => AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: PlayerToken.height + 32,
        decoration: BoxDecoration(
          color: const Color(0xFF263238),
          border: Border(
            top: BorderSide(
              color: candidates.isNotEmpty
                  ? scheme.primary
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
              child: Text(
                bench.isEmpty
                    ? 'DỰ BỊ · kéo cầu thủ vào đây để rút ra'
                    : 'DỰ BỊ (${bench.length})',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: bench.length,
                itemBuilder: (context, i) => _BenchToken(player: bench[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenchToken extends StatelessWidget {
  const _BenchToken({required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final token = PlayerToken(player: player);
    return Draggable<DragPayload>(
      data: BenchDrag(player.id!),
      dragAnchorStrategy: tokenCentreAnchor,
      feedback: Material(type: MaterialType.transparency, child: token),
      childWhenDragging: Opacity(opacity: 0.3, child: token),
      child: token,
    );
  }
}
