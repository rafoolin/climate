import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/models/models.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Sources extends StatelessWidget {
  const Sources();
  @override
  Widget build(BuildContext context) {
    // print('ForecastDetailSunset');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    ForecastBloc forecastBloc = BlocProvider.of<ForecastBloc>(context);
    ThemeData theme;

    return StreamBuilder<ThemeData>(
      stream: prefBloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            theme = themeSnapshot.data;
            return StreamBuilder<LocationClimate>(
              stream: forecastBloc.forecastStream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    List<Source> sources = snapshot.data?.sources ?? [];
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Source source = sources[index];
                        return ListTile(
                          title: Text(
                            source.title,
                            style: theme.textTheme.subtitle2
                                .copyWith(fontSize: 12.0),
                          ),
                          subtitle: Text(
                            source.url,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                          ),
                          onTap: () async {
                            await canLaunch(source.url)
                                .then((value) async => await launch(source.url))
                                .catchError((onError) async {
                              await showDialog(
                                context: context,
                                child: AlertDialog(
                                  title: Text('Error!'),
                                  content: Text("Can't launch ${source.url}"),
                                  actions: [
                                    FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('Ok'),
                                    )
                                  ],
                                ),
                              );
                            });
                          },
                        );
                      },
                      itemCount: sources.length,
                    );
                    break;
                  default:
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      itemBuilder: (context, index) => ListTile(
                        title: Skeleton(height: 36.0),
                        trailing: Skeleton(width: 36.0, height: 36.0),
                      ),
                    );
                }
              },
            );
            break;
          default:
            return const Skeleton();
        }
      },
    );
  }
}
