import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class LoadImageService extends ChangeNotifier {
  LoadImageService();

  static Future<dynamic> loadImage(BuildContext context, String gsUrl) async {
    return gsUrl != null
        ? await FirebaseStorage.instance
            .getReferenceFromUrl(gsUrl)
            .then((value) => value.getDownloadURL())
        : '';
  }
}
