import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/export/export_bloc.dart';
import 'package:marozi/resources/colors.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';

class LandscapeDialogSetting extends StatefulWidget {
  @override
  _LandscapeDialogSettingState createState() => _LandscapeDialogSettingState();
}

class _LandscapeDialogSettingState extends State<LandscapeDialogSetting> {
  bool ovrSelected = false;
  bool potentialSelected = false;
  bool numbSelected = false;

  TextEditingController _coachName = TextEditingController();
  TextEditingController _teamName = TextEditingController();

  @override
  void dispose() {
    _coachName.dispose();
    _teamName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.transparent,
          child: _dialogContent(context),
        ),
      ],
    );
  }

  Widget _dialogContent(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.66,
      height: MediaQuery.of(context).size.height * 0.82,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _column1(),
                          _column2(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: _rowOvr(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 4),
          _okBtn(),
        ],
      ),
    );
  }

  Widget _column1() {
    return BlocBuilder<ExportBloc, ExportState>(
      builder: (BuildContext context, ExportState state) {
        if (state is ExportFromPositionSuccess) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: MyText(
                        text: 'Show coach',
                        color: Colors.black,
                        textAlign: TextAlign.start,
                        fontSize: 16,
                      ),
                    ),
                    Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (bool value) {
                        context
                            .bloc<ExportBloc>()
                            .add(ExportSettingDialog(showCoach: value));
                      },
                      value: state.showCoach,
                      activeColor: Colors.deepOrangeAccent,
                    ),
                  ],
                ),
                _textField('Coach name', _coachName),
                Container(
                  width: MediaQuery.of(context).size.width * 0.28,
                  child: Divider(
                    height: 0,
                    thickness: 0.6,
                  ),
                ),
                _textField('Team name', _teamName),
              ],
            ),
          );
        }
        return BottomLoader();
      },
    );
  }

  Widget _column2() {
    return BlocBuilder<ExportBloc, ExportState>(
      builder: (BuildContext context, ExportState state) {
        if (state is ExportFromPositionSuccess) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    MyText(
                      text: 'Show captain',
                      color: Colors.black,
                      fontSize: 16,
                      textAlign: TextAlign.start,
                    ),
                    Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (bool value) {
                        context
                            .bloc<ExportBloc>()
                            .add(ExportSettingDialog(showCaptain: value));
                      },
                      value: state.showCaptain,
                      activeColor: Colors.deepOrangeAccent,
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  child: DropdownButton(
                    value: state.captain.name,
                    underline: Container(),
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.orange,
                    ),
                    isDense: true,
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    selectedItemBuilder: (context) => state.players
                        .map(
                          (player) => Text(
                            player.name,
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 15,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      context
                          .bloc<ExportBloc>()
                          .add(SettingCaptainSelect(value));
                    },
                    items: state.players
                        .map<DropdownMenuItem<String>>(
                          (player) => DropdownMenuItem<String>(
                            value: player.name,
                            child: Text(
                              player.name,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.28,
                  child: Divider(
                    height: 0,
                    thickness: 0.6,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MyText(
                      text: 'Show subs\.',
                      color: Colors.black,
                      fontSize: 16,
                      isTitleCase: false,
                    ),
                    Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (bool value) {
                        context
                            .bloc<ExportBloc>()
                            .add(ExportSettingDialog(showSubs: value));
                      },
                      value: state.showSubs,
                      activeColor: Colors.deepOrangeAccent,
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return BottomLoader();
      },
    );
  }

  Widget _rowOvr() {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  ovrSelected = !ovrSelected;
                  potentialSelected = false;
                  numbSelected = false;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        ovrSelected ? Colors.deepOrangeAccent : Colors.black54,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  color: ovrSelected ? Colors.deepOrangeAccent : Colors.white,
                ),
                child: MyText(
                  text: 'Overall',
                  color: ovrSelected ? Colors.white : Colors.black45,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  potentialSelected = !potentialSelected;
                  ovrSelected = false;
                  numbSelected = false;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: potentialSelected
                            ? Colors.deepOrangeAccent
                            : Colors.black54),
                    bottom: BorderSide(
                        color: potentialSelected
                            ? Colors.deepOrangeAccent
                            : Colors.black54),
                  ),
                  color: potentialSelected
                      ? Colors.deepOrangeAccent
                      : Colors.white,
                ),
                child: MyText(
                  text: 'Potential',
                  color: potentialSelected ? Colors.white : Colors.black45,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  numbSelected = !numbSelected;
                  ovrSelected = false;
                  potentialSelected = false;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: numbSelected
                          ? Colors.deepOrangeAccent
                          : Colors.black54),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  color: numbSelected ? Colors.deepOrangeAccent : Colors.white,
                ),
                child: MyText(
                  text: 'Number',
                  color: numbSelected ? Colors.white : Colors.black45,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _okBtn() {
    return RaisedButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        context.bloc<ExportBloc>().add(
              ExportSettingDialog(
                coachName: _coachName.text,
                teamName: _teamName.text,
              ),
            );
        Navigator.of(context).pop();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width * 0.66 - 8,
        padding: EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              HexColor('FF6C01'),
              HexColor('FE9040'),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.deepOrangeAccent,
        ),
        alignment: Alignment.center,
        child: MyText(
          text: 'OK',
          isTitleCase: false,
          color: Colors.white,
          fontSize: 19,
        ),
      ),
    );
  }

  Widget _textField(String hint, TextEditingController controller) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: colorScaffoldBackground,
      ),
      alignment: Alignment.center,
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: controller,
        maxLines: 1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          isDense: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.black38,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
