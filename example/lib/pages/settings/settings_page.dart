import 'package:flutter/material.dart';

import '../../general_widgets/smart_sensing_appbar.dart';
import '../../theme.dart';
import '../home/home_page.dart';
import '../import_export/import_export_page.dart';
import '../information/information_page.dart';
import '../sensor_search/sensor_search_page.dart';
import 'settings_widget.dart';

///Page provide an overview of all possible settings and further information.
///
///This [SettingsPage] is reachable through the [HomePage].
class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  /// This List contains all possible Settings which the User can navigate
  final List<SettingsWidget> settings = [
    const SettingsWidget(
      title: 'Sensors',
      subtitle: 'overview of all Sensors',
      icon: Icons.sensors,
      direction: SensorSearchPage(),
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
  ];

  /// Widget that display the list of Settings on the Page
  @override
  Widget build(BuildContext context) {
    Widget body = ListView.builder(
      padding: const EdgeInsets.all(25.0),
      itemCount: settings.length,
      itemBuilder: (context, index) => Column(
        children: <Widget>[
          ListTile(
            title: Text(
              settings[index].title,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            subtitle: Text(
              settings[index].subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            leading: Icon(
              settings[index].icon,
              size: 35,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => settings[index].direction,
                ),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );

    return SmartSensingAppBar(title: "Settings", body: body);
  }
}
