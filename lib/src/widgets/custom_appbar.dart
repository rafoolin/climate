import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/utils/utils.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  const CustomAppBar({
    Key key,
    this.title = '',
    this.actions,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print('CustomAppBar');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    ForecastBloc forecastBloc = BlocProvider.of<ForecastBloc>(context);

    return SizedBox(
      height: 132.0,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: Clipper(),
              child: StreamBuilder<Color>(
                stream: forecastBloc.climateColorStream,
                builder: (context, colorSnapshot) {
                  switch (colorSnapshot.connectionState) {
                    case ConnectionState.active:
                    case ConnectionState.done:
                      return Container(
                        padding: EdgeInsets.only(left: 16.0, bottom: 48.0),
                        width: double.infinity,
                        color: colorSnapshot.data,
                      );
                      break;
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16.0,
            left: 16.0,
            child: Navigator.canPop(context)
                ? BackButton(color: Colors.white)
                : Container(),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 24.0,
            left: 72.0,
            child: StreamBuilder<ThemeData>(
              stream: prefBloc.themeStream,
              builder: (context, themeSnapshot) {
                switch (themeSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return Text(
                      title,
                      style: themeSnapshot.data.textTheme.headline6
                          .copyWith(color: Colors.white),
                    );
                    break;
                  default:
                    return const Skeleton();
                }
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16.0,
            right: 16.0,
            child: (actions != null)
                ? Row(
                    children: actions.map(
                      (e) {
                        return Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: e,
                        );
                      },
                    ).toList(),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
