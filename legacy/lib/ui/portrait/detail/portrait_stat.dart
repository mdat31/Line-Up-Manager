import 'package:flutter/material.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/resources/custom_widgets/skill_chart.dart';
import 'package:marozi/ui/portrait/detail/custom_widget/text_fix.dart';
import 'package:marozi/ui/portrait/detail/custom_widget/text_info.dart';

class PortraitStat extends StatefulWidget {
  final Player player;

  PortraitStat(this.player);

  @override
  _PortraitStatState createState() => _PortraitStatState();
}

class _PortraitStatState extends State<PortraitStat> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  _field(),
                  _foot(),
                ],
              ),
              Divider(indent: 16, color: Colors.black12, endIndent: 16),
              Expanded(
                child: Row(
                  children: <Widget>[
                    _chart(),
                    _stat(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _foot() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Image.asset(
                  'assets/images/left_foot.png',
                  width: 30,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 3),
                Text(
                  '3',
                  style: TextStyle(fontSize: 17, color: Colors.black45),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/right_foot_colored.png',
                  width: 30,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 3),
                Text(
                  '5',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chart() {
    return Expanded(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 115,
              height: 115,
              child: MyChart(
                showData: false,
                data: [0, 0, 0, 0, 0],
                maxValue: 1,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 165,
              child: MyChart(
                data: [
                  double.parse(widget.player.ballSkill) ?? 0,
                  double.parse(widget.player.defence) ?? 0,
                  double.parse(widget.player.passing) ?? 0,
                  double.parse(widget.player.physical) ?? 0,
                  double.parse(widget.player.shooting) ?? 0,
                ],
                maxValue: 100,
                labels: [
                  'Ball Skill',
                  'Defence',
                  'Passing',
                  'Physical',
                  'Shooting',
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextFix('Overall'),
                TextInfo(widget.player.overall),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextFix('Potential'),
                TextInfo(widget.player.potential),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextFix('Skill Moves'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(Icons.star, color: Colors.orange),
                Icon(Icons.star, color: Colors.orange),
                Icon(Icons.star, color: Colors.orange),
                Icon(Icons.star_half, color: Colors.orange),
                Icon(Icons.star_border, color: Colors.orange),
              ],
            ),
            Align(alignment: Alignment.centerLeft, child: TextFix('Best Stat')),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextInfo('Slide Tackle'),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextInfo('90'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _field() {
    return Container(
      width: 200,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 30,
              height: 58,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    right: _borderSide(),
                    top: _borderSide(),
                    bottom: _borderSide(),
                  )),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 30,
              height: 58,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    left: _borderSide(),
                    top: _borderSide(),
                    bottom: _borderSide(),
                  )),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: VerticalDivider(
              color: Colors.black12,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Container(
              width: 100,
              height: 30,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 31.16,
                    height: 15.58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4.49),
                    ),
                    child: Text(
                      'RB',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  Container(
                    width: 31.16,
                    height: 15.58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4.49),
                    ),
                    child: Text(
                      'RWB',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BorderSide _borderSide() {
    return BorderSide(color: Colors.black12);
  }
}
