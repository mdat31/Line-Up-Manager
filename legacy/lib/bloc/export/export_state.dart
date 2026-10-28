part of 'export_bloc.dart';

class ExportState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ExportInitial extends ExportState {}

class ExportFromPositionSuccess extends ExportState {
  final List<Player> players;
  final List<String> subsNames;
  final List<Offset> offsets;
  final List<String> exportTypes;
  final int currentPage;
  final String clubLogoUrl;
  final String teamName;
  final Player captain;
  final String coachName;
  final bool showCoach;
  final bool showSubs;
  final bool showCaptain;
  final String path;

  ExportFromPositionSuccess({
    this.players,
    this.subsNames,
    this.offsets,
    this.exportTypes,
    this.currentPage,
    this.clubLogoUrl,
    this.teamName,
    this.captain,
    this.path,
    this.coachName,
    this.showCoach,
    this.showSubs,
    this.showCaptain,
  });

  ExportFromPositionSuccess copyWith({
    List<Offset> offsets,
    List<String> subsNames,
    List<Player> players,
    List<String> exportTypes,
    int currentPage,
    String clubLogoUrl,
    String teamName,
    Player captain,
    String coachName,
    bool showCoach,
    bool showSubs,
    bool showCaptain,
    String path,
  }) {
    return ExportFromPositionSuccess(
      offsets: offsets ?? this.offsets,
      players: players ?? this.players,
      currentPage: currentPage ?? this.currentPage,
      exportTypes: exportTypes ?? this.exportTypes,
      clubLogoUrl: clubLogoUrl ?? this.clubLogoUrl,
      teamName: teamName ?? this.teamName,
      subsNames: subsNames ?? this.subsNames,
      coachName: coachName ?? this.coachName,
      showSubs: showSubs ?? this.showSubs,
      showCoach: showCoach ?? this.showCoach,
      showCaptain: showCaptain ?? this.showCaptain,
      captain: captain ?? this.captain,
      path: path ?? this.path,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [
        offsets,
        players,
        currentPage,
        exportTypes,
        clubLogoUrl,
        teamName,
        captain,
        subsNames,
        coachName,
        showCoach,
        showSubs,
        showCaptain,
        path,
      ];
}
