import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/models/models.dart';
import 'package:climate/src/utils/utils.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekForecast extends StatelessWidget {
  const WeekForecast();
  @override
  Widget build(BuildContext context) {
    print('WeekForecast');
    ForecastBloc forecastBloc = BlocProvider.of<ForecastBloc>(context);
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    int minTemp;
    int maxTemp;
    String unit;
    return StreamBuilder<TempUnit>(
      stream: prefBloc.tempStream,
      builder: (context, tempSnapshot) {
        switch (tempSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return StreamBuilder<LocationClimate>(
              stream: forecastBloc.forecastStream,
              builder: (context, forecastSnapshot) {
                switch (forecastSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return CustomExpansion(
                      children: forecastSnapshot.data.consolidatedWeather
                          .map((forecast) {
                        // min temp in user desired unit
                        minTemp = UnitConverter.tempConverter(
                          amount: forecast.minTemp,
                          unit: tempSnapshot.data,
                        ).floor();

                        // max temp in user desired unit
                        maxTemp = UnitConverter.tempConverter(
                          amount: forecast.maxTemp,
                          unit: tempSnapshot.data,
                        ).floor();
                        unit =
                            // Kelvin comes without degree sign
                            tempSnapshot.data == TempUnit.K
                                ? 'K'
                                : '°' +
                                    UnitConverter.strUnit(tempSnapshot.data)
                                        .toUpperCase();

                        return Container(
                          height: 36.0,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_dayName(forecast.applicableDate)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '$minTemp/$maxTemp' + unit,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                    break;
                  default:
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 6,
                      itemBuilder: (context, index) => ListTile(
                        title: const Skeleton(height: 36.0),
                        trailing: const Skeleton(width: 64, height: 36.0),
                      ),
                    );
                }
              },
            );
            break;
          default:
            return const Skeleton();
        }
      },
    );
  }

  String _dayName(DateTime dateTime) {
    //TODO:: Date times based on user defined timezone

    DateFormat _df = DateFormat.Md();
    // Time in Local
    DateTime now = DateTime.now();
    // Time in UTC
    DateTime today = DateTime.utc(now.year, now.month, now.day);
    DateTime tomorrow = DateTime.utc(now.year, now.month, now.day + 1);

    if (dateTime.isAtSameMomentAs(today))
      return "Today";
    else if (dateTime.isAtSameMomentAs(tomorrow))
      return "Tomorrow.${_df.format(dateTime)}";
    else
      return _df.format(dateTime);
  }
}
