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
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    return StreamBuilder<LocationClimate>(
      stream: bloc.forecastStream,
      builder: (context, forecastSnapshot) {
        switch (forecastSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return CustomExpansion(
              children: forecastSnapshot.data.consolidatedWeather
                  .map((forecast) => ForecastTempTile(forecast: forecast))
                  .toList(),
            );
            break;
          default:
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              itemBuilder: (context, index) => ListTile(
                title: Skeleton(height: 36.0),
                trailing: Skeleton(width: 64, height: 36.0),
              ),
            );
        }
      },
    );
  }
}

class ForecastTempTile extends StatelessWidget {
  final ConsolidatedWeather forecast;
  const ForecastTempTile({Key key, this.forecast}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('ForecastTempTile');
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);
    return StreamBuilder<TempUnit>(
      stream: bloc.tempStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
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
                  snapshot.data == TempUnit.K
                      ? Text(
                          '${forecast.minTemp?.floor() ?? '-'}/${forecast.maxTemp?.floor() ?? '-'}K',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontWeight: FontWeight.w500),
                        )
                      : Text(
                          '${forecast.minTemp?.floor() ?? '-'}/${forecast.maxTemp?.floor() ?? '-'}°${UnitConverter.strUnit(snapshot.data)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                ],
              ),
            );
            break;
          default:
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              itemBuilder: (context, index) => ListTile(
                title: Skeleton(height: 36.0),
                trailing: Skeleton(width: 64, height: 36.0),
              ),
            );
        }
      },
    );
  }

  String _dayName(DateTime dateTime) {
    DateFormat _df = DateFormat.Md();
    // now in desired timezone
    DateTime now = DateTime.now().toUtc();

    // today in desired timezone
    DateTime today = DateTime(now.year, now.month, now.day).toUtc();

    // tomorrow in desired timezone
    DateTime tomorrow = DateTime(now.year, now.month, now.day + 1).toUtc();

    if (dateTime.isAtSameMomentAs(today))
      return "Today";
    else if (dateTime == tomorrow)
      return "Tomorrow.${_df.format(dateTime)}";
    else
      return _df.format(dateTime);
  }
}
