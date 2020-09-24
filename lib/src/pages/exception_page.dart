import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/configs/configs.dart';
import 'package:climate/src/pages/pages.dart';
import 'package:climate/src/utils/utils.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExceptionPage extends StatefulWidget {
  final Exception exception;
  static const String routeName = "/ExceptionPage";

  const ExceptionPage({Key key, @required this.exception}) : super(key: key);

  @override
  _ExceptionPageState createState() => _ExceptionPageState();
}

class _ExceptionPageState extends State<ExceptionPage>
    with SingleTickerProviderStateMixin {
  ForecastBloc _forecastBloc;
  AnimationController _animationController;
  GlobalKey<ScaffoldState> _scaffoldKey;
  Animation<double> _value;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
    _forecastBloc = BlocProvider.of<ForecastBloc>(context)..fetchForecast();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..forward()
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) async {
            if (status == AnimationStatus.completed) {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text('No internet connection yet!'),
                  action: SnackBarAction(
                      label: 'Retry',
                      onPressed: () async {
                        _animationController.forward(from: 0.0);
                        await _forecastBloc.fetchForecast();
                      }),
                ),
              );
            }
          });

    _value = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: CustomColor.defaultColor,
        actions: [
          Tooltip(
            message: 'Settings',
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () =>
                  Navigator.of(context).pushNamed(SettingsPage.routeName),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            bottom: 00,
            left: 16.0,
            right: 16.0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.exception.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 24.0),
                AnimatedBuilder(
                  child: FlatButton.icon(
                    label: Text(
                      'Retry',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    icon: Icon(
                      FontAwesomeIcons.sync,
                      color: CustomColor.defaultColor,
                    ),
                    onPressed: () async {
                      _animationController.forward(from: 0.0);
                      await _forecastBloc.fetchForecast();
                    },
                  ),
                  animation: _value,
                  builder: (context, child) {
                    return _value.isCompleted
                        ? child
                        : CircularProgressIndicator(value: _value.value);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: ClipPath(
              clipper: Clipper(),
              child: Container(
                height: 120,
                color: CustomColor.defaultColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
