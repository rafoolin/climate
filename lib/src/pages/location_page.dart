import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/pages/pages.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LocationPage extends StatelessWidget {
  static const String routeName = "/LocationPage";
  const LocationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('LocationPage');
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CustomAppBar(
              title: 'Locations',
              actions: [
                Tooltip(
                  message: 'Add new locations',
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
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
                    .copyWith(fontSize: 17.0),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: const SizedBox(height: 24.0)),
          const SliverToBoxAdapter(child: const LocationPagePlaces()),
        ],
      ),
    );
  }
}

// ------------------------------- LocationPagePlaces -------------------------------
class LocationPagePlaces extends StatelessWidget {
  const LocationPagePlaces();
  @override
  Widget build(BuildContext context) {
    // print('LocationPagePlaces');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    List<String> places = [];

    return StreamBuilder<List<String>>(
      stream: prefBloc.placesStream,
      builder: (BuildContext context, placesSnapshot) {
        switch (placesSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            places = placesSnapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: places.length,
              itemBuilder: (context, index) {
                return LocationPageTile(place: places[index]);
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

// -------------------------------- LocationPageTile --------------------------------
class LocationPageTile extends StatelessWidget {
  final String place;

  const LocationPageTile({Key key, this.place}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print('LocationPageTile');
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    ForecastBloc forecastBloc = BlocProvider.of<ForecastBloc>(context);

    return StreamBuilder<String>(
      stream: prefBloc.locationStream,
      builder: (context, locationSnapshot) {
        switch (locationSnapshot.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
            return StreamBuilder<Color>(
              stream: forecastBloc.climateColorStream,
              builder: (context, colorSnapshot) {
                switch (colorSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(Icons.delete_sweep),
                        ),
                      ),
                      key: Key(place),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
                        title: Text(place),
                        trailing:
                            // If the current saved location is same as title,
                            // show a location icon beside the title.
                            locationSnapshot.data.compareTo(place) == 0
                                ? Icon(
                                    Icons.my_location,
                                    color: colorSnapshot.data,
                                  )
                                : null,
                        onTap: () async =>
                            await prefBloc.saveLocation(location: place).then(
                                  (value) => Scaffold.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: RichText(
                                          text: TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .button
                                                .copyWith(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w200,
                                                ),
                                            text: 'Set ',
                                            children: [
                                              TextSpan(
                                                text: '$place ',
                                                style: TextStyle(
                                                  color: Color(0xffe4ce0f),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: 'as current location!',
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ),
                      ),
                      onDismissed: (direction) async =>
                          // If dismissed an location, remove it from saved places.
                          await prefBloc.delPlace(title: place),
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
