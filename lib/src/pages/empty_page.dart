import 'package:climate/src/configs/configs.dart';
import 'package:climate/src/pages/pages.dart';
import 'package:climate/src/utils/utils.dart';
import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmptyPage extends StatelessWidget {
  static const String routeName = "/EmptyPage";

  const EmptyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: CustomColor.defaultColor,
        actions: [
          Tooltip(
            message: 'Settings',
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () =>
                  Navigator.of(context).pushNamed(SettingsPage.routeName),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            bottom: 00,
            left: 16.0,
            right: 16.0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Empty Location!',
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 24.0),
                FlatButton.icon(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(LocationPage.routeName),
                  icon: Icon(FontAwesomeIcons.plus),
                  label: Text('Add/Choose a Location'),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: ClipPath(
              clipper: Clipper(),
              child: Container(
                height: 120,
                color: CustomColor.defaultColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
