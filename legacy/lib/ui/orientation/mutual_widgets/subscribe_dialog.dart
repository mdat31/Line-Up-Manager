import 'package:flutter/material.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';
import 'package:marozi/resources/fonts.dart';

class SubscribeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Container(
        width: isLandscape ? MediaQuery.of(context).size.width * 0.55 : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Get access to',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: fontSFDisplayRegular,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.check_circle,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            'Every leagues, competitors over the world',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: fontSFDisplayRegular,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.check_circle,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            ' Every teams, clubs or players with faces, kits.',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontFamily: fontSFDisplayRegular,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.check_circle,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            'All style export',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontFamily: fontSFDisplayRegular,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.check_circle,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            'Applied on all of our application',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontFamily: fontSFDisplayRegular,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _buttonOk(context, isLandscape),
          ],
        ),
      ),
    );
  }

  Widget _buttonOk(BuildContext context, bool isLandscape) {
    return Container(
      width: isLandscape
          ? MediaQuery.of(context).size.width * 0.55 - 8
          : MediaQuery.of(context).size.width * 0.8 - 15,
      child: RaisedButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () {
          Navigator.of(context).pop();
        },
        color: Colors.deepOrangeAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: MyText(
          text: 'Subscribe for 1.99\$ / month',
          color: Colors.white,
          fontSize: 17,
          isTitleCase: false,
        ),
      ),
    );
  }
}
