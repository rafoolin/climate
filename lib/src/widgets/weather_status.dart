import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/configs/configs.dart';
import 'package:climate/src/models/models.dart';
import 'package:climate/src/utils/utils.dart';
import 'package:flutter/material.dart';

class WeatherStatus extends StatelessWidget {
  const WeatherStatus({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print('LocationTile');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    ForecastBloc forecastBloc = BlocProvider.of<ForecastBloc>(context);
    ThemeData theme;
    TempUnit unit;
    double temp;
    return StreamBuilder<ThemeData>(
      stream: prefBloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            // saved Theme data
            theme = themeSnapshot.data;
            return StreamBuilder<TempUnit>(
              stream: prefBloc.tempStream,
              builder: (context, AsyncSnapshot<TempUnit> tempSnapshot) {
                switch (tempSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    // saved temp unit
                    unit = tempSnapshot.data;
                    return StreamBuilder<ConsolidatedWeather>(
                      stream: forecastBloc.todayForecastStream,
                      builder: (context, forecastSnapshot) {
                        switch (forecastSnapshot.connectionState) {
                          case ConnectionState.active:
                          case ConnectionState.done:
                            // Temp in user desired unit
                            temp = UnitConverter.tempConverter(
                              unit: unit,
                              amount: forecastSnapshot.data?.theTemp,
                            );
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 45.0,
                                      color: theme.brightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    // If temp is null, display NaN
                                    text: (temp == null)
                                        ? 'NaN'
                                        : '${temp.floor()}',
                                    children: [
                                      TextSpan(
                                        text: unit == TempUnit.K
                                            ? '${UnitConverter.strUnit(unit).toUpperCase()}'
                                            : '°${UnitConverter.strUnit(unit).toUpperCase()}',
                                        style: TextStyle(
                                          color: CustomColor.weatherStateColor(
                                              weatherStateAbbr: forecastSnapshot
                                                  .data.weatherStateAbbr),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  child: Text(
                                    forecastSnapshot.data.weatherStateName,
                                    style: theme.textTheme.bodyText1.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              ],
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
