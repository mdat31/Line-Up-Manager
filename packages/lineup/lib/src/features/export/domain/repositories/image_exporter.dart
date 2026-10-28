import 'dart:typed_data';

/// Where a rendered line-up image can go.
abstract interface class ImageExporter {
  /// Returns false when the user denied photo access.
  Future<bool> saveToGallery(Uint8List png);

  Future<void> share(Uint8List png, {String? text});
}
