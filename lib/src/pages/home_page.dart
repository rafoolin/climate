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

    return StreamBuilder<ConsolidatedWeather>(
      stream: bloc.todayForecastStream,
      builder:
          (BuildContext context, AsyncSnapshot<ConsolidatedWeather> snapshot) {
        if (snapshot.hasError) {
          if (snapshot.error is EmptyLocationException) return EmptyPage();
          if (snapshot.error is NoInternetException)
            return ExceptionPage(exception: snapshot.error);
          return ExceptionPage(
            exception: Exception('Sorry something went wrong o _ O'),
          );
        }
        return Scaffold(
          drawer: const CustomDrawer(),
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                floating: false,
                delegate:
                    PersistHeader(height: MediaQuery.of(context).size.height),
                pinned: true,
              ),
              SliverToBoxAdapter(child: const SizedBox(height: 16.0)),
              SliverToBoxAdapter(child: const WeatherStatus()),
              SliverToBoxAdapter(child: const SizedBox(height: 16.0)),
              SliverToBoxAdapter(child: const WeekForecast()),
              SliverToBoxAdapter(child: const SizedBox(height: 48.0)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'DETAILS',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 30),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: const ForecastDetails()),
              SliverToBoxAdapter(child: const SizedBox(height: 36.0)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Sources',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 30),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: const Sources()),
            ],
          ),
        );
      },
    );
  }
}
