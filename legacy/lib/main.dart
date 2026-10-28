import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/app.dart';
import 'package:marozi/resources/bloc_observer.dart';
import 'package:marozi/utils/firebase_to_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp();
  await FirebaseToLocal.splashDataLoading();
  runApp(MyApp());
}
