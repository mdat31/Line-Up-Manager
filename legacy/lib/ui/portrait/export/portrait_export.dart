import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/export/export_bloc.dart';
import 'package:marozi/data/constants.dart';
import 'package:marozi/resources/colors.dart';
import 'package:marozi/resources/custom_widgets/export_button.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';
import 'package:marozi/ui/orientation/dialog_setting.dart';
import 'package:marozi/ui/portrait/export/preview/portrait_preview.dart';

class PortraitExport extends StatefulWidget {
  @override
  _PortraitExportState createState() => _PortraitExportState();
}

class _PortraitExportState extends State<PortraitExport> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorPlayerBackground,
      body: SafeArea(
        top: true,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: <Widget>[
              _topBar(),
              _center(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: MyText(
                  text: 'Style',
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
              _bottom(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.orange),
          ),
          MyText(
            text: 'Export',
            color: Colors.black,
            fontSize: 19,
          ),
          ExportDialog(_globalKey),
        ],
      ),
    );
  }

  Widget _center() {
    return Expanded(
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.742,
              child: RepaintBoundary(
                key: _globalKey,
                child: PortraitPreview(),
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(11, 3, 11, 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '1.99',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 17,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text(
                          '\$',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      text: '1',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 17,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '\\15',
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => DialogSetting());
                    },
                    child: Icon(
                      Icons.settings,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottom() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.083,
      child: Card(
        child: BlocBuilder<ExportBloc, ExportState>(
          builder: (BuildContext context, ExportState state) {
            return ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: Constants.listExport.length,
              itemBuilder: (context, index) {
                if (state is ExportFromPositionSuccess) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(3.0),
                    onTap: () {
                      context.bloc<ExportBloc>().add(SelectType(index));
                    },
                    child: Container(
                      width: 90,
                      alignment: Alignment.center,
                      child: Text(
                        state.exportTypes[index],
                        style: TextStyle(
                          fontSize: 17,
                          color: state.currentPage == index
                              ? Colors.deepOrangeAccent
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
              separatorBuilder: (BuildContext context, int index) {
                return VerticalDivider(
                  color: Colors.black,
                  thickness: 0.2,
                  indent: 12,
                  width: 1,
                  endIndent: 12,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ExportToImage extends StatelessWidget {
  final Uint8List pngBytes;

  ExportToImage(this.pngBytes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.memory(pngBytes),
      ),
    );
  }
}
