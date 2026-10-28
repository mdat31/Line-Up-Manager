import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/table/table_bloc/table_bloc.dart';

class GarbageCan extends StatefulWidget {
  @override
  _GarbageCanState createState() => _GarbageCanState();
}

class _GarbageCanState extends State<GarbageCan> {
  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onAccept: (data) {
        context.bloc<TableBloc>().add(PlayerDelete(data[0], data[1]));
      },
      onWillAccept: (data) {
        return true;
      },
      builder: (BuildContext context, List<List> candidateData,
          List<dynamic> rejectedData) {
        return Container(
          margin: EdgeInsets.fromLTRB(8, 5, 8, 5),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0),
                blurRadius: 3.0,
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/bin.png',
            fit: BoxFit.fill,
            color: Colors.orange,
            width: 26,
            height: 26,
          ),
        );
      },
    );
  }
}
