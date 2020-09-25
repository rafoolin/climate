import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/utils/utils.dart';
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
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    return SizedBox(
      height: 132.0,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: Clipper(),
              child: StreamBuilder<Color>(
                stream: bloc.climateColorStream,
                builder: (context, snapshot) {
                  return Container(
                    padding: EdgeInsets.only(left: 16.0, bottom: 48.0),
                    width: double.infinity,
                    color: snapshot.data,
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16.0,
            left: 16.0,
            child: Navigator.canPop(context) ? BackButton() : Container(),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 24.0,
            left: 72.0,
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16.0,
            right: 16.0,
            child: (actions != null)
                ? Row(
                    children: actions.map((e) {
                      return Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: e,
                      );
                    }).toList(),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
