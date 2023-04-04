import 'package:flutter/material.dart';

import '../settings/settings_page.dart';

import '../../general_widgets/smart_sensing_appbar.dart';
import 'information_section_widget.dart';

/// Page containing all useful information about the demo app and the
/// smart sensing library.
///
/// This [InformationPage] shows different sections which contain
/// information about several topics:
/// * device-specific information, like the current OS
/// * license ...
/// * version ....
/// * the developer of demo app and smart sensing library.
///
/// If further information become interesting and should be accessable by the
/// user, they should be displayed on this [InformationPage].
///
/// This [InformationPage] is reachable through the [SettingsPage].
class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The section containing the aggregated information of the device,
    // this demo app is running on.
    //
    // So for example, this section display information about the current OS
    // and the current amount of free storage.
    var deviceSection = InformationSectionWidget(
      sectionTitle: "Device information",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "OS version: ",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            "  \u2022 TODO: get current OS version",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Free storage: ",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            "  \u2022 TODO: get current free storage",
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );

    // The section containing the license for this demo app and
    // the smart sensing library.
    var licenseSection = const InformationSectionWidget(
      sectionTitle: "License",
      content: Text(
        "MIT",
        style: TextStyle(fontSize: 18),
      ),
    );

    // The section containing the current version of the demo app and
    // the smart sensing library.
    var versionSection = const InformationSectionWidget(
      sectionTitle: "Version",
      content: Text(
        "0.2",
        style: TextStyle(fontSize: 18),
      ),
    );

    // The section containing the names of the developer of
    // the smart sensing library.
    var developerSection = InformationSectionWidget(
      sectionTitle: "Developer",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "\u2022 Felix Schlegel",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            "\u2022 Hermann Fröhlich",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            "\u2022 Florian Gebhardt",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            "\u2022 Mukhtar Muse",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            "\u2022 Leonhard Alkewitz",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );

    // Widget that display the list of information on the page.
    Widget body = ListView(
      children: <Widget>[
        deviceSection,
        licenseSection,
        versionSection,
        developerSection,
      ],
    );

    return SmartSensingAppBar(
      title: "Information",
      subtitle: "\"Anwendungsprojekt SE\" of University of Ulm",
      body: body,
    );
  }
}
