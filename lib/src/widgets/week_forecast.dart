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
              children:
                  forecastSnapshot.data.consolidatedWeather.map((forecast) {
                return ExpansionTempTile(
                  applicableDate: forecast.applicableDate,
                  maxTemp: forecast.maxTemp,
                  minTemp: forecast.minTemp,
                );
              }).toList(),
              itemExtent: 36.0,
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
  }
}

class ExpansionTempTile extends StatelessWidget {
  final double minTemp;
  final double maxTemp;
  final DateTime applicableDate;
  const ExpansionTempTile({this.minTemp, this.maxTemp, this.applicableDate});
  @override
  Widget build(BuildContext context) {
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);
    int minimumTemp;
    int maximumTemp;
    TempUnit unit;
    String unitStr = '';
    String dateStr = '';
    DateFormat _df = DateFormat.Md();
    // Time in Local
    DateTime now = DateTime.now();
    // Time in UTC
    DateTime today = DateTime.utc(now.year, now.month, now.day);
    DateTime tomorrow = DateTime.utc(now.year, now.month, now.day + 1);

    return StreamBuilder<TempUnit>(
      stream: bloc.tempStream,
      builder: (context, tempSnapshot) {
        switch (tempSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            unit = tempSnapshot.data;

            if (applicableDate.isAtSameMomentAs(today))
              dateStr = "Today";
            else if (applicableDate.isAtSameMomentAs(tomorrow))
              dateStr = "Tomorrow.${_df.format(applicableDate)}";
            else
              dateStr = _df.format(applicableDate);
            // min temp in user desired unit
            minimumTemp = UnitConverter.tempConverter(
              amount: minTemp,
              unit: unit,
            ).floor();

            // max temp in user desired unit
            maximumTemp = UnitConverter.tempConverter(
              amount: maxTemp,
              unit: unit,
            ).floor();

            // Kelvin comes without degree sign
            unitStr = tempSnapshot.data == TempUnit.K
                ? 'K'
                : '°' + UnitConverter.strUnit(tempSnapshot.data).toUpperCase();

            return Container(
              height: 36.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$dateStr',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '$minimumTemp/$maximumTemp' + unitStr,
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
            return Container();
        }
      },
    );
  }
}
