import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/pages/pages.dart';
import 'package:climate/src/utils/utils.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_icons/weather_icons.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = "/SettingsPage";
  const SettingsPage();
  @override
  Widget build(BuildContext context) {
    print('SettingsPage');
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: CustomAppBar(title: 'Settings')),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  const ThemeTile(),
                  const LocationTile(),
                  const TimezoneTile(),
                  const TempTile(),
                  const WindTile(),
                  const PressureTile(),
                  const DistanceTile(),
                ],
              ).toList(),
            ),
          )
        ],
      ),
    );
  }
}

// ================================================================================
// =                                 THEME TILE                                   =
// ================================================================================
class ThemeTile extends StatelessWidget {
  const ThemeTile();

  @override
  Widget build(BuildContext context) {
    print('ThemeTile');
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);
    return StreamBuilder(
      stream: bloc.themeStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<bool> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
            return SwitchListTile(
              title: Text('Theme'),
              secondary: snapshot.data
                  ? Icon(FontAwesomeIcons.moon)
                  : Icon(FontAwesomeIcons.solidSun),
              subtitle: snapshot.data ? Text('Dark') : Text('Light'),
              value: snapshot.data,
              onChanged: (value) async {
                await bloc.saveTheme(isDark: value);
              },
            );
            break;
          case ConnectionState.waiting:
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

// ================================================================================
// =                                LOCATION TILE                                 =
// ================================================================================
class LocationTile extends StatelessWidget {
  const LocationTile();
  @override
  Widget build(BuildContext context) {
    print('LocationTile');
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);
    String location;
    return StreamBuilder(
      stream: bloc.locationStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<String> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
            location = snapshot.data;
            return ListTile(
              title: Text('Location'),
              leading: location.isEmpty
                  ? Icon(Icons.location_searching)
                  : Icon(Icons.my_location),
              subtitle: Text(location.isEmpty ? 'No Location' : location),
              onTap: () =>
                  Navigator.of(context).pushNamed(LocationPage.routeName),
            );
            break;
          case ConnectionState.waiting:
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

// ================================================================================
// =                                TIMEZONE TILE                                 =
// ================================================================================
class TimezoneTile extends StatelessWidget {
  const TimezoneTile();
  @override
  Widget build(BuildContext context) {
    print('TimezoneTile');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    return ListTile(
      title: Text('Timezone'),
      leading: Icon(FontAwesomeIcons.globe),
      subtitle: StreamBuilder(
        stream: bloc.timezoneNameStream,
        builder: (
          BuildContext context,
          AsyncSnapshot<String> snapshot,
        ) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            case ConnectionState.active:
              print('TimezoneTile ${snapshot.data}');
              return Text(snapshot.data);
              break;
            case ConnectionState.waiting:
            default:
              return Container();
          }
        },
      ),
      onTap: () => Navigator.of(context).pushNamed(TimezonePage.routeName),
    );
  }
}

// ================================================================================
// =                                  TEMP TILE                                   =
// ================================================================================
class TempTile extends StatelessWidget {
  const TempTile();
  @override
  Widget build(BuildContext context) {
    print('TempTile');
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);
    TempUnit unit;
    return StreamBuilder<TempUnit>(
      stream: bloc.tempStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<TempUnit> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
            unit = snapshot.data;
            return ListTile(
              title: Text('Temperature'),
              leading: Icon(
                WeatherIcons.thermometer,
              ),
              subtitle: Text('°${UnitConverter.strUnit(unit)}'),
              onTap: () async =>
                  await Navigator.of(context).pushNamed(TempPage.routeName),
            );
            break;
          case ConnectionState.waiting:
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

// ================================================================================
// =                                  WIND TILE                                   =
// ================================================================================
class WindTile extends StatelessWidget {
  const WindTile();
  @override
  Widget build(BuildContext context) {
    print('WindTile');
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);
    WindUnit unit;
    return StreamBuilder<WindUnit>(
      stream: bloc.windStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<WindUnit> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
            unit = snapshot.data;
            return ListTile(
              title: Text('Wind Speed'),
              leading: Icon(WeatherIcons.strong_wind),
              subtitle: Text('${UnitConverter.strUnit(unit)}'),
              onTap: () => Navigator.of(context).pushNamed(WindPage.routeName),
            );
            break;
          case ConnectionState.waiting:
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

// ================================================================================
// =                                PRESSURE TILE                                 =
// ================================================================================
class PressureTile extends StatelessWidget {
  const PressureTile();
  @override
  Widget build(BuildContext context) {
    print('PressureTile');
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);
    PressureUnit unit;
    return StreamBuilder(
      stream: bloc.pressureStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<PressureUnit> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
            unit = snapshot.data;
            return ListTile(
              title: Text('Pressure'),
              leading: Icon(WeatherIcons.barometer),
              subtitle: Text('${UnitConverter.strUnit(unit)}'),
              onTap: () =>
                  Navigator.of(context).pushNamed(PressurePage.routeName),
            );
            break;
          case ConnectionState.waiting:
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

// ================================================================================
// =                                DISTANCE TILE                                 =
// ================================================================================
class DistanceTile extends StatelessWidget {
  const DistanceTile();
  @override
  Widget build(BuildContext context) {
    print('DistanceTile');
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);
    DistanceUnit unit;
    return StreamBuilder(
      stream: bloc.distanceStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<DistanceUnit> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
            unit = snapshot.data;
            return ListTile(
              title: Text('Distance'),
              leading: Icon(FontAwesomeIcons.route),
              subtitle: Text('${UnitConverter.strUnit(unit)}'),
              onTap: () =>
                  Navigator.of(context).pushNamed(DistancePage.routeName),
            );
            break;
          case ConnectionState.waiting:
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
