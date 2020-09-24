import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/configs/configs.dart';
import 'package:climate/src/pages/pages.dart';
import 'package:climate/src/utils/utils.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = "/SplashPage";

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // fetch forecast for the current location
    BlocProvider.of<ForecastBloc>(context)..fetchForecast();
    AnimationController(vsync: this, duration: Duration(seconds: 2))
      ..forward()
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => HomePage()),
              (Route<dynamic> route) => false);
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipPath(
        clipper: Clipper(),
        child: Container(
          child: Center(
            child: Text(
              'Hello!',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.white),
            ),
          ),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * CustomRatio.maxRatio,
          color: CustomColor.yellow,
        ),
      ),
    );
  }
}
