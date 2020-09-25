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

    return StreamBuilder<LocationClimate>(
      stream: bloc.forecastStream,
      builder: (BuildContext context, AsyncSnapshot<LocationClimate> snapshot) {
        if (snapshot.hasError) {
          if (snapshot.error is NoInternetException)
            return ExceptionPage(exception: snapshot.error);
          else if (snapshot.error is EmptyLocationException)
            return EmptyPage();
          else
            return ExceptionPage(
              exception: Exception('Sorry Some exception happened!'),
            );
        }
        return Scaffold(
          drawer: CustomDrawer(),
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                floating: false,
                delegate:
                    PersistHeader(height: MediaQuery.of(context).size.height),
                pinned: true,
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16.0)),
              SliverToBoxAdapter(child: const WeatherStatus()),
              SliverToBoxAdapter(child: SizedBox(height: 16.0)),
              SliverToBoxAdapter(child: const WeekForecast()),
              SliverToBoxAdapter(child: SizedBox(height: 48.0)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'DETAILS',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 30),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: const ForecastDetails()),
              SliverToBoxAdapter(child: SizedBox(height: 36.0)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Sources',
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
