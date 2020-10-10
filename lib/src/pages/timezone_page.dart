import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/models/models.dart';
import 'package:climate/src/utils/unit_converter.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TimezonePage extends StatelessWidget {
  static const String routeName = "/TimezonePage";
  const TimezonePage();
  @override
  Widget build(BuildContext context) {
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: const CustomAppBar(title: 'Timezone')),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  //UTC
                  ListTile(
                    title: Text('Coordinated Universal Time (UTC)'),
                    onTap: () async => await bloc
                        .saveTimezone(timezone: TimezoneChoice.UTC)
                        .then((value) => Navigator.of(context).pop()),
                  ),
                  // User Timezone
                  ListTile(
                    title: Text(
                        'Your Timezone(${DateTime.now().toLocal().timeZoneName})'),
                    onTap: () async => await bloc
                        .saveTimezone(timezone: TimezoneChoice.USER)
                        .then((value) => Navigator.of(context).pop()),
                  ),
                  // Location Timezone
                  const LocationTimezoneTile()
                ],
              ).toList(),
            ),
          )
        ],
      ),
    );
  }
}

// ------------------------------ LocationTimezoneTile ------------------------------
class LocationTimezoneTile extends StatelessWidget {
  const LocationTimezoneTile();
  @override
  Widget build(BuildContext context) {
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);

    return StreamBuilder<LocationClimate>(
      stream: bloc.forecastStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
            return ListTile(
              title: Text('Location Timezone(${snapshot.data.timezoneName})'),
              onTap: () async => await prefBloc
                  .saveTimezone(timezone: TimezoneChoice.LOCATION)
                  .then((value) => Navigator.of(context).pop()),
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}
