import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/configs/configs.dart';
import 'package:climate/src/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Only portrait orientation is accepted
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    PreferencesBloc prefBloc = PreferencesBloc()
      ..fetchTheme()
      ..fetchLocation()
      ..fetchTimezone()
      ..fetchTemperature()
      ..fetchDistance()
      ..fetchPressure()
      ..fetchWind()
      ..fetchPlaces();
    ForecastBloc forecastBloc = ForecastBloc(preferencesBloc: prefBloc);
    return BlocProvider(
      bloc: prefBloc,
      child: BlocProvider(
        bloc: forecastBloc,
        child: StreamBuilder<ThemeData>(
          stream: prefBloc.themeStream,
          builder: (context, themeSnapshot) {
            return MaterialApp(
              theme: themeSnapshot.data ?? lightTheme,
              onGenerateRoute: _onGenerateRoute,
            );
          },
        ),
      ),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {

      // HomePage
      case HomePage.routeName:
        return MaterialPageRoute(
          builder: (BuildContext context) => const HomePage(),
        );
        break;

      // SettingsPage
      case SettingsPage.routeName:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SettingsPage(),
        );
        break;
      // LocationPage
      case LocationPage.routeName:
        return MaterialPageRoute(
          builder: (BuildContext context) => const LocationPage(),
        );
        break;
      // LocationConfigPage
      case LocationConfigPage.routeName:
        return MaterialPageRoute(
          builder: (BuildContext context) => const LocationConfigPage(),
        );
        break;
      // TempPage
      case TempPage.routeName:
        return MaterialPageRoute(
          builder: (BuildContext context) => const TempPage(),
        );
        break;
      // WindPage
      case WindPage.routeName:
        return MaterialPageRoute(
          builder: (BuildContext context) => const WindPage(),
        );
        break;
      // PressurePage
      case PressurePage.routeName:
        return MaterialPageRoute(
          builder: (BuildContext context) => const PressurePage(),
        );
        break;
      // DistancePage
      case DistancePage.routeName:
        return MaterialPageRoute(
          builder: (BuildContext context) => const DistancePage(),
        );
        break;
      // TimezonePage
      case TimezonePage.routeName:
        return MaterialPageRoute(
          builder: (BuildContext context) => const TimezonePage(),
        );
        break;
      // EmptyPage
      case EmptyPage.routeName:
        return MaterialPageRoute(
          builder: (BuildContext context) => const EmptyPage(),
        );
        break;
      // CustomLicensePage
      case CustomLicensePage.routeName:
        Map args = settings.arguments;
        return MaterialPageRoute(
          builder: (BuildContext context) => CustomLicensePage(
            applicationIcon: args['applicationIcon'],
            applicationLegalese: args['applicationLegalese'],
            applicationName: args['applicationName'],
            applicationVersion: args['applicationVersion'],
          ),
        );

      // ExceptionPage
      case ExceptionPage.routeName:
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              ExceptionPage(exception: settings.arguments),
        );
        break;
      // default
      // SplashPage
      case SplashPage.routeName:
      default:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashPage(),
        );
    }
  }
}
