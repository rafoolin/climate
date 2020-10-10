import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer();
  @override
  Widget build(BuildContext context) {
    // print('CustomDrawer');
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        children: [
          const CustomDrawerHeader(),
          const DrawerThemeTile(),
          const DrawerExpansionList(),
          const Divider(),
          const DrawerSettingTile(),
          const DrawerAboutTile(),
        ],
      ),
    );
  }
}

// ------------------------------- CustomDrawerHeader -------------------------------
class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader();
  @override
  Widget build(BuildContext context) {
    // print('CustomDrawerHeader');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    ForecastBloc forecastBloc = BlocProvider.of<ForecastBloc>(context);
    return StreamBuilder<ThemeData>(
      stream: prefBloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return StreamBuilder<Color>(
              stream: forecastBloc.climateColorStream,
              builder: (context, colorSnapshot) {
                switch (colorSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return DrawerHeader(
                      decoration: BoxDecoration(color: colorSnapshot.data),
                      child: SvgPicture.asset(
                        themeSnapshot.data.brightness == Brightness.dark
                            ? 'assets/img/logo/night_logo.svg'
                            : 'assets/img/logo/daylight_logo.svg',
                        width: 100,
                        height: 100,
                      ),
                    );
                    break;
                  default:
                    return Container();
                }
              },
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// -------------------------------- DrawerThemeTile --------------------------------
class DrawerThemeTile extends StatelessWidget {
  const DrawerThemeTile();

  @override
  Widget build(BuildContext context) {
    // print('DrawerThemeTile');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    ForecastBloc forecastBloc = BlocProvider.of<ForecastBloc>(context);
    ThemeData theme;
    bool isDark;
    return StreamBuilder<ThemeData>(
      stream: prefBloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            theme = themeSnapshot.data;
            isDark = theme.brightness == Brightness.dark;
            return StreamBuilder<Color>(
              stream: forecastBloc.climateColorStream,
              builder: (context, colorSnapshot) {
                switch (colorSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return ListTileTheme(
                      child: SwitchListTile(
                        activeColor: colorSnapshot.data,
                        title: Text('Theme'),
                        secondary: isDark
                            ? Icon(FontAwesomeIcons.moon)
                            : Icon(FontAwesomeIcons.solidSun),
                        value: isDark,
                        onChanged: (value) async {
                          await prefBloc.saveTheme(isDark: value);
                        },
                      ),
                      iconColor: theme.iconTheme.color,
                    );
                    break;
                  default:
                    return Container();
                }
              },
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ------------------------------ DrawerExpansionList ------------------------------
class DrawerExpansionList extends StatelessWidget {
  const DrawerExpansionList();
  @override
  Widget build(BuildContext context) {
    // print('DrawerExpansionList');
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);
    List<String> places = [];
    return StreamBuilder<List<String>>(
      stream: bloc.placesStream,
      builder: (BuildContext context, placesSnapshot) {
        switch (placesSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            places = placesSnapshot.data;
            return places.isEmpty
                ? const DrawerEmptyLocation()
                : DrawerPlacesTile(places: places);
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ------------------------------ DrawerEmptyLocation ------------------------------
class DrawerEmptyLocation extends StatelessWidget {
  const DrawerEmptyLocation();
  @override
  Widget build(BuildContext context) {
    // print('DrawerEmptyLocation');
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);
    return StreamBuilder<ThemeData>(
      stream: bloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return ExpansionTile(
              leading: Icon(FontAwesomeIcons.city),
              maintainState: true,
              title: Text('Locations'),
              children: [
                ListTileTheme(
                  child: ListTile(
                    title: Text('Add New Location'),
                    leading: Icon(FontAwesomeIcons.plus),
                    onTap: () =>
                        Navigator.of(context).pushNamed(LocationPage.routeName),
                  ),
                  iconColor: themeSnapshot.data.iconTheme.color,
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

// ------------------------------- DrawerPlacesTile --------------------------------
class DrawerPlacesTile extends StatelessWidget {
  final List<String> places;
  const DrawerPlacesTile({Key key, @required this.places}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print('DrawerPlacesTile');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    ForecastBloc forecastBloc = BlocProvider.of<ForecastBloc>(context);
    ThemeData theme;
    Color color;

    return StreamBuilder<ThemeData>(
      stream: prefBloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            theme = themeSnapshot.data;
            return StreamBuilder<String>(
              stream: prefBloc.locationStream,
              builder: (context, locationSnapshot) {
                switch (locationSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return StreamBuilder<Color>(
                      stream: forecastBloc.climateColorStream,
                      builder: (context, colorSnapshot) {
                        switch (colorSnapshot.connectionState) {
                          case ConnectionState.active:
                          case ConnectionState.done:
                            color = colorSnapshot.data;
                            //TODO: Nothing yet?
                            // Couldn't find any better solution to change
                            // ExpansionTile's active color,
                            // It seems like it only gets color from
                            // "accentColor"
                            return Theme(
                              data: theme.copyWith(accentColor: color),
                              child: ExpansionTile(
                                leading: Icon(FontAwesomeIcons.city),
                                maintainState: true,
                                title: Text('Locations'),
                                children: places
                                    .map(
                                      (place) => ListTile(
                                        title: Text(
                                          place,
                                          style: theme.textTheme.subtitle1,
                                        ),
                                        trailing: locationSnapshot.data
                                                    .compareTo(place) ==
                                                0
                                            ? Icon(
                                                Icons.my_location,
                                                color: color,
                                              )
                                            : null,
                                        onTap: () async => await prefBloc
                                            .saveLocation(location: place),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                            break;
                          default:
                            return Container();
                        }
                      },
                    );
                    break;
                  default:
                    return Container();
                }
              },
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ------------------------------- DrawerSettingTile -------------------------------
class DrawerSettingTile extends StatelessWidget {
  const DrawerSettingTile();
  @override
  Widget build(BuildContext context) {
    // print('DrawerSettingTile');
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);

    return StreamBuilder<ThemeData>(
      stream: bloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return ListTileTheme(
              child: ListTile(
                title: Text('Setting'),
                leading: Icon(FontAwesomeIcons.cog),
                onTap: () =>
                    Navigator.of(context).pushNamed(SettingsPage.routeName),
              ),
              iconColor: themeSnapshot.data.iconTheme.color,
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// -------------------------------- DrawerAboutTile --------------------------------
class DrawerAboutTile extends StatelessWidget {
  const DrawerAboutTile();
  @override
  Widget build(BuildContext context) {
    // print('DrawerAboutTile');
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);

    return StreamBuilder<ThemeData>(
      stream: bloc.themeStream,
      builder: (context, themeSnapshot) {
        switch (themeSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return ListTileTheme(
              child: CustomAboutDialog(
                applicationIcon: SvgPicture.asset(
                  'assets/img/logo/daylight_logo.svg',
                  width: 50.0,
                  height: 50.0,
                ),
                applicationName: 'Climate',
                applicationVersion: '1.0.0',
                child: Text('About'),
                icon: Icon(FontAwesomeIcons.infoCircle),
                applicationLegalese: 'Climate is a simple weather app!',
              ),
              iconColor: themeSnapshot.data.iconTheme.color,
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// ------------------------------- CustomAboutDialog -------------------------------
class CustomAboutDialog extends StatelessWidget {
  final Widget icon;
  final Widget child;
  final String applicationName;
  final String applicationVersion;
  final Widget applicationIcon;
  final String applicationLegalese;
  final bool dense;
  const CustomAboutDialog({
    this.icon,
    this.child,
    this.applicationName,
    this.applicationVersion,
    this.applicationIcon,
    this.applicationLegalese,
    this.dense,
  });

  @override
  Widget build(BuildContext context) {
    // print('CustomAboutDialog');
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);

    return ListTile(
      dense: dense,
      title: child ?? Text('About'),
      leading: icon,
      onTap: () {
        showDialog<void>(
          context: context,
          useSafeArea: true,
          child: AlertDialog(
            actions: <Widget>[
              FlatButton(
                child: Text(
                    MaterialLocalizations.of(context).viewLicensesButtonLabel),
                onPressed: () => Navigator.of(context).pushNamed(
                  CustomLicensePage.routeName,
                  arguments: {
                    'applicationName': applicationName,
                    'applicationVersion': applicationVersion,
                    'applicationIcon': applicationIcon,
                    'applicationLegalese': applicationLegalese,
                  },
                ),
              ),
              FlatButton(
                child: Text(MaterialLocalizations.of(context).closeButtonLabel),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    applicationIcon ?? Container(),
                    SizedBox(width: 24.0),
                    StreamBuilder<ThemeData>(
                      stream: bloc.themeStream,
                      builder: (context, themeSnapshot) {
                        switch (themeSnapshot.connectionState) {
                          case ConnectionState.active:
                          case ConnectionState.done:
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  applicationName ?? '',
                                  style: themeSnapshot.data.textTheme.headline5,
                                ),
                                Text(
                                  applicationVersion ?? '',
                                  style: themeSnapshot.data.textTheme.bodyText2,
                                )
                              ],
                            );
                            break;
                          default:
                            return Container();
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
                Text(applicationLegalese ?? '')
              ],
            ),
          ),
          useRootNavigator: true,
        );
      },
    );
  }
}
