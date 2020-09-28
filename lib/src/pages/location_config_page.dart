import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LocationConfigPage extends StatefulWidget {
  static const String routeName = "/LocationConfigPage";
  @override
  _LocationConfigPageState createState() => _LocationConfigPageState();
}

class _LocationConfigPageState extends State<LocationConfigPage> {
  GlobalKey<ScaffoldState> _globalKey;
  ForecastBloc _forecastBloc;
  TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _globalKey = GlobalKey();
    _forecastBloc = BlocProvider.of<ForecastBloc>(context);
    _searchCtrl = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    print('LocationConfigPage');

    return Scaffold(
      key: _globalKey,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: const CustomAppBar(title: 'Config Locations'),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.0)),
          SliverToBoxAdapter(
            child: Padding(
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
                    _forecastBloc.locationSearch(query: _searchCtrl.text);
                }),
                // onSubmitted: (value) async {
                //   if (value.isNotEmpty) {
                //     await _forecastBloc.locationSearch(query: _searchCtrl.text);
                //   }
                // },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder(
              stream: _forecastBloc.climateColorStream,
              builder: (context, AsyncSnapshot<Color> colorSnapshot) {
                switch (colorSnapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return StreamBuilder<Map<String, bool>>(
                      initialData: {},
                      stream: _forecastBloc.searchedLocationsStream,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<Map<String, bool>> snapshot,
                      ) {
                        // When there is an error show some notes
                        //TODO: better handling is needed!
                        if (snapshot.hasError) {
                          SchedulerBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            _globalKey.currentState
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(snapshot.error.toString()),
                                ),
                              );
                          });
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.active:
                          case ConnectionState.done:
                            Map<String, bool> placesMap = snapshot.data ?? {};
                            List<String> names = placesMap.keys.toList();

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: placesMap?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CheckboxListTile(
                                  value: placesMap[names[index]],
                                  title: Text(names[index]),
                                  activeColor: colorSnapshot.data,
                                  onChanged: (value) async =>
                                      await _forecastBloc.changePlaceStatus(
                                    title: names[index],
                                    chosen: value,
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                            );
                            break;
                          case ConnectionState.waiting:
                          case ConnectionState.none:
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
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // clear search results
    _forecastBloc.clearSearch();
  }
}
