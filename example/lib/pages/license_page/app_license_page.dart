import 'package:flutter/material.dart';

class AppLicensePage extends StatelessWidget {
const AppLicensePage({ super.key });

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context),
    child: LicensePage(
      applicationName: "Smart Sensing Library App",
      applicationVersion: "0.0.0",
      applicationIcon: const Padding(
        padding: EdgeInsets.all(8.0),
        child: FlutterLogo(),
      ),
      applicationLegalese: "© ${DateTime.now().year} Smart Sensing Library",
    ),
  );
}
