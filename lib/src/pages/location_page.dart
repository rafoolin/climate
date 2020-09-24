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
  String _currentLocation;
  // ThemeData _theme;
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
    // _theme = Theme.of(context);
    // _isDark = _theme.brightness == Brightness.dark;
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
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.0)),
          SliverToBoxAdapter(child: _locationList()),
        ],
      ),
    );
  }

  Widget _locationList() {
    return StreamBuilder<Map<String, dynamic>>(
      stream: _preferencesBloc.currentLocationPlacesStream,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            _places = snapshot.data['places'];
            _currentLocation = snapshot.data['current'];

            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _places.length,
              itemBuilder: (BuildContext context, int index) =>
                  _locationWidget(index),
              separatorBuilder: (context, index) => Divider(height: 0.0),
            );
            break;
          case ConnectionState.waiting:
          case ConnectionState.none:
          default:
            return Container();
        }
      },
    );
  }

  Widget _locationWidget(int index) {
    String title = _places[index];
    return GestureDetector(
      onTap: () async =>
          // Change user fav location to the tapped one
          // then show a snackbar.
          await _preferencesBloc.saveLocation(location: title).then(
                (value) => _scaffoldKey.currentState
                  ..hideCurrentSnackBar()
                  ..showSnackBar(_snackBar(title)),
              ),
      child: Dismissible(
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
              _currentLocation.compareTo(title) == 0
                  ? Icon(Icons.my_location)
                  : null,
        ),
        onDismissed: (direction) async =>
            // If dismissed an location, remove it from saved places.
            await _preferencesBloc.delPlace(title: title),
      ),
    );
  }

  Widget _snackBar(String location) {
    return SnackBar(
      content: RichText(
        text: TextSpan(
          // style: _theme.textTheme.button.copyWith(
          //   color: _isDark ? Colors.white70 : Colors.white,
          //   fontWeight: FontWeight.w300,
          // ),
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