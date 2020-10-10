import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/configs/custom_icons.dart';
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
    // print('ForecastDetails');
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        // Fore better performance built each on a statelessWidget
        const ForecastDetailLocation(),
        const ForecastDetailLatLong(),
        const ForecastDetailSunrise(),
        const ForecastDetailSunset(),
        const ForecastDetailTimezone(),
        const ForecastDetailTimezoneName(),
        const ForecastDetailWindSpeed(),
        const ForecastDetailWindDir(),
        const ForecastDetailWindDirCompass(),
        const ForecastDetailHumidity(),
        const ForecastDetailPressure(),
        const ForecastDetailVisibility(),
        const ForecastDetailConfidence(),
      ],
    );
  }
}

// ----------------------------- ForecastDetailLocation -----------------------------
class ForecastDetailLocation extends StatelessWidget {
  const ForecastDetailLocation();
  @override
  Widget build(BuildContext context) {
    // print('ForecastDetailLocation');
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
            return StreamBuilder<LocationClimate>(
              stream: forecastBloc.forecastStream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return ListTileTheme(
                      child: ListTile(
                        title: Text(
                          'Location Type',
                          style: theme.textTheme.subtitle2
                              .copyWith(fontSize: 12.0),
                        ),
                        subtitle: Text(
                          snapshot.data.locationType,
                          style: theme.textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 16.0),
                        ),
                        trailing: Icon(FontAwesomeIcons.city),
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

// ----------------------------- ForecastDetailLatLong -----------------------------
class ForecastDetailLatLong extends StatelessWidget {
  const ForecastDetailLatLong();
  @override
  Widget build(BuildContext context) {
    // print('ForecastDetailLatLong');
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
            theme = themeSnapshot.data;
            return StreamBuilder<LocationClimate>(
              stream: forecastBloc.forecastStream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return ListTileTheme(
                      child: ListTile(
                        title: Text(
                          'Latitude,Longitude',
                          style: theme.textTheme.subtitle2
                              .copyWith(fontSize: 12.0),
                        ),
                        subtitle: Text(
                          snapshot.data.lattLong,
                          style: theme.textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                        trailing: Icon(FontAwesomeIcons.directions, size: 26.0),
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

// ----------------------------- ForecastDetailSunrise -----------------------------
class ForecastDetailSunrise extends StatelessWidget {
  const ForecastDetailSunrise();
  @override
  Widget build(BuildContext context) {
    // print('ForecastDetailSunrise');
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
            return StreamBuilder<LocationClimate>(
              stream: forecastBloc.forecastStream,
              builder: (context, forecastSnapshot) {
                switch (forecastSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return StreamBuilder(
                      stream: prefBloc.timezoneStream,
                      builder: (context,
                          AsyncSnapshot<TimezoneChoice> timezoneSnapshot) {
                        switch (timezoneSnapshot.connectionState) {
                          case ConnectionState.active:
                          case ConnectionState.done:
                            String date =
                                (forecastSnapshot.data.sunRise == null)
                                    ? null
                                    : DateFormat.Hms().format(
                                        // Sunrise in user desired timezone
                                        UnitConverter.timezoneConverter(
                                          offset: forecastSnapshot.data.offset,
                                          time: forecastSnapshot.data.sunRise,
                                          timezone: timezoneSnapshot.data,
                                        ),
                                      );
                            // Timezone name
                            String unit = UnitConverter.timezoneName(
                              climateTimezoneName:
                                  forecastSnapshot.data.timezoneName,
                              timezone: timezoneSnapshot.data,
                            );
                            return ListTileTheme(
                              child: ListTile(
                                title: Text(
                                  'Sunrise($unit)',
                                  style: theme.textTheme.subtitle2
                                      .copyWith(fontSize: 12.0),
                                ),
                                subtitle: Text(
                                  date ?? 'NaN',
                                  style: theme.textTheme.bodyText2.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                ),
                                trailing:
                                    Icon(WeatherIcons.sunrise, size: 26.0),
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
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ------------------------------ ForecastDetailSunset ------------------------------
class ForecastDetailSunset extends StatelessWidget {
  const ForecastDetailSunset();
  @override
  Widget build(BuildContext context) {
    // print('ForecastDetailSunset');
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
            return StreamBuilder<LocationClimate>(
              stream: forecastBloc.forecastStream,
              builder: (context, forecastSnapshot) {
                switch (forecastSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return StreamBuilder(
                      stream: prefBloc.timezoneStream,
                      builder: (context,
                          AsyncSnapshot<TimezoneChoice> timezoneSnapshot) {
                        switch (timezoneSnapshot.connectionState) {
                          case ConnectionState.active:
                          case ConnectionState.done:
                            String date =
                                // Sunrise is null
                                (forecastSnapshot.data?.sunSet == null)
                                    ? null
                                    : DateFormat.Hms().format(
                                        // Sunrise in user desired timezone
                                        UnitConverter.timezoneConverter(
                                          offset: forecastSnapshot.data.offset,
                                          time: forecastSnapshot.data.sunSet,
                                          timezone: timezoneSnapshot.data,
                                        ),
                                      );
                            // Timezone name
                            String unit = UnitConverter.timezoneName(
                              climateTimezoneName:
                                  forecastSnapshot.data.timezoneName,
                              timezone: timezoneSnapshot.data,
                            );
                            return ListTileTheme(
                              child: ListTile(
                                title: Text(
                                  'Sunset($unit)',
                                  style: theme.textTheme.subtitle2
                                      .copyWith(fontSize: 12.0),
                                ),
                                subtitle: Text(
                                  date ?? 'NaN',
                                  style: theme.textTheme.bodyText2.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                ),
                                trailing: Icon(WeatherIcons.sunset, size: 26.0),
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
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ----------------------------- ForecastDetailTimezone -----------------------------
class ForecastDetailTimezone extends StatelessWidget {
  const ForecastDetailTimezone();
  @override
  Widget build(BuildContext context) {
    // print('ForecastDetailTimezone');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    ForecastBloc forecastBloc = BlocProvider.of<ForecastBloc>(context);
    ThemeData theme;

    return StreamBuilder<ThemeData>(
      stream: prefBloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return StreamBuilder<LocationClimate>(
              stream: forecastBloc.forecastStream,
              builder: (context, forecastSnapshot) {
                switch (forecastSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    theme = themeSnapshot.data;
                    return ListTileTheme(
                      child: ListTile(
                        title: Text(
                          'Timezone',
                          style: theme.textTheme.subtitle2
                              .copyWith(fontSize: 12.0),
                        ),
                        subtitle: Text(
                          forecastSnapshot.data?.timezone ?? 'NaN',
                          style: theme.textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 16.0),
                        ),
                        trailing: Icon(FontAwesomeIcons.globe),
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

// --------------------------- ForecastDetailTimezoneName ---------------------------
class ForecastDetailTimezoneName extends StatelessWidget {
  const ForecastDetailTimezoneName();
  @override
  Widget build(BuildContext context) {
    // print('ForecastDetailTimezoneName');
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
              builder: (context, timezoneSnapshot) {
                switch (timezoneSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return ListTileTheme(
                      child: ListTile(
                        title: Text(
                          'Timezone Name',
                          style: theme.textTheme.subtitle2
                              .copyWith(fontSize: 12.0),
                        ),
                        subtitle: Text(
                          timezoneSnapshot.data,
                          style: theme.textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 16.0),
                        ),
                        trailing: Icon(FontAwesomeIcons.mapMarked),
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

// ---------------------------- ForecastDetailWindSpeed ----------------------------
class ForecastDetailWindSpeed extends StatelessWidget {
  const ForecastDetailWindSpeed();
  @override
  Widget build(BuildContext context) {
    // print('ForecastDetailWindSpeed');
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

            return StreamBuilder<ConsolidatedWeather>(
              stream: forecastBloc.todayForecastStream,
              builder: (context, forecastSnapshot) {
                switch (forecastSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return StreamBuilder<WindUnit>(
                      stream: prefBloc.windStream,
                      builder: (context, windSnapshot) {
                        switch (windSnapshot.connectionState) {
                          case ConnectionState.active:
                          case ConnectionState.done:
                            // Saved Wind unit
                            String unit =
                                UnitConverter.strUnit(windSnapshot.data);
                            // Wind speed in user desired unit, can be null
                            double wind = UnitConverter.windConverter(
                              amount: forecastSnapshot.data?.windSpeed,
                              unit: windSnapshot.data,
                            );
                            return ListTileTheme(
                              child: ListTile(
                                title: Text(
                                  'Wind',
                                  style: theme.textTheme.subtitle2
                                      .copyWith(fontSize: 12.0),
                                ),
                                subtitle: Text(
                                  // wind speed is null
                                  (wind == null)
                                      ? 'NaN'
                                      : '${wind.toStringAsFixed(2)} $unit',
                                  style: theme.textTheme.bodyText2.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                ),
                                trailing: Icon(FontAwesomeIcons.wind),
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
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ----------------------------- ForecastDetailWindDir -----------------------------
class ForecastDetailWindDir extends StatelessWidget {
  const ForecastDetailWindDir();
  @override
  Widget build(BuildContext context) {
    // print('ForecastDetailWindDir');
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
            return StreamBuilder<ConsolidatedWeather>(
              stream: forecastBloc.todayForecastStream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return ListTileTheme(
                      child: ListTile(
                        title: Text(
                          'Wind Direction',
                          style: theme.textTheme.subtitle2
                              .copyWith(fontSize: 12.0),
                        ),
                        subtitle: Text(
                          // wind direction is null
                          (snapshot.data?.windDirection == null)
                              ? 'NaN'
                              : '${snapshot.data.windDirection.toStringAsFixed(2)}°',
                          style: theme.textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 16.0),
                        ),
                        trailing: Icon(CustomIcon.weathercock, size: 28.0),
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

// -------------------------- ForecastDetailWindDirCompass --------------------------
class ForecastDetailWindDirCompass extends StatelessWidget {
  const ForecastDetailWindDirCompass();
  @override
  Widget build(BuildContext context) {
    // print('ForecastDetailWindDirCompass');
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
            return StreamBuilder<ConsolidatedWeather>(
              stream: forecastBloc.todayForecastStream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return ListTileTheme(
                      child: ListTile(
                        title: Text(
                          'Wind Direction Compass',
                          style: theme.textTheme.subtitle2
                              .copyWith(fontSize: 12.0),
                        ),
                        subtitle: Text(
                          // wind compass is null
                          snapshot.data?.windDirectionCompass ?? 'NaN',
                          style: theme.textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 16.0),
                        ),
                        trailing: Icon(FontAwesomeIcons.compass, size: 26.0),
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

// ----------------------------- ForecastDetailHumidity -----------------------------
class ForecastDetailHumidity extends StatelessWidget {
  const ForecastDetailHumidity();
  @override
  Widget build(BuildContext context) {
    // print('ForecastDetailHumidity');
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
            return StreamBuilder<ConsolidatedWeather>(
              stream: forecastBloc.todayForecastStream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return ListTileTheme(
                      child: ListTile(
                        title: Text(
                          'Humidity',
                          style: theme.textTheme.subtitle2
                              .copyWith(fontSize: 12.0),
                        ),
                        subtitle: Text(
                          // Humidity is null
                          (snapshot.data?.humidity == null)
                              ? 'NaN'
                              : '${snapshot.data.humidity}%',
                          style: theme.textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 16.0),
                        ),
                        trailing: Icon(WeatherIcons.humidity, size: 30.0),
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

// ---------------------------- ForecastDetailVisibility ----------------------------
class ForecastDetailVisibility extends StatelessWidget {
  const ForecastDetailVisibility();
  @override
  Widget build(BuildContext context) {
    // print('ForecastDetailVisibility');
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
            return StreamBuilder<ConsolidatedWeather>(
              stream: forecastBloc.todayForecastStream,
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
                            // saved Length unit
                            DistanceUnit unit = distanceSnapshot.data;
                            // Length in user desired unit, can be null
                            double distance = UnitConverter.distanceConverter(
                              unit: unit,
                              amount: forecastSnapshot.data?.visibility,
                            );
                            return ListTileTheme(
                              child: ListTile(
                                title: Text(
                                  'Visibility',
                                  style: theme.textTheme.subtitle2
                                      .copyWith(fontSize: 12.0),
                                ),
                                subtitle: Text(
                                  // Visibility is null
                                  (forecastSnapshot.data?.visibility == null)
                                      ? 'NaN'
                                      : '${distance.toStringAsFixed(2)} ${UnitConverter.strUnit(unit)}',
                                  style: theme.textTheme.bodyText2.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                ),
                                trailing: Icon(FontAwesomeIcons.eye),
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
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ----------------------------- ForecastDetailPressure -----------------------------
class ForecastDetailPressure extends StatelessWidget {
  const ForecastDetailPressure();
  @override
  Widget build(BuildContext context) {
    // print('ForecastDetailPressure');
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
            return StreamBuilder<ConsolidatedWeather>(
              stream: forecastBloc.todayForecastStream,
              builder: (context, forecastSnapshot) {
                switch (forecastSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return StreamBuilder(
                      stream: prefBloc.pressureStream,
                      builder: (context,
                          AsyncSnapshot<PressureUnit> pressureSnapshot) {
                        switch (pressureSnapshot.connectionState) {
                          case ConnectionState.active:
                          case ConnectionState.done:
                            // Saved Pressure unit
                            PressureUnit unit = pressureSnapshot.data;
                            // Pressure in user desired unit, can be null
                            double pressure = UnitConverter.pressureConverter(
                              amount: forecastSnapshot.data?.airPressure,
                              unit: unit,
                            );
                            return ListTileTheme(
                              child: ListTile(
                                title: Text(
                                  'Air Pressure',
                                  style: theme.textTheme.subtitle2
                                      .copyWith(fontSize: 12.0),
                                ),
                                subtitle: Text(
                                  // Pressure is null
                                  (pressure == null)
                                      ? 'NaN'
                                      : '${pressure.toStringAsFixed(2)} ${UnitConverter.strUnit(unit)}',
                                  style: theme.textTheme.bodyText2.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                ),
                                trailing: Icon(CustomIcon.gauge, size: 30.0),
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
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ---------------------------- ForecastDetailConfidence ----------------------------
class ForecastDetailConfidence extends StatelessWidget {
  const ForecastDetailConfidence();
  @override
  Widget build(BuildContext context) {
    // print('ForecastDetailConfidence');
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
            return StreamBuilder<ConsolidatedWeather>(
              stream: forecastBloc.todayForecastStream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return ListTileTheme(
                      child: ListTile(
                        title: Text(
                          'Confidence',
                          style: theme.textTheme.subtitle2
                              .copyWith(fontSize: 12.0),
                        ),
                        subtitle: Text(
                          // predictability is null
                          (snapshot.data?.predictability == null)
                              ? 'NaN'
                              : '${snapshot.data.predictability}%',
                          style: theme.textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 16.0),
                        ),
                        trailing: Icon(CustomIcon.ball, size: 30.0),
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
