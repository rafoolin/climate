import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/configs/configs.dart';
import 'package:climate/src/models/models.dart';
import 'package:climate/src/pages/pages.dart';
import 'package:climate/src/utils/utils.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class PersistHeader extends SliverPersistentHeaderDelegate {
  final double height;
  const PersistHeader({@required this.height});

  /// Return correct opacity to set for each widget, based on the barStatus
  double _getOpacity(double shrinkOffset) {
    double maxAllowedScroll = maxExtent - minExtent;
    if (maxAllowedScroll == maxExtent)
      return 1;
    else if (maxAllowedScroll == minExtent) return 0;
    return ((maxAllowedScroll - shrinkOffset) / maxAllowedScroll)
        .clamp(0, 1)
        .toDouble();
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    print('PersistHeader');
    double top = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        Positioned.fill(child: const PersistHeaderBg()),
        Positioned(
          right: 0.0,
          left: 0.0,
          top: 0.0,
          child: const PersistHeaderAppBar(),
        ),
        Positioned(
          top: top + 56.0,
          left: 24.0,
          right: 24.0,
          bottom: 68.0,
          child: AnimatedOpacity(
            opacity: _getOpacity(shrinkOffset),
            duration: const Duration(milliseconds: 100),
            child: const PersistHeaderWide(),
          ),
        ),
        Positioned(
          top: top + 56.0,
          left: 24.0,
          right: 24.0,
          bottom: 68.0,
          child: AnimatedOpacity(
            opacity: 1 - _getOpacity(shrinkOffset),
            duration: const Duration(milliseconds: 100),
            child: const PersistHeaderNarrow(),
          ),
        ),
        Positioned(
          bottom: 36.0,
          left: 16.0,
          child: const PersistHeaderLastUpdate(),
        ),
      ],
    );
  }

  @override
  double get maxExtent => height * CustomRatio.maxRatio;

  @override
  double get minExtent => height * CustomRatio.minRatio;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

// -------------------------------- PersistHeaderBg --------------------------------
class PersistHeaderBg extends StatelessWidget {
  const PersistHeaderBg();
  @override
  Widget build(BuildContext context) {
    print('PersistHeaderBg');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);

    return StreamBuilder(
      stream: bloc.climateColorStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return ClipPath(
              clipper: Clipper(),
              child: Container(color: snapshot.data),
            );
            break;
          default:
            return ClipPath(
              clipper: Clipper(),
              child: const Skeleton(),
            );
        }
      },
    );
  }
}

// ------------------------------ PersistHeaderAppBar ------------------------------
class PersistHeaderAppBar extends StatelessWidget {
  const PersistHeaderAppBar();
  @override
  Widget build(BuildContext context) {
    print('PersistHeaderAppBar');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);

    return StreamBuilder(
      stream: bloc.climateColorStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return AppBar(
              backgroundColor: snapshot.data,
              actions: [
                Tooltip(
                  message: 'Settings',
                  child: IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(SettingsPage.routeName),
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
  }
}

// ------------------------------- PersistHeaderWide -------------------------------
class PersistHeaderWide extends StatelessWidget {
  const PersistHeaderWide({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('PersistHeaderWide');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);

    return StreamBuilder<LocationClimate>(
      stream: bloc.forecastStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            LocationClimate climate = snapshot.data;

            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 65,
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  climate.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  DateFormat.yMd().format(climate.time),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                        color: Colors.white54,
                                        fontWeight: FontWeight.w300,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: StreamBuilder(
                    stream: bloc.todayForecastStream,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                        case ConnectionState.done:
                          String svgFile =
                              snapshot.data.weatherStateName.split(' ').join();
                          return Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 16.0),
                            child: SvgPicture.asset(
                                'assets/img/climate_status/$svgFile.svg'),
                          );
                          break;
                        default:
                          return Container();
                      }
                    },
                  ),
                ),
              ],
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ------------------------------ PersistHeaderNarrow ------------------------------
class PersistHeaderNarrow extends StatelessWidget {
  const PersistHeaderNarrow();
  @override
  Widget build(BuildContext context) {
    print('PersistHeaderNarrow');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);

    return StreamBuilder(
      stream: bloc.forecastStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            LocationClimate climate = snapshot.data;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 23),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 2,
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 65,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 3,
                                child: FittedBox(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    climate.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: FittedBox(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    DateFormat.yMd().format(climate.time),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          color: Colors.white54,
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: StreamBuilder(
                    stream: bloc.todayForecastStream,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                        case ConnectionState.done:
                          String svgFile =
                              snapshot.data.weatherStateName.split(' ').join();
                          return Container(
                            alignment: Alignment.centerRight,
                            child: SvgPicture.asset(
                              'assets/img/climate_status/$svgFile.svg',
                              fit: BoxFit.contain,
                              alignment: Alignment.centerRight,
                            ),
                          );
                          break;
                        default:
                          return Container();
                      }
                    },
                  ),
                ),
              ],
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ---------------------------- PersistHeaderLastUpdate ----------------------------
class PersistHeaderLastUpdate extends StatelessWidget {
  const PersistHeaderLastUpdate();
  @override
  Widget build(BuildContext context) {
    print('PersistHeaderLastUpdate');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);

    return StreamBuilder<ConsolidatedWeather>(
      stream: bloc.todayForecastStream,
      builder: (context, climateSnapshot) {
        switch (climateSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            DateTime time = climateSnapshot.data.created;

            return SizedBox(
              height: 24.0,
              width: MediaQuery.of(context).size.width / 2,
              child: FittedBox(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Updated ${_lastUpdate(time)}',
                  style: Theme.of(context)
                      .textTheme
                      .overline
                      .copyWith(color: Colors.white70),
                ),
              ),
            );
            break;
          default:
            return Container();
        }
      },
    );
  }

  String _lastUpdate(DateTime time) {
    String minuteStr(int minutes) => minutes > 1 ? 'minutes' : 'minute';
    String hourStr(int hours) => hours > 1 ? 'hours' : 'hour';
    String secondStr(int seconds) => seconds > 1 ? 'seconds' : 'second';

    time = time.toUtc();
    DateTime now = DateTime.now().toUtc();
    Duration diff = now.difference(time.toUtc());
    int days = diff.inDays;
    int hours = diff.inHours.remainder(Duration.hoursPerDay);
    int minutes = diff.inMinutes.remainder(Duration.minutesPerHour);
    int seconds = diff.inSeconds.remainder(Duration.secondsPerMinute);

    if (days > 1)
      return '$days days ago';
    else if (days == 1)
      return 'Yesterday';
    else if (hours >= 1)
      return '$hours ${hourStr(hours)}, $minutes ${minuteStr(minutes)} ago';
    else if (minutes >= 1)
      return '$minutes ${minuteStr(minutes)} ago';
    else
      return '$seconds ${secondStr(seconds)} ago';
  }
}
