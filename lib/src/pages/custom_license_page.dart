import 'package:climate/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

// Doesn't like it
// But it overcome the Licence page default app bar to match the whole app!!
//TODO: Need a better Solution :(
class CustomLicensePage extends StatelessWidget {
  static const String routeName = "/CustomLicensePage";
  final String applicationName;
  final String applicationVersion;
  final Widget applicationIcon;
  final String applicationLegalese;

  CustomLicensePage({
    this.applicationName,
    this.applicationVersion,
    this.applicationIcon,
    this.applicationLegalese,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: LicensePage(
              applicationIcon: applicationIcon,
              applicationLegalese: applicationLegalese,
              applicationName: '\n\n\n$applicationName',
              applicationVersion: applicationVersion,
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: CustomAppBar(title: 'Licenses'),
          ),
        ],
      ),
    );
  }
}
