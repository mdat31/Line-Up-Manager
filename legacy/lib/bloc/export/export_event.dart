part of 'export_bloc.dart';

class ExportEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PositionToExport extends ExportEvent {
  final List<Player> players;
  final List<Player> subs;
  final List<Offset> offsets;
  final bool isPortrait;

  PositionToExport(this.players, this.subs, this.offsets, this.isPortrait);

  @override
  // TODO: implement props
  List<Object> get props => [players, offsets, isPortrait, subs];
}

class SelectType extends ExportEvent {
  final int select;

  SelectType(this.select);

  @override
  // TODO: implement props
  List<Object> get props => [select];
}

class ExportSettingDialog extends ExportEvent {
  final String coachName;
  final String teamName;
  final Player captain;
  final bool showCoach;
  final bool showCaptain;
  final bool showSubs;

  ExportSettingDialog({
    this.coachName,
    this.teamName,
    this.captain,
    this.showCoach,
    this.showCaptain,
    this.showSubs,
  });

  @override
  // TODO: implement props
  List<Object> get props => [
        coachName,
        teamName,
        captain,
        showSubs,
        showCaptain,
        showCoach,
      ];
}

class SettingCaptainSelect extends ExportEvent {
  final String captainName;

  SettingCaptainSelect(this.captainName);

  @override
  // TODO: implement props
  List<Object> get props => [captainName];
}

class RenderPreviewByte extends ExportEvent {
  final RenderRepaintBoundary boundary;
  final int i;

  RenderPreviewByte(this.boundary, this.i);

  @override
  // TODO: implement props
  List<Object> get props => [boundary, i];
}
