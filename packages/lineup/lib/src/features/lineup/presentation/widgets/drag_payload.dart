/// What is being dragged, so each drop target can tell a token on the pitch
/// from a substitute on the bench.
sealed class DragPayload {
  const DragPayload();
}

final class SlotDrag extends DragPayload {
  const SlotDrag(this.slot);

  final int slot;
}

final class BenchDrag extends DragPayload {
  const BenchDrag(this.playerId);

  final int playerId;
}
