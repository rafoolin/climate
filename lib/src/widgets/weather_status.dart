import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/models/models.dart';
import 'package:climate/src/utils/utils.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class WeatherStatus extends StatelessWidget {
  const WeatherStatus({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('WeatherStatus');
    ForecastBloc forecastBloc = BlocProvider.of<ForecastBloc>(context);
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);

    return StreamBuilder<ConsolidatedWeather>(
      stream: forecastBloc.todayForecastStream,
      builder: (context, AsyncSnapshot<ConsolidatedWeather> forecastSnapshot) {
        switch (forecastSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StreamBuilder<TempUnit>(
                  stream: prefBloc.tempStream,
                  builder: (context, AsyncSnapshot<TempUnit> tempSnapshot) {
                    switch (tempSnapshot.connectionState) {
                      case ConnectionState.active:
                      case ConnectionState.done:
                        // Temp saved unit
                        TempUnit unit = tempSnapshot.data;
                        // Temp in user desired unit
                        double temp = UnitConverter.tempConverter(
                          unit: unit,
                          amount: forecastSnapshot.data?.theTemp,
                        );
                        // Temp unit in weather condition Color
                        return StreamBuilder<Color>(
                          stream: forecastBloc.climateColorStream,
                          builder: (context, colorSnapshot) {
                            switch (colorSnapshot.connectionState) {
                              case ConnectionState.active:
                              case ConnectionState.done:
                                return RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 45.0,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    text:
                                        // temp is null
                                        (forecastSnapshot.data?.theTemp == null)
                                            ? 'NaN'
                                            : '${temp.floor()}',
                                    children: [
                                      TextSpan(
                                        text: unit == TempUnit.K
                                            ? '${UnitConverter.strUnit(unit).toUpperCase()}'
                                            : '°${UnitConverter.strUnit(unit).toUpperCase()}',
                                        style: TextStyle(
                                          color: colorSnapshot.data,
                                        ),
                                      )
                                    ],
                                  ),
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
                ),
                FittedBox(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  child: Text(
                    forecastSnapshot.data.weatherStateName,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                )
              ],
            );

            break;
          default:
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 64.0),
              child: const Skeleton(),
              width: 64.0,
              height: 64.0,
            );
        }
      },
    );
  }
}
