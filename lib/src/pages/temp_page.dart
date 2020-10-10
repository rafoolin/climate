import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/utils/unit_converter.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TempPage extends StatelessWidget {
  static const String routeName = "/TempPage";
  const TempPage();
  @override
  Widget build(BuildContext context) {
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: const CustomAppBar(title: 'Temperature')),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    title: Text('Celsius (°C)'),
                    onTap: () async => await bloc
                        .saveTemperature(unit: TempUnit.C)
                        .then((value) => Navigator.of(context).pop()),
                  ),
                  ListTile(
                    title: Text('Fahrenheit (°F)'),
                    onTap: () async => await bloc
                        .saveTemperature(unit: TempUnit.F)
                        .then((value) => Navigator.of(context).pop()),
                  ),
                  ListTile(
                    title: Text('Kelvin (K)'),
                    onTap: () async => await bloc
                        .saveTemperature(unit: TempUnit.K)
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
