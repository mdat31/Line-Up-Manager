import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/export/export_bloc.dart';
import 'package:marozi/resources/custom_icons/custom_icon_icons.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';

class ExportDialog extends StatefulWidget {
  final GlobalKey globalKey;

  ExportDialog(this.globalKey);

  @override
  _ExportDialogState createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => _export());
      },
      child: Icon(CustomIcon.export_icon, color: Colors.orange),
    );
  }

  Widget _export() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _typeExport(),
          _cancel(),
        ],
      ),
    );
  }

  Widget _typeExport() {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: isLandscape ? width * 0.43 : width,
        height: isLandscape ? height * 0.57 : height * 0.33,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        color: Colors.white,
        child: BlocBuilder<ExportBloc, ExportState>(
          builder: (BuildContext context, ExportState state) {
            if (state is ExportFromPositionSuccess) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        print('Save to camera roll');
                        context.bloc<ExportBloc>().add(
                              RenderPreviewByte(
                                widget.globalKey.currentContext
                                    .findRenderObject(),
                                1,
                              ),
                            );
                        Scaffold.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            content: Text('Exported to Gallery'),
                          ));
                        Navigator.of(context).pop();
                      },
                      child:
                          _type(icon: Icons.image, text: 'Save to camera roll'),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        print('Facebook');
                        context.bloc<ExportBloc>().add(
                              RenderPreviewByte(
                                widget.globalKey.currentContext
                                    .findRenderObject(),
                                2,
                              ),
                            );
                        Navigator.of(context).pop();
                      },
                      child: _type(icon: CustomIcon.facebook, text: 'Facebook'),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        print('Instagram');
                        context.bloc<ExportBloc>().add(
                              RenderPreviewByte(
                                widget.globalKey.currentContext
                                    .findRenderObject(),
                                3,
                              ),
                            );
                        Navigator.of(context).pop();
                      },
                      child:
                          _type(icon: CustomIcon.instagram, text: 'Instagram'),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        print('Twitter');
                        context.bloc<ExportBloc>().add(
                              RenderPreviewByte(
                                widget.globalKey.currentContext
                                    .findRenderObject(),
                                4,
                              ),
                            );
                        Navigator.of(context).pop();
                      },
                      child: _type(icon: CustomIcon.twitter, text: 'Twitter'),
                    ),
                  ),
                ],
              );
            }
            return BottomLoader();
          },
        ),
      ),
    );
  }

  Widget _cancel() {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: isLandscape ? width * 0.43 : width,
      height: 53,
      padding: EdgeInsets.only(top: 6),
      child: InkWell(
        child: RaisedButton(
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: MyText(
            text: 'Cancel',
            color: Colors.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _type({IconData icon, String text}) {
    return Row(
      children: <Widget>[
        Icon(icon, color: Colors.orange),
        SizedBox(width: 15),
        MyText(
          text: text,
          color: Colors.black,
          fontSize: 17,
          isTitleCase: false,
        ),
      ],
    );
  }
}
