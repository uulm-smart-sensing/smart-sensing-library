import 'package:flutter/material.dart';

import '../../general_widgets/smart_sensing_appbar.dart';
import '../home/home_page.dart';
import '../import_export/import_export_page.dart';
import '../information/information_page.dart';
import '../preview_settings/preview_settings_page.dart';
import '../license_page/app_license_page.dart';
import '../preview_settings/preview_settings_page.dart';
import '../sensor_search/sensor_search_page.dart';
import 'settings_widget.dart';

/// This List contains all possible Settings which the User can navigate
final List<SettingsWidget> settings = [
  const SettingsWidget(
    title: 'Sensors',
    subtitle: 'overview of all Sensors',
    icon: Icons.sensors,
    direction: SensorSearchPage(),
  ),
  const SettingsWidget(
    title: 'Previews',
    subtitle: 'preview controll of home page',
    icon: Icons.preview,
    direction: PreviewSettingsPage(),
  ),
  const SettingsWidget(
    title: 'Import/Export',
    subtitle: 'import & export of Sensor Data',
    icon: Icons.ios_share_outlined,
    direction: ImportExportPage(),
  ),
  const SettingsWidget(
    title: 'Info',
    subtitle: 'other information about the app',
    icon: Icons.info,
    direction: InformationPage(),
  ),
  const SettingsWidget(
    title: 'License',
    subtitle: 'license of the app',
    icon: Icons.description_outlined,
    direction: AppLicensePage(),
  ),
];

///Page provide an overview of all possible settings and further information.
///
///This [SettingsPage] is reachable through the [HomePage].
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  /// Widget that display the list of Settings on the Page
  @override
  Widget build(BuildContext context) => SmartSensingAppBar(
        title: "Settings",
        body: ListView(
          padding: const EdgeInsets.all(25.0),
          children: settings,
        ),
      );
}
