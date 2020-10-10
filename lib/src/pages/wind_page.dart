import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/utils/unit_converter.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class WindPage extends StatelessWidget {
  static const String routeName = "/WindPage";
  const WindPage();
  @override
  Widget build(BuildContext context) {
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: const CustomAppBar(title: 'Wind Speed')),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    title: Text('Miles Per Hour (mph)'),
                    onTap: () async => await bloc
                        .saveWind(unit: WindUnit.MPH)
                        .then((value) => Navigator.of(context).pop()),
                  ),
                  ListTile(
                    title: Text('Feet Per Hour (fph)'),
                    onTap: () async => await bloc
                        .saveWind(unit: WindUnit.FPH)
                        .then((value) => Navigator.of(context).pop()),
                  ),
                  ListTile(
                    title: Text('Kilometre per hour (kph)'),
                    onTap: () async => await bloc
                        .saveWind(unit: WindUnit.KPH)
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
