import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/export/export_bloc.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/custom_widgets/export_button.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';
import 'package:marozi/resources/fonts.dart';
import 'package:marozi/ui/landscape/export/preview/landscape_preview.dart';
import 'package:marozi/ui/orientation/dialog_setting.dart';

class LandscapeExport extends StatefulWidget {
  @override
  _LandscapeExportState createState() => _LandscapeExportState();
}

class _LandscapeExportState extends State<LandscapeExport> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: true,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: <Widget>[
                _topBar(),
                _center(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.arrow_back_ios, color: Colors.orange),
          ),
          Text(
            'Export',
            style: TextStyle(fontSize: 20, fontFamily: fontSFDisplayRegular),
          ),
          ExportDialog(_globalKey),
        ],
      ),
    );
  }

  Widget _center() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        child: Row(
          children: <Widget>[
            Card(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.65,
                height: double.infinity,
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: RepaintBoundary(
                      key: _globalKey,
                      child: LandscapePreview(),
                    )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Divider(indent: 10, endIndent: 10, height: 0),
                        _settingBar(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _mostRight(),
          ],
        ),
      ),
    );
  }

  Widget _settingBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 2, 13, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MyText(
                text: '1.19',
                color: Colors.orange,
                fontSize: 16,
                isTitleCase: false,
              ),
              MyText(
                isTitleCase: false,
                text: '\$',
                color: Colors.orange,
                fontSize: 12,
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              text: '1',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: '\\15',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context, builder: (context) => DialogSetting());
            },
            child: Icon(
              Icons.settings,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mostRight() {
    return Expanded(
      child: Card(
        child: BlocBuilder<ExportBloc, ExportState>(
          builder: (BuildContext context, ExportState state) {
            if (state is ExportFromPositionSuccess) {
              return ListView.separated(
                itemCount: state.exportTypes.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        borderRadius: BorderRadius.circular(3.0),
                        onTap: () {
                          context.bloc<ExportBloc>().add(SelectType(index));
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                          child: Text(
                            state.exportTypes[index],
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 17,
                              color: state.currentPage == index
                                  ? Colors.deepOrangeAccent
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    width: double.infinity,
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.15,
                      height: 0,
                      indent: 12,
                      endIndent: 12,
                    ),
                  );
                },
              );
            }
            return BottomLoader();
          },
        ),
      ),
    );
  }
}
