import 'package:lineup/src/features/team/domain/entities/player.dart';
import 'package:lineup/src/features/team/domain/entities/team.dart';

extension TeamFormatLabel on TeamFormat {
  String get label => switch (this) {
    TeamFormat.fiveASide => 'Sân 5',
    TeamFormat.sevenASide => 'Sân 7',
    TeamFormat.elevenASide => 'Sân 11',
  };
}

extension PlayerPositionLabel on PlayerPosition {
  String get label => switch (this) {
    PlayerPosition.goalkeeper => 'Thủ môn',
    PlayerPosition.defender => 'Hậu vệ',
    PlayerPosition.midfielder => 'Tiền vệ',
    PlayerPosition.forward => 'Tiền đạo',
  };

  String get short => switch (this) {
    PlayerPosition.goalkeeper => 'TM',
    PlayerPosition.defender => 'HV',
    PlayerPosition.midfielder => 'TV',
    PlayerPosition.forward => 'TĐ',
  };
}
