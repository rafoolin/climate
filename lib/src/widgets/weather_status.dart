import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/configs/configs.dart';
import 'package:climate/src/models/models.dart';
import 'package:climate/src/utils/utils.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class WeatherStatus extends StatelessWidget {
  const WeatherStatus({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('WeatherStatus');
    ForecastBloc forecastBloc = BlocProvider.of<ForecastBloc>(context)
      ..fetchForecast();
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);

    return StreamBuilder<LocationClimate>(
      stream: forecastBloc.forecastStream,
      builder: (context, AsyncSnapshot<LocationClimate> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            ConsolidatedWeather todayForecast =
                snapshot.data.consolidatedWeather.first;

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StreamBuilder<TempUnit>(
                  stream: prefBloc.tempStream,
                  builder: (context, AsyncSnapshot<TempUnit> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                      case ConnectionState.done:
                        double temp = UnitConverter.tempConverter(
                          unit: snapshot.data,
                          amount: todayForecast.theTemp,
                        );

                        TempUnit unit = snapshot.data;
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
                            text: '${temp.floor()}',
                            children: [
                              TextSpan(
                                text: unit == TempUnit.K
                                    ? '${UnitConverter.strUnit(unit).toUpperCase()}'
                                    : '°${UnitConverter.strUnit(unit).toUpperCase()}',
                                style: TextStyle(
                                  color: CustomColor.weatherStateColor(
                                    weatherStateAbbr:
                                        todayForecast.weatherStateAbbr,
                                  ),
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
                ),
                FittedBox(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  child: Text(
                    todayForecast.weatherStateName,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                )
              ],
            );

            break;
          default:
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 64.0),
              child: Skeleton(),
              width: 64.0,
              height: 64.0,
            );
        }
      },
    );
  }
}
