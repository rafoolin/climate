import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/utils/unit_converter.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DistancePage extends StatelessWidget {
  static const String routeName = "/DistancePage";

  @override
  Widget build(BuildContext context) {
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: CustomAppBar(title: 'Distance')),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    title: Text('Mile (mi)'),
                    onTap: () async => await bloc
                        .saveDistance(unit: DistanceUnit.MILES)
                        .then((value) => Navigator.of(context).pop()),
                  ),
                  ListTile(
                    title: Text('kilometers (km)'),
                    onTap: () async => await bloc
                        .saveDistance(unit: DistanceUnit.KM)
                        .then((value) => Navigator.of(context).pop()),
                  ),
                  ListTile(
                    title: Text('Foot (ft)'),
                    onTap: () async => await bloc
                        .saveDistance(unit: DistanceUnit.FOOT)
                        .then((value) => Navigator.of(context).pop()),
                  ),
                  ListTile(
                    title: Text('Inch (in)'),
                    onTap: () async => await bloc
                        .saveDistance(unit: DistanceUnit.INCH)
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
