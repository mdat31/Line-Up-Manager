import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/adding/adding_bloc/adding_bloc.dart';
import 'package:marozi/bloc/adding/adding_players_bloc/adding_player_bloc.dart';
import 'package:marozi/bloc/adding/club_bloc/club_bloc.dart';
import 'package:marozi/bloc/adding/favorite_bloc/favorite_bloc.dart';
import 'package:marozi/bloc/adding/search_bloc/search_bloc.dart';
import 'package:marozi/bloc/adding/selected_players_bloc/selected_players_bloc.dart';
import 'package:marozi/bloc/detail/detail_bloc.dart';
import 'package:marozi/bloc/export/export_bloc.dart';
import 'package:marozi/bloc/position/position_bloc/position_bloc.dart';
import 'package:marozi/bloc/table/table_bloc/table_bloc.dart';
import 'package:marozi/resources/colors.dart';
import 'package:marozi/resources/fonts.dart';
import 'package:marozi/resources/strings.dart';
import 'package:marozi/ui/example/test.dart';
import 'package:marozi/ui/orientation/adding.dart';
import 'package:marozi/ui/orientation/detail.dart';
import 'package:marozi/ui/orientation/export.dart';
import 'package:marozi/ui/orientation/home_page.dart';
import 'package:marozi/ui/orientation/position.dart';
import 'package:marozi/ui/orientation/table.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TableBloc>(
          create: (BuildContext context) => TableBloc(TableInitial()),
        ),
        BlocProvider<AddingBloc>(
          create: (BuildContext context) => AddingBloc(AddingInitial()),
        ),
        BlocProvider<PositionBloc>(
            create: (BuildContext context) => PositionBloc(PositionInitial())
              ..add(PositionTestEvent(isPortrait: false))),
        BlocProvider<ExportBloc>(
          create: (BuildContext context) => ExportBloc(ExportInitial()),
        ),
        BlocProvider<DetailBloc>(
          create: (BuildContext context) => DetailBloc(DetailInitial()),
        ),
        BlocProvider<FavoriteBloc>(
          create: (BuildContext context) => FavoriteBloc(FavoriteInitial()),
        ),
        BlocProvider<SelectedPlayerBloc>(
          create: (BuildContext context) => SelectedPlayerBloc(PlayerInitial()),
        ),
        BlocProvider<ClubBloc>(
          create: (BuildContext context) => ClubBloc(ClubInitial()),
        ),
        BlocProvider<AddingPlayerBloc>(
          create: (BuildContext context) =>
              AddingPlayerBloc(AddingPlayerInitial()),
        ),
        BlocProvider<SearchBloc>(
          create: (BuildContext context) => SearchBloc(SearchInitial()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.orange,
          accentColor: Colors.orange,
          fontFamily: fontSFDisplayRegular,
          scaffoldBackgroundColor: colorScaffoldBackground,
        ),
        initialRoute: homepage,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/homepage':
              return CupertinoPageRoute(
                  builder: (BuildContext context) => HomePage());
              break;
            case '/position':
              return CupertinoPageRoute(
                  builder: (BuildContext context) => Position());
              break;
            case '/table':
              return CupertinoPageRoute(
                  builder: (BuildContext context) => PlayerTable());
              break;
            case '/adding':
              return CupertinoPageRoute(
                  builder: (BuildContext context) => Adding());
              break;
            case '/detail':
              return CupertinoPageRoute(
                  builder: (BuildContext context) => PlayerDetail());
              break;
            case '/export':
              return CupertinoPageRoute(
                  builder: (BuildContext context) => Export());
              break;
            case '/subscribe':
              return CupertinoPageRoute(
                  builder: (BuildContext context) => Test());
              break;
            case '/example':
              return CupertinoPageRoute(
                  builder: (BuildContext context) => Test());
              break;
            default:
              return CupertinoPageRoute(
                  builder: (BuildContext context) => HomePage());
              break;
          }
        },
      ),
    );
  }
}
