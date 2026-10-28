import 'package:flutter/material.dart';
import 'package:lineup/src/features/team/domain/entities/player.dart';

/// Shirt-number disc with the short name underneath. An empty slot (no
/// [player]) renders as a dashed-looking outline with a plus.
class PlayerToken extends StatelessWidget {
  const PlayerToken({
    super.key,
    this.player,
    this.isCaptain = false,
    this.highlighted = false,
  });

  static const width = 76.0;
  static const height = 68.0;
  static const _disc = 42.0;

  /// Centre of the shirt disc inside the token. This, not the box centre,
  /// is what users aim with, so it is the point that maps to a slot spot.
  static const anchor = Offset(width / 2, _disc / 2);

  final Player? player;
  final bool isCaptain;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final player = this.player;
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: _disc,
                height: _disc,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: player == null ? Colors.white24 : Colors.white,
                  border: Border.all(
                    color: highlighted ? scheme.primary : Colors.white,
                    width: highlighted ? 3 : 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 4),
                  ],
                ),
                child: player == null
                    ? const Icon(Icons.add, color: Colors.white)
                    : Text(
                        player.number?.toString() ?? '•',
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
              ),
              if (isCaptain)
                const Positioned(right: -6, top: -4, child: _CaptainBadge()),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            player?.shortName ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              shadows: [Shadow(color: Colors.black54, blurRadius: 3)],
            ),
          ),
        ],
      ),
    );
  }
}

class _CaptainBadge extends StatelessWidget {
  const _CaptainBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFFFEB3B),
        shape: BoxShape.circle,
      ),
      child: const Text(
        'C',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
    );
  }
}
