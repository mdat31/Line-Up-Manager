import 'dart:io';
import 'dart:typed_data';

import 'package:gal/gal.dart';
import 'package:lineup/src/features/export/domain/repositories/image_exporter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Saves to the photo library via gal and shares through the OS sheet.
final class DeviceImageExporter implements ImageExporter {
  const DeviceImageExporter();

  @override
  Future<bool> saveToGallery(Uint8List png) async {
    if (!await Gal.hasAccess() && !await Gal.requestAccess()) return false;
    await Gal.putImageBytes(png, name: _fileStem());
    return true;
  }

  @override
  Future<void> share(Uint8List png, {String? text}) async {
    // Some share targets (Zalo, Messenger) only accept real files, not
    // in-memory data, so write to the temp dir first.
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, '${_fileStem()}.png'));
    await file.writeAsBytes(png, flush: true);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'image/png')],
        text: text,
      ),
    );
  }

  String _fileStem() => 'lineup_${DateTime.now().millisecondsSinceEpoch}';
}
