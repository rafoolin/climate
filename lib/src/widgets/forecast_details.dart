import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/models/models.dart';
import 'package:climate/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastDetails extends StatelessWidget {
  const ForecastDetails();
  @override
  Widget build(BuildContext context) {
    print('ForecastDetails');

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        const ForecastDetailLocation(),
        const ForecastDetailLatLong(),
        const ForecastDetailSunrise(),
        const ForecastDetailSunset(),
        const ForecastDetailTimezone(),
        const ForecastDetailTimezoneName(),
        const ForecastDetailWindSpeed(),
        const ForecastDetailWindDir(),
        const ForecastDetailPressure(),
        const ForecastDetailWindDirCompass(),
        const ForecastDetailVisibility(),
        const ForecastDetailPredictability(),
      ],
    );
  }
}

class ForecastDetailLocation extends StatelessWidget {
  const ForecastDetailLocation();
  @override
  Widget build(BuildContext context) {
    print('ForecastDetailLocation');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    return StreamBuilder<LocationClimate>(
      stream: bloc.forecastStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return ListTile(
              title: Text(
                'Location Type',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontSize: 12.0),
              ),
              subtitle: Text(
                snapshot.data.locationType,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 16.0),
              ),
              trailing: Icon(FontAwesomeIcons.city),
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

class ForecastDetailLatLong extends StatelessWidget {
  const ForecastDetailLatLong();
  @override
  Widget build(BuildContext context) {
    print('ForecastDetailLatLong');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    return StreamBuilder<LocationClimate>(
      stream: bloc.forecastStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return ListTile(
              title: Text(
                'Latitude,Longitude',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontSize: 12.0),
              ),
              subtitle: Text(
                snapshot.data.lattLong,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 16.0),
              ),
              trailing: Icon(FontAwesomeIcons.directions),
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

class ForecastDetailSunrise extends StatelessWidget {
  const ForecastDetailSunrise();
  @override
  Widget build(BuildContext context) {
    print('ForecastDetailLatLong');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    return StreamBuilder<LocationClimate>(
      stream: bloc.forecastStream,
      builder: (context, forecastSnapshot) {
        switch (forecastSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return StreamBuilder(
              stream: prefBloc.timezoneStream,
              builder:
                  (context, AsyncSnapshot<TimezoneChoice> timezoneSnapshot) {
                switch (timezoneSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    String date =
                        DateFormat.Hms().format(UnitConverter.timezoneConverter(
                      offset: forecastSnapshot.data.offset,
                      time: forecastSnapshot.data.sunRise,
                      timezone: timezoneSnapshot.data,
                    ));
                    String unit = UnitConverter.timezoneName(
                      climateTimezoneName: forecastSnapshot.data.timezoneName,
                      timezone: timezoneSnapshot.data,
                    );
                    return ListTile(
                      title: Text(
                        'Sunrise($unit)',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 12.0),
                      ),
                      subtitle: Text(
                        date,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 16.0),
                      ),
                      trailing: Icon(WeatherIcons.sunrise),
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

class ForecastDetailSunset extends StatelessWidget {
  const ForecastDetailSunset();
  @override
  Widget build(BuildContext context) {
    print('ForecastDetailSunset');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    return StreamBuilder<LocationClimate>(
      stream: bloc.forecastStream,
      builder: (context, forecastSnapshot) {
        switch (forecastSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return StreamBuilder(
              stream: prefBloc.timezoneStream,
              builder:
                  (context, AsyncSnapshot<TimezoneChoice> timezoneSnapshot) {
                switch (timezoneSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    String date =
                        DateFormat.Hms().format(UnitConverter.timezoneConverter(
                      offset: forecastSnapshot.data.offset,
                      time: forecastSnapshot.data.sunSet,
                      timezone: timezoneSnapshot.data,
                    ));
                    String unit = UnitConverter.timezoneName(
                      climateTimezoneName: forecastSnapshot.data.timezoneName,
                      timezone: timezoneSnapshot.data,
                    );
                    return ListTile(
                      title: Text(
                        'Sunrise($unit)',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 12.0),
                      ),
                      subtitle: Text(
                        date,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 16.0),
                      ),
                      trailing: Icon(WeatherIcons.sunset),
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

class ForecastDetailTimezone extends StatelessWidget {
  const ForecastDetailTimezone();
  @override
  Widget build(BuildContext context) {
    print('ForecastDetailTimezone');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    return StreamBuilder<LocationClimate>(
      stream: bloc.forecastStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return ListTile(
              title: Text(
                'Timezone',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontSize: 12.0),
              ),
              subtitle: Text(
                snapshot.data.timezone,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 16.0),
              ),
              trailing: Icon(FontAwesomeIcons.globe),
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

class ForecastDetailTimezoneName extends StatelessWidget {
  const ForecastDetailTimezoneName();
  @override
  Widget build(BuildContext context) {
    print('ForecastDetailTimezoneName');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    return StreamBuilder<String>(
      stream: bloc.timezoneNameStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return ListTile(
              title: Text(
                'Timezone Name',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontSize: 12.0),
              ),
              subtitle: Text(
                snapshot.data,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 16.0),
              ),
              trailing: Icon(FontAwesomeIcons.mapMarked),
            );

            break;
          default:
            return Container();
        }
      },
    );
  }
}

class ForecastDetailWindSpeed extends StatelessWidget {
  const ForecastDetailWindSpeed();
  @override
  Widget build(BuildContext context) {
    print('ForecastDetailWindSpeed');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    return StreamBuilder<ConsolidatedWeather>(
      stream: bloc.todayForecastStream,
      builder: (context, forecastSnapshot) {
        switch (forecastSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return StreamBuilder(
              stream: prefBloc.windStream,
              builder: (context, AsyncSnapshot<WindUnit> windSnapshot) {
                switch (windSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    String unit = UnitConverter.strUnit(windSnapshot.data);
                    double wind = forecastSnapshot.data.windSpeed;
                    return ListTile(
                      title: Text(
                        'Wind',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 12.0),
                      ),
                      subtitle: Text(
                        '${wind.toStringAsPrecision(2)} $unit',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 16.0),
                      ),
                      trailing: Icon(WeatherIcons.sunset),
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

class ForecastDetailWindDir extends StatelessWidget {
  const ForecastDetailWindDir();
  @override
  Widget build(BuildContext context) {
    print('ForecastDetailWindDir');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    return StreamBuilder<ConsolidatedWeather>(
      stream: bloc.todayForecastStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return ListTile(
              title: Text(
                'Wind Direction',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontSize: 12.0),
              ),
              subtitle: Text(
                snapshot.data.windDirection.toStringAsFixed(2),
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 16.0),
              ),
              trailing: Icon(WeatherIcons.small_craft_advisory),
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

class ForecastDetailWindDirCompass extends StatelessWidget {
  const ForecastDetailWindDirCompass();
  @override
  Widget build(BuildContext context) {
    print('ForecastDetailWindDirCompass');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    return StreamBuilder<ConsolidatedWeather>(
      stream: bloc.todayForecastStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return ListTile(
              title: Text(
                'Wind Direction Compass',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontSize: 12.0),
              ),
              subtitle: Text(
                snapshot.data.windDirectionCompass,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 16.0),
              ),
              trailing: Icon(FontAwesomeIcons.compass),
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

class ForecastDetailPressure extends StatelessWidget {
  const ForecastDetailPressure();
  @override
  Widget build(BuildContext context) {
    print('ForecastDetailPressure');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    return StreamBuilder<ConsolidatedWeather>(
      stream: bloc.todayForecastStream,
      builder: (context, forecastSnapshot) {
        switch (forecastSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return StreamBuilder(
              stream: prefBloc.pressureStream,
              builder: (context, AsyncSnapshot<PressureUnit> pressureSnapshot) {
                switch (pressureSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    String unit = UnitConverter.strUnit(pressureSnapshot.data);
                    double pressure = forecastSnapshot.data.airPressure;
                    return ListTile(
                      title: Text(
                        'Air Pressure',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 12.0),
                      ),
                      subtitle: Text(
                        '${pressure.toStringAsPrecision(2)} $unit',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 16.0),
                      ),
                      trailing: Icon(WeatherIcons.barometer),
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

class ForecastDetailVisibility extends StatelessWidget {
  const ForecastDetailVisibility();
  @override
  Widget build(BuildContext context) {
    print('ForecastDetailVisibility');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    return StreamBuilder<ConsolidatedWeather>(
      stream: bloc.todayForecastStream,
      builder: (context, forecastSnapshot) {
        switch (forecastSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return StreamBuilder<DistanceUnit>(
              stream: prefBloc.distanceStream,
              builder: (context, distanceSnapshot) {
                switch (distanceSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    DistanceUnit unit = distanceSnapshot.data;
                    double distance = UnitConverter.distanceConverter(
                      unit: unit,
                      amount: forecastSnapshot.data.airPressure,
                    );
                    return ListTile(
                      title: Text(
                        'Visibility',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 12.0),
                      ),
                      subtitle: Text(
                        distance.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 16.0),
                      ),
                      trailing: Icon(FontAwesomeIcons.road),
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

class ForecastDetailPredictability extends StatelessWidget {
  const ForecastDetailPredictability();
  @override
  Widget build(BuildContext context) {
    print('ForecastDetailPredictability');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    return StreamBuilder<ConsolidatedWeather>(
      stream: bloc.todayForecastStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return ListTile(
              title: Text(
                'Predictability',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontSize: 12.0),
              ),
              subtitle: Text(
                '${snapshot.data.predictability}%',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 16.0),
              ),
              trailing: Icon(FontAwesomeIcons.magic),
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}
