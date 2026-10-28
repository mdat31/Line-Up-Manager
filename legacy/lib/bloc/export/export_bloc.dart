import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:marozi/data/constants.dart';
import 'package:marozi/model/club/club.dart';
import 'package:marozi/model/club/club_repository.dart';
import 'package:marozi/model/player/player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'export_event.dart';
part 'export_state.dart';

class ExportBloc extends Bloc<ExportEvent, ExportState> {
  ExportBloc(ExportState initialState) : super(initialState);

  @override
  Stream<ExportState> mapEventToState(ExportEvent event) async* {
    if (event is PositionToExport) yield* _mapPositionToExport(event);

    if (event is SelectType) yield* _mapSelectTypeToState(event);

    if (event is ExportSettingDialog)
      yield* _mapExportSettingDialogToState(event);

    if (event is SettingCaptainSelect)
      yield* _mapSettingCaptainSelectToState(event);

    if (event is RenderPreviewByte) yield* _mapRenderPreviewByteToState(event);
  }

  Stream<ExportState> _mapRenderPreviewByteToState(
      RenderPreviewByte event) async* {
    var currentState = state;
    if (currentState is ExportFromPositionSuccess) {
      switch (event.i) {
        case 1:
          yield currentState.copyWith(
              path: await _saveToCameraRoll(await _exportPng(event.boundary)));
          break;
        case 2:
          yield currentState.copyWith(
              path: await _shareToFacebook(await _exportPng(event.boundary)));
          break;
        case 3:
          yield currentState.copyWith(
              path: await _shareToInsta(await _exportPng(event.boundary)));
          break;
        case 4:
          yield currentState.copyWith(
              path: await _shareToTwitter(await _exportPng(event.boundary)));
          break;
      }
    }
  }

  Stream<ExportState> _mapSettingCaptainSelectToState(
      SettingCaptainSelect event) async* {
    Player captain;
    var currentState = state;
    if (currentState is ExportFromPositionSuccess) {
      currentState.players.forEach((player) {
        if (player.name.contains(event.captainName)) captain = player;
      });
      yield currentState.copyWith(captain: captain ?? Player());
    }
  }

  Stream<ExportState> _mapExportSettingDialogToState(
      ExportSettingDialog event) async* {
    var currentState = state;
    if (currentState is ExportFromPositionSuccess) {
      yield currentState.copyWith(
        coachName: event.coachName,
        teamName: event.teamName,
        showSubs: event.showSubs,
        showCoach: event.showCoach,
        showCaptain: event.showCaptain,
        captain: event.captain,
      );
    }
  }

  Stream<ExportState> _mapSelectTypeToState(SelectType event) async* {
    var currentState = state;
    if (currentState is ExportFromPositionSuccess) {
      yield currentState.copyWith(currentPage: event.select);
    }
  }

  Stream<ExportState> _mapPositionToExport(PositionToExport event) async* {
    final clubRepo = ClubRepository();

    String _clubUrl = await clubRepo
        .getAColOfClub(clubId: event.players[0].clubId, columns: [clubLogoUrl]);
    String _clubName = await clubRepo
        .getAColOfClub(clubId: event.players[0].clubId, columns: [clubName]);

    double width =
        event.isPortrait ? Constants.width * 0.95 : Constants.width * 0.56;
    double height =
        event.isPortrait ? Constants.height * 0.66 : Constants.height * 0.92;

    List<Offset> offsets = _convertToExportOffset(
      position: event.offsets,
      width: width,
      height: height,
    );

    List<String> subNames = [];
    if (event.subs != null) {
      event.subs.forEach((player) {
        subNames.add(player.name);
      });
    }

    yield ExportFromPositionSuccess(
      players: event.players,
      offsets: offsets,
      exportTypes: Constants.listExport,
      currentPage: 0,
      clubLogoUrl: _clubUrl,
      teamName: _clubName,
      subsNames: subNames,
      showCaptain: true,
      showCoach: true,
      showSubs: true,
      captain: event.players[0],
    );
  }

  List<Offset> _convertToExportOffset(
      {@required List<Offset> position,
      @required double width,
      @required double height}) {
    List<Offset> result = [];

    for (int i = 0; i < position.length; i++) {
      double dx;
      double dy;

      dx = position[i].dx / Constants.width * width + 5;
      dy = position[i].dy / Constants.height * height;

      result.add(Offset(dx, dy));
    }

    return result;
  }

  Future<String> _saveToCameraRoll(Uint8List pngByte) async {
    Permission permission = Permission.storage;
    final status = await permission.request();
    if (status.isGranted) {
      String tempDir = (await getTemporaryDirectory()).path;
      File file = File('$tempDir/export.png');
      file.writeAsBytesSync(pngByte);
      final path = await ImageGallerySaver.saveFile(file.path);
      return path;
    } else {
      permission.request();
      return '';
    }
  }

  Future<String> _shareToFacebook(Uint8List pngByte) async {
    String tempDir = (await getTemporaryDirectory()).path;
    File file = File('$tempDir/export.png');
    file.writeAsBytesSync(pngByte);
    await Share.file('position image', 'export.png', pngByte, 'image/png',
        text: 'Checkout my cool formation!');
    return 'share done';
  }

  Future<String> _shareToInsta(Uint8List pngByte) async {
    String tempDir = (await getTemporaryDirectory()).path;
    File file = File('$tempDir/export.png');
    file.writeAsBytesSync(pngByte);
    await Share.file('position image', 'export.png', pngByte, 'image/png',
        text: 'Checkout my cool formation!');
    return 'share done';
  }

  Future<String> _shareToTwitter(Uint8List pngByte) async {
    String tempDir = (await getTemporaryDirectory()).path;
    File file = File('$tempDir/export.png');
    file.writeAsBytesSync(pngByte);
    await Share.file('position image', 'export.png', pngByte, 'image/png',
        text: 'Checkout my cool formation!');
    return 'share done';
  }

  // ignore: missing_return
  Future<Uint8List> _exportPng(RenderRepaintBoundary boundary) async {
    try {
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      // var bs64 = base64Encode(pngBytes);
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }
}
