import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/exceptions/exceptions.dart';
import 'package:climate/src/models/models.dart';
import 'package:climate/src/pages/pages.dart';
import 'package:climate/src/widgets/sources.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String routeName = "/HomePage";
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);

    return Scaffold(
      drawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () async => Future.delayed(Duration(milliseconds: 200))
            .then((value) => bloc.fetchForecast()),
        child: StreamBuilder<ConsolidatedWeather>(
          stream: bloc.todayForecastStream,
          builder: (BuildContext context,
              AsyncSnapshot<ConsolidatedWeather> snapshot) {
            if (snapshot.hasError) {
              if (snapshot.error is EmptyLocationException)
                return const EmptyPage();
              if (snapshot.error is NoInternetException)
                return ExceptionPage(exception: snapshot.error);
              return ExceptionPage(
                exception: Exception('Sorry something went wrong o _ O'),
              );
            }
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  floating: false,
                  delegate: PersistHeader(
                    height: MediaQuery.of(context).size.height,
                  ),
                  pinned: true,
                ),
                SliverToBoxAdapter(child: const SizedBox(height: 16.0)),
                SliverToBoxAdapter(child: const WeatherStatus()),
                SliverToBoxAdapter(child: const SizedBox(height: 16.0)),
                SliverToBoxAdapter(child: const WeekForecast()),
                SliverToBoxAdapter(child: const SizedBox(height: 48.0)),
                SliverToBoxAdapter(child: const DetailsHeader()),
                SliverToBoxAdapter(child: const ForecastDetails()),
                SliverToBoxAdapter(child: const SizedBox(height: 36.0)),
                SliverToBoxAdapter(child: const SourcesHeader()),
                SliverToBoxAdapter(child: const Sources()),
              ],
            );
          },
        ),
      ),
    );
  }
}

// --------------------------------- DetailsHeader ---------------------------------
class DetailsHeader extends StatelessWidget {
  const DetailsHeader();
  @override
  Widget build(BuildContext context) {
    // print('DetailsHeader');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    return StreamBuilder<ThemeData>(
      stream: prefBloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'DETAILS',
                style: themeSnapshot.data.textTheme.headline4
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 30),
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

// --------------------------------- SourcesHeader ---------------------------------
class SourcesHeader extends StatelessWidget {
  const SourcesHeader();
  @override
  Widget build(BuildContext context) {
    // print('SourcesHeader');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    return StreamBuilder<ThemeData>(
      stream: prefBloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Sources',
                style: themeSnapshot.data.textTheme.headline4
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 30),
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
