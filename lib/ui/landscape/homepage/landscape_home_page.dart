import 'package:flutter/material.dart';
import 'package:marozi/resources/colors.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';
import 'package:marozi/ui/orientation/table.dart';

class LandscapeHomePage extends StatefulWidget {
  @override
  _ModeLandscapeState createState() => _ModeLandscapeState();
}

class _ModeLandscapeState extends State<LandscapeHomePage> {
  PageController _pageController = PageController(
    viewportFraction: 0.85,
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        left: true,
        right: true,
        child: Center(
          child: Column(
            children: <Widget>[
              MyText(
                text: 'Select mode',
                color: Colors.black,
                fontSize: 19,
              ),
              _center(),
              _goBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _center() {
    return Expanded(
      child: PageView(
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        pageSnapping: true,
        onPageChanged: (bool) {
//            SystemChrome.setPreferredOrientations([
//              DeviceOrientation.portraitUp,
//              DeviceOrientation.portraitDown,
//            ]);
        },
        children: <Widget>[
          Card(child: _landscapeMode()),
          Card(child: _portraitMode()),
        ],
      ),
    );
  }

  Widget _landscapeMode() {
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => PlayerTable()));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
              child: Image.asset(
                'assets/images/landscape.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: MyText(
                  text: 'Landscape',
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
              Flexible(
                child: MyText(
                  text: 'Mode',
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _portraitMode() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Image.asset(
            'assets/images/portrait.png',
            alignment: Alignment.center,
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Divider(
              color: Colors.black,
              indent: 10,
              thickness: 0.1,
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: MyText(
                text: 'Portrait Mode',
                color: Colors.black,
                fontSize: 19,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _goBtn() {
    return RaisedButton(
      padding: EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => PlayerTable()));
      },
      child: Container(
        alignment: Alignment.center,
        height: 40,
        width: MediaQuery.of(context).size.width * 0.85 - 8,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              HexColor('FF7008'),
              HexColor('FF964A'),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: MyText(
          text: 'Go',
          color: Colors.white,
          fontSize: 19,
        ),
      ),
    );
  }
}
