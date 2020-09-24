import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/pages/pages.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  static const String routeName = "/LocationPage";
  const LocationPage({Key key}) : super(key: key);
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  PreferencesBloc _preferencesBloc;
  ThemeData _theme;
  List<String> _places;
  bool _isDark = false;
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    _preferencesBloc = BlocProvider.of<PreferencesBloc>(context)..fetchPlaces();
    _scaffoldKey = GlobalKey();
    _places = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('location page');
    _theme = Theme.of(context);
    _isDark = _theme.brightness == Brightness.dark;
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CustomAppBar(
              title: 'Locations',
              actions: [
                Tooltip(
                  message: 'Add new locations',
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => Navigator.of(context)
                        .pushNamed(LocationConfigPage.routeName),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Choose a location from your favorite list',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontSize: 18.0),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.0)),
          _locationList(),
        ],
      ),
    );
  }

  Widget _locationList() {
    print('location page1');
    return StreamBuilder<List<String>>(
      stream: _preferencesBloc.placesStream,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            _places = snapshot.data;
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => GestureDetector(
                        onTap: () async =>
                            // Change user fav location to the tapped one
                            // then show a snackbar.
                            await _preferencesBloc
                                .saveLocation(location: _places[index])
                                .then(
                                  (value) => _scaffoldKey.currentState
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(_snackBar(_places[index])),
                                ),
                        child: DismissiblePlace(title: _places[index]),
                      ),
                  childCount: _places.length),
            );
            break;
          case ConnectionState.waiting:
          case ConnectionState.none:
          default:
            return SliverToBoxAdapter();
        }
      },
    );
  }

  Widget _snackBar(String location) {
    return SnackBar(
      content: RichText(
        text: TextSpan(
          style: _theme.textTheme.button.copyWith(
            color: _isDark ? Colors.white70 : Colors.white,
            fontWeight: FontWeight.w300,
          ),
          text: 'Set ',
          children: [
            TextSpan(
              text: '$location ',
              style: TextStyle(
                color: Color(0xffe4ce0f),
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(text: 'as current location!')
          ],
        ),
      ),
    );
  }
}

class DismissiblePlace extends StatelessWidget {
  final String title;
  const DismissiblePlace({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('DismissiblePlace');
    PreferencesBloc bloc = BlocProvider.of<PreferencesBloc>(context);
    String currentLocation;
    return StreamBuilder(
      stream: bloc.locationStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
            currentLocation = snapshot.data;
            return Dismissible(
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                color: Colors.red,
                child: Icon(Icons.delete_sweep),
              ),
              key: ObjectKey(title),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
                title: Text(title),
                trailing:
                    // If the current saved location is same as title,
                    // show a location icon beside the title.
                    currentLocation.compareTo(title) == 0
                        ? Icon(Icons.my_location)
                        : null,
              ),
              onDismissed: (direction) async =>
                  // If dismissed an location, remove it from saved places.
                  await bloc.delPlace(title: title),
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}
