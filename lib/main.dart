import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:marozi/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initFirebase();
  runApp(const MaroziApp());
}

// The app must stay usable offline and on platforms without Firebase config
// (iOS has no GoogleService-Info.plist yet), so init failure is not fatal.
Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp();
  } on Object catch (e) {
    if (kDebugMode) debugPrint('Firebase init skipped: $e');
  }
}
