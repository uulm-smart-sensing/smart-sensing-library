import 'package:flutter/material.dart';

import '../../general_widgets/smart_sensing_appbar.dart';
import '../home/device_widget.dart';
import '../import_export/import_export_page.dart';
import '../information/information_page.dart';
import '../sensor_search/sensor_search_page.dart';
import 'settings_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<SettingsWidget> settings = [
    const SettingsWidget(
      title: 'Sensors',
      subtitle: 'overview of all Sensors',
      icon: Icons.sensors,
      direction: SensorSearchPage(),
    ),
    const SettingsWidget(
      title: 'Devices',
      subtitle: 'overview of all usable devices',
      icon: Icons.devices_other,
      direction: DeviceWidget(),
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
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            subtitle: Text(
              settings[index].subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            leading: Icon(
              settings[index].icon,
              size: 35,
              color: const Color.fromARGB(255, 255, 255, 255),
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
