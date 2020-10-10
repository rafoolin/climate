import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LocationConfigPage extends StatelessWidget {
  static const String routeName = "/LocationConfigPage";
  const LocationConfigPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: const CustomAppBar(title: 'Config Locations'),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 24.0)),
          SliverToBoxAdapter(child: const SearchField()),
          SliverToBoxAdapter(child: const SearchResult()),
        ],
      ),
    );
  }
}

// ---------------------------------- SearchField ----------------------------------
class SearchField extends StatelessWidget {
  const SearchField();
  @override
  Widget build(BuildContext context) {
    // print('SearchField');
    TextEditingController _searchCtrl = TextEditingController(text: '');
    ForecastBloc bloc = BlocProvider.of<ForecastBloc>(context)..clearSearch();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchCtrl,
        decoration: InputDecoration(
          labelText: 'Search for a location',
          hintText: 'like: london',
        ),
        onChanged: (query) async =>
            await Future.delayed(Duration(milliseconds: 200))
                .then((value) async {
          if (_searchCtrl.text.isNotEmpty)
            bloc.locationSearch(query: _searchCtrl.text);
        }),
        // onSubmitted: (value) async {
        //   if (value.isNotEmpty) {
        //     await _forecastBloc.locationSearch(query: _searchCtrl.text);
        //   }
        // },
      ),
    );
  }
}

// ---------------------------------- SearchResult ----------------------------------
class SearchResult extends StatelessWidget {
  const SearchResult();
  @override
  Widget build(BuildContext context) {
    // print('SearchResult');
    ForecastBloc forecastBloc = BlocProvider.of<ForecastBloc>(context)
      ..clearSearch();
    PreferencesBloc prefBloc = BlocProvider.of<PreferencesBloc>(context);
    List<String> names = [];
    Map<String, bool> placesMap;
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
                    return StreamBuilder<Map<String, bool>>(
                      initialData: {},
                      stream: forecastBloc.searchedLocationsStream,
                      builder: (BuildContext context, searchSnapshot) {
                        // When there is an error show some notes
                        if (searchSnapshot.hasError) {
                          SchedulerBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            Scaffold.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    searchSnapshot.error.toString(),
                                  ),
                                ),
                              );
                          });
                        }
                        switch (searchSnapshot.connectionState) {
                          case ConnectionState.active:
                          case ConnectionState.done:
                            placesMap = searchSnapshot.data ?? {};
                            names = placesMap.keys.toList();
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: placesMap?.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  CheckboxListTile(
                                value: placesMap[names[index]],
                                title: Text(names[index]),
                                activeColor: colorSnapshot.data,
                                // Avoid user change current location status
                                onChanged: (names[index]
                                            .compareTo(locationSnapshot.data) ==
                                        0)
                                    ? null
                                    : (value) async => await forecastBloc
                                        .changePlaceStatus(
                                          title: names[index],
                                          chosen: value,
                                        )
                                        .then(
                                          (_) async => await Future.delayed(
                                            Duration(milliseconds: 500),
                                          ),
                                        ),
                              ),
                              separatorBuilder: (context, index) =>
                                  const Divider(),
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
