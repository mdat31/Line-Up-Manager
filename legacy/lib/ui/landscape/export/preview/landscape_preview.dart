import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/export/export_bloc.dart';
import 'package:marozi/ui/landscape/export/preview/blue_n_white/landscape_blue_n_white.dart';
import 'package:marozi/ui/landscape/export/preview/field/field_xi.dart';
import 'package:marozi/ui/landscape/export/preview/glory_blue/glory_blue.dart';

class LandscapePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.82,
      height: MediaQuery.of(context).size.height * 0.75,
      alignment: Alignment.center,
      child: BlocBuilder<ExportBloc, ExportState>(
        builder: (BuildContext context, ExportState state) {
          if (state is ExportFromPositionSuccess) {
            switch (state.currentPage) {
              case 0:
                return PreviewGloryBlue();
                break;
              case 1:
                return LandscapeBlueAndWhite();
                break;
              case 2:
                return PreviewFieldXI();
                break;
              default:
                return PreviewGloryBlue();
            }
          }
          return Container();
        },
      ),
    );
  }
}
