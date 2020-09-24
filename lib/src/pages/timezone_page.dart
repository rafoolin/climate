import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/models/models.dart';
import 'package:climate/src/utils/unit_converter.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TimezonePage extends StatefulWidget {
  static const String routeName = "/TimezonePage";

  @override
  _TimezonePageState createState() => _TimezonePageState();
}

class _TimezonePageState extends State<TimezonePage> {
  ForecastBloc _forecastBloc;
  PreferencesBloc _preferencesBloc;
  @override
  void initState() {
    _forecastBloc = BlocProvider.of<ForecastBloc>(context);
    _preferencesBloc = BlocProvider.of<PreferencesBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: CustomAppBar(title: 'Timezone')),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  _utc(),
                  _userTimezone(),
                  _locationTimezone(),
                ],
              ).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _utc() {
    return ListTile(
      title: Text('Coordinated Universal Time (UTC)'),
      onTap: () async => await _preferencesBloc
          .saveTimezone(timezone: TimezoneChoice.UTC)
          .then((value) => Navigator.of(context).pop()),
    );
  }

  Widget _userTimezone() {
    return ListTile(
      title: Text('Your Timezone(${DateTime.now().timeZoneName})'),
      onTap: () async => await _preferencesBloc
          .saveTimezone(timezone: TimezoneChoice.USER)
          .then((value) => Navigator.of(context).pop()),
    );
  }

  Widget _locationTimezone() {
    String timezone;
    return StreamBuilder<LocationClimate>(
      stream: _forecastBloc.forecastStream,
      builder: (context, AsyncSnapshot<LocationClimate> snapshot) {
        // In cases like empty location or lack of the internet,
        // it throws exception.
        if (snapshot.hasError) return Container();
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
            timezone = snapshot.data?.timezoneName;
            return ListTile(
              title: Text('Location Timezone($timezone)'),
              onTap: () async => await _preferencesBloc
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