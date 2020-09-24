import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/utils/unit_converter.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PressurePage extends StatelessWidget {
  static const String routeName = "/PressurePage";

  @override
  Widget build(BuildContext context) {
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: CustomAppBar(title: 'Pressure')),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    title: Text('Millibar (mbar)'),
                    onTap: () async => await bloc
                        .savePressure(unit: PressureUnit.MBAR)
                        .then((value) => Navigator.of(context).pop()),
                  ),
                  ListTile(
                    title: Text('Pascal (Pa)'),
                    onTap: () async => await bloc
                        .savePressure(unit: PressureUnit.PA)
                        .then((value) => Navigator.of(context).pop()),
                  ),
                  ListTile(
                    title: Text('Pound-force per square inch (PSI)'),
                    onTap: () async => await bloc
                        .savePressure(unit: PressureUnit.PSI)
                        .then((value) => Navigator.of(context).pop()),
                  ),
                ],
              ).toList(),
            ),
          )
        ],
      ),
    );
  }
}
