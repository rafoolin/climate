import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer();
  @override
  Widget build(BuildContext context) {
    print('CustomDrawer');
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        children: [
          const CustomDrawerHeader(),
          const DrawerThemeTile(),
          const DrawerExpansionList(),
          const Divider(),
          ListTileTheme(
            child: ListTile(
              title: Text('Setting'),
              leading: Icon(FontAwesomeIcons.cog),
              onTap: () =>
                  Navigator.of(context).pushNamed(SettingsPage.routeName),
            ),
            iconColor: Theme.of(context).iconTheme.color,
          ),
          ListTileTheme(
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
            iconColor: Theme.of(context).iconTheme.color,
          ),
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
    print('CustomDrawerHeader');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context);
    return StreamBuilder(
      stream: bloc.climateColorStream,
      builder: (BuildContext context, AsyncSnapshot<Color> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return DrawerHeader(
              decoration: BoxDecoration(color: snapshot.data),
              child: SvgPicture.asset(
                Theme.of(context).brightness == Brightness.dark
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
  }
}

// ------------------------------ DrawerExpansionList ------------------------------
class DrawerExpansionList extends StatelessWidget {
  const DrawerExpansionList();
  @override
  Widget build(BuildContext context) {
    print('DrawerExpansionList');
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context)
      ..fetchPlaces();
    return StreamBuilder<List<String>>(
      stream: bloc.placesStream,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            List<String> places = snapshot.data;

            return ExpansionTile(
              leading: Icon(FontAwesomeIcons.city),
              maintainState: true,
              title: Text('Locations'),
              children: places.isEmpty
                  ? [
                      ListTileTheme(
                        child: ListTile(
                          title: Text('Add New Location'),
                          leading: Icon(FontAwesomeIcons.plus),
                          onTap: () => Navigator.of(context)
                              .pushNamed(LocationPage.routeName),
                        ),
                        iconColor: Theme.of(context).iconTheme.color,
                      )
                    ]
                  : places
                      .map(
                        (place) => DrawerPlaceTile(place: place),
                      )
                      .toList(),
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}

// -------------------------------- DrawerPlaceTile --------------------------------
class DrawerPlaceTile extends StatelessWidget {
  final String place;

  const DrawerPlaceTile({Key key, @required this.place}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);

    return StreamBuilder(
      stream: bloc.locationStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            return ListTile(
              title: Text(place, style: Theme.of(context).textTheme.subtitle1),
              trailing: snapshot.data.compareTo(place) == 0
                  ? Icon(
                      Icons.my_location,
                      color: Theme.of(context).accentColor,
                    )
                  : null,
              onTap: () async => await bloc.saveLocation(location: place),
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
    print('DrawerThemeTile');
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);
    return StreamBuilder(
      stream: bloc.themeStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<bool> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
            return ListTileTheme(
              child: SwitchListTile(
                activeColor: Theme.of(context).accentColor,
                title: Text('Theme'),
                secondary: snapshot.data
                    ? Icon(FontAwesomeIcons.moon)
                    : Icon(FontAwesomeIcons.solidSun),
                value: snapshot.data,
                onChanged: (value) async {
                  await bloc.saveTheme(isDark: value);
                },
              ),
              iconColor: Theme.of(context).iconTheme.color,
            );
            break;
          case ConnectionState.waiting:
          default:
            return Center(child: CircularProgressIndicator());
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
    print('About');
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
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          applicationName ?? '',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          applicationVersion ?? '',
                          style: Theme.of(context).textTheme.bodyText2,
                        )
                      ],
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
