import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/smart_sensing_appbar.dart';
import '../settings/settings_page.dart';
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
        children: [
          Text(
            "OS version: ",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          _getOSInformation(),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Free storage: ",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          _getStorageInformation(),
        ],
      ),
    );

    // The section containing the license for this demo app and
    // the smart sensing library.
    var licenseSection = InformationSectionWidget(
      sectionTitle: "License",
      content: Text(
        "MIT",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );

    // The section containing the current version of the demo app and
    // the smart sensing library.
    var versionSection = InformationSectionWidget(
      sectionTitle: "Version",
      content: Text(
        "0.2",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );

    // The section containing the names of the developer of
    // the smart sensing library.
    var developerSection = InformationSectionWidget(
      sectionTitle: "Developer",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• Felix Schlegel",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            "• Hermann Fröhlich",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            "• Florian Gebhardt",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            "• Mukhtar Muse",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            "• Leonhard Alkewitz",
            style: Theme.of(context).textTheme.bodyMedium,
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

  /// Fetches the information about the OS of this device
  /// and builds a [Text] widget with it.
  Widget _getOSInformation() => FutureBuilder(
        future: getOSVersion(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
              snapshot.data!,
              style: Theme.of(context).textTheme.bodyMedium,
            );
          }

          if (snapshot.hasError) {
            return const Text(
              "Error occured while getting information about current OS",
            );
          }

          return const Text("Information about OS is being fetched ...");
        },
      );

  /// Fetches the information about the free storage on this device
  /// and builds a [Text] widget with it.
  Widget _getStorageInformation() => FutureBuilder(
        future: getFreeStorage(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
              snapshot.data!,
              style: Theme.of(context).textTheme.bodyMedium,
            );
          }

          if (snapshot.hasError) {
            return const Text(
              "Error occured while getting information about free storage",
            );
          }

          return const Text("Information about storage is being fetched ...");
        },
      );
}
