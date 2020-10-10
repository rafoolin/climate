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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: const CustomAppBar(title: 'Settings')),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const ThemeTile(),
                const LocationTile(),
                const TimezoneTile(),
                const TempTile(),
                const WindTile(),
                const PressureTile(),
                const DistanceTile(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ----------------------------------- ThemeTile -----------------------------------
class ThemeTile extends StatelessWidget {
  const ThemeTile();
  @override
  Widget build(BuildContext context) {
    // print('ThemeTile');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    ForecastBloc forecastBloc = BlocProvider.of<ForecastBloc>(context);
    ThemeData theme;
    bool isDark;

    return StreamBuilder<ThemeData>(
      stream: prefBloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            theme = themeSnapshot.data;
            isDark = theme.brightness == Brightness.dark;
            return StreamBuilder<Color>(
              stream: forecastBloc.climateColorStream,
              builder: (context, colorSnapshot) {
                switch (colorSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return ListTileTheme(
                      child: SwitchListTile(
                        activeColor: colorSnapshot.data,
                        title: Text('Theme'),
                        secondary: isDark
                            ? Icon(FontAwesomeIcons.moon)
                            : Icon(FontAwesomeIcons.solidSun),
                        subtitle: isDark ? Text('Dark') : Text('Light'),
                        value: isDark,
                        onChanged: (value) async {
                          await prefBloc.saveTheme(isDark: value);
                        },
                      ),
                      iconColor: theme.iconTheme.color,
                    );
                    break;
                  default:
                    return Container();
                }
              },
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ---------------------------------- LocationTile ----------------------------------
class LocationTile extends StatelessWidget {
  const LocationTile();
  @override
  Widget build(BuildContext context) {
    // print('LocationTile');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    String location;
    ThemeData theme;

    return StreamBuilder<ThemeData>(
      stream: prefBloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            theme = themeSnapshot.data;
            return StreamBuilder<String>(
              stream: prefBloc.locationStream,
              builder: (BuildContext context, forecastSnapshot) {
                switch (forecastSnapshot.connectionState) {
                  case ConnectionState.done:
                  case ConnectionState.active:
                    location = forecastSnapshot.data;
                    return ListTileTheme(
                      child: ListTile(
                        title: Text('Location'),
                        leading: location.isEmpty
                            ? Icon(Icons.location_searching)
                            : Icon(Icons.my_location),
                        subtitle:
                            Text(location.isEmpty ? 'No Location' : location),
                        onTap: () => Navigator.of(context)
                            .pushNamed(LocationPage.routeName),
                      ),
                      iconColor: theme.iconTheme.color,
                    );
                    break;
                  case ConnectionState.waiting:
                  default:
                    return Center(child: CircularProgressIndicator());
                }
              },
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ---------------------------------- TimezoneTile ----------------------------------
class TimezoneTile extends StatelessWidget {
  const TimezoneTile();
  @override
  Widget build(BuildContext context) {
    // print('TimezoneTile');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    ForecastBloc forecastBloc = BlocProvider.of<ForecastBloc>(context);
    ThemeData theme;

    return StreamBuilder<ThemeData>(
      stream: prefBloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            theme = themeSnapshot.data;
            return StreamBuilder<String>(
              stream: forecastBloc.timezoneNameStream,
              builder: (BuildContext context, snapshot) {
                return ListTileTheme(
                  child: ListTile(
                    title: Text('Timezone'),
                    leading: Icon(FontAwesomeIcons.globe),
                    subtitle: Text(snapshot.data ?? ''),
                    onTap: () =>
                        Navigator.of(context).pushNamed(TimezonePage.routeName),
                  ),
                  iconColor: theme.iconTheme.color,
                );
              },
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ------------------------------------ TempTile ------------------------------------
class TempTile extends StatelessWidget {
  const TempTile();
  @override
  Widget build(BuildContext context) {
    // print('TempTile');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    ThemeData theme;
    String unit;

    return StreamBuilder<ThemeData>(
      stream: prefBloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            theme = themeSnapshot.data;
            return StreamBuilder<TempUnit>(
              stream: prefBloc.tempStream,
              builder: (BuildContext context, tempSnapshot) {
                switch (tempSnapshot.connectionState) {
                  case ConnectionState.done:
                  case ConnectionState.active:
                    unit =
                        UnitConverter.strUnit(tempSnapshot.data).toUpperCase();
                    return ListTileTheme(
                      child: ListTile(
                        title: Text('Temperature'),
                        leading: Icon(
                          WeatherIcons.thermometer,
                        ),
                        subtitle: tempSnapshot.data == TempUnit.K
                            ? Text(unit)
                            : Text('°$unit'),
                        onTap: () async => await Navigator.of(context)
                            .pushNamed(TempPage.routeName),
                      ),
                      iconColor: theme.iconTheme.color,
                    );
                    break;
                  case ConnectionState.waiting:
                  default:
                    return Center(child: CircularProgressIndicator());
                }
              },
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ------------------------------------ WindTile ------------------------------------
class WindTile extends StatelessWidget {
  const WindTile();
  @override
  Widget build(BuildContext context) {
    // print('WindTile');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    ThemeData theme;
    String unit;

    return StreamBuilder<ThemeData>(
      stream: prefBloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            theme = themeSnapshot.data;
            return StreamBuilder<WindUnit>(
              stream: prefBloc.windStream,
              builder: (BuildContext context, windSnapshot) {
                switch (windSnapshot.connectionState) {
                  case ConnectionState.done:
                  case ConnectionState.active:
                    unit = UnitConverter.strUnit(windSnapshot.data);
                    return ListTileTheme(
                      child: ListTile(
                        title: Text('Wind Speed'),
                        leading: Icon(WeatherIcons.strong_wind),
                        subtitle: Text(unit),
                        onTap: () =>
                            Navigator.of(context).pushNamed(WindPage.routeName),
                      ),
                      iconColor: theme.iconTheme.color,
                    );
                    break;
                  case ConnectionState.waiting:
                  default:
                    return Center(child: CircularProgressIndicator());
                }
              },
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ---------------------------------- PressureTile ----------------------------------
class PressureTile extends StatelessWidget {
  const PressureTile();
  @override
  Widget build(BuildContext context) {
    // print('PressureTile');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    ThemeData theme;
    String unit;

    return StreamBuilder<ThemeData>(
      stream: prefBloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            theme = themeSnapshot.data;
            return StreamBuilder<PressureUnit>(
              stream: prefBloc.pressureStream,
              builder: (BuildContext context, pressureSnapshot) {
                switch (pressureSnapshot.connectionState) {
                  case ConnectionState.done:
                  case ConnectionState.active:
                    unit = UnitConverter.strUnit(pressureSnapshot.data);
                    return ListTileTheme(
                      child: ListTile(
                        title: Text('Pressure'),
                        leading: Icon(WeatherIcons.barometer),
                        subtitle: Text(unit),
                        onTap: () => Navigator.of(context)
                            .pushNamed(PressurePage.routeName),
                      ),
                      iconColor: theme.iconTheme.color,
                    );
                    break;
                  case ConnectionState.waiting:
                  default:
                    return Center(child: CircularProgressIndicator());
                }
              },
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ---------------------------------- DistanceTile ----------------------------------
class DistanceTile extends StatelessWidget {
  const DistanceTile();
  @override
  Widget build(BuildContext context) {
    // print('LocationTile');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    ThemeData theme;
    String unit;

    return StreamBuilder<ThemeData>(
      stream: prefBloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            theme = themeSnapshot.data;
            return StreamBuilder<DistanceUnit>(
              stream: prefBloc.distanceStream,
              builder: (BuildContext context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                  case ConnectionState.active:
                    unit = UnitConverter.strUnit(snapshot.data);
                    return ListTileTheme(
                      child: ListTile(
                        title: Text('Distance'),
                        leading: Icon(FontAwesomeIcons.route),
                        subtitle: Text(unit),
                        onTap: () => Navigator.of(context)
                            .pushNamed(DistancePage.routeName),
                      ),
                      iconColor: theme.iconTheme.color,
                    );
                    break;
                  case ConnectionState.waiting:
                  default:
                    return Center(child: CircularProgressIndicator());
                }
              },
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}
