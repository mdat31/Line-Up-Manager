import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lineup/src/core/widgets/pitch_painter.dart';
import 'package:lineup/src/features/lineup/domain/entities/formation.dart';
import 'package:lineup/src/features/lineup/presentation/bloc/lineup_cubit.dart';
import 'package:lineup/src/features/lineup/presentation/bloc/lineup_state.dart';
import 'package:lineup/src/features/lineup/presentation/widgets/drag_payload.dart';
import 'package:lineup/src/features/lineup/presentation/widgets/player_token.dart';

/// Grabbing a token anywhere snaps its disc under the finger, so the drop
/// point read from [DragTargetDetails.offset] plus the anchor is exactly
/// where the finger lifted.
Offset tokenCentreAnchor(Draggable<Object> _, BuildContext _, Offset _) =>
    PlayerToken.anchor;

/// The pitch with one draggable token per slot.
///
/// Drop rules: token on token swaps players, token on grass moves the spot,
/// bench player on token replaces, bench player on grass takes the nearest
/// slot. Positions are normalised, so nothing depends on screen size.
class PitchBoard extends StatelessWidget {
  const PitchBoard({super.key, required this.state, required this.onTapSlot});

  final LineupReady state;
  final ValueChanged<int> onTapSlot;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return DragTarget<DragPayload>(
          onAcceptWithDetails: (details) =>
              _dropOnGrass(context, size, details),
          builder: (context, _, _) => DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
              ),
            ),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: CustomPaint(
                    painter: PitchPainter(lineColor: Colors.white54),
                  ),
                ),
                for (var i = 0; i < state.lineup.slots.length; i++)
                  _positioned(size, i),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _positioned(Size size, int slot) {
    final position = state.lineup.slots[slot].position;
    return AnimatedPositioned(
      key: ValueKey('slot-$slot'),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      left: position.x * size.width - PlayerToken.anchor.dx,
      top: position.y * size.height - PlayerToken.anchor.dy,
      child: _SlotToken(state: state, slot: slot, onTap: () => onTapSlot(slot)),
    );
  }

  void _dropOnGrass(
    BuildContext context,
    Size size,
    DragTargetDetails<DragPayload> details,
  ) {
    final box = context.findRenderObject()! as RenderBox;
    final anchor = box.globalToLocal(details.offset) + PlayerToken.anchor;
    final position = _keepTokenInside(anchor, size);
    final cubit = context.read<LineupCubit>();
    switch (details.data) {
      case SlotDrag(:final slot):
        cubit.moveSlot(slot, position);
      case BenchDrag(:final playerId):
        cubit.assignNearest(playerId, position);
    }
  }

  /// Clamp the anchor so the whole token, name included, stays on the pitch.
  SlotPosition _keepTokenInside(Offset anchor, Size size) {
    const a = PlayerToken.anchor;
    final below = PlayerToken.height - a.dy;
    final x = anchor.dx.clamp(a.dx, size.width - a.dx) / size.width;
    final y = anchor.dy.clamp(a.dy, size.height - below) / size.height;
    return SlotPosition(x, y);
  }
}

class _SlotToken extends StatelessWidget {
  const _SlotToken({
    required this.state,
    required this.slot,
    required this.onTap,
  });

  final LineupReady state;
  final int slot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final player = state.playerAt(slot);
    final isCaptain = player != null && player.id == state.lineup.captainId;
    return DragTarget<DragPayload>(
      // Rejecting itself lets the drop fall through to the grass target,
      // which turns a short drag into a move.
      onWillAcceptWithDetails: (d) =>
          d.data is! SlotDrag || (d.data as SlotDrag).slot != slot,
      onAcceptWithDetails: (details) {
        final cubit = context.read<LineupCubit>();
        switch (details.data) {
          case SlotDrag(slot: final from):
            cubit.swapSlots(from, slot);
          case BenchDrag(:final playerId):
            cubit.assign(slot, playerId);
        }
      },
      builder: (context, candidates, _) {
        final token = PlayerToken(
          player: player,
          isCaptain: isCaptain,
          highlighted: candidates.isNotEmpty,
        );
        return Draggable<DragPayload>(
          data: SlotDrag(slot),
          dragAnchorStrategy: tokenCentreAnchor,
          feedback: Material(
            type: MaterialType.transparency,
            child: PlayerToken(player: player, isCaptain: isCaptain),
          ),
          childWhenDragging: Opacity(opacity: 0.3, child: token),
          child: GestureDetector(onTap: onTap, child: token),
        );
      },
    );
  }
}
