import 'package:flutter/material.dart';

import '../../general_widgets/smart_sensing_appbar.dart';
import 'information_section_widget.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
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

    var licenseSection = const InformationSectionWidget(
      sectionTitle: "License",
      content: Text(
        "MIT",
        style: TextStyle(fontSize: 18),
      ),
    );

    var versionSection = const InformationSectionWidget(
      sectionTitle: "Version",
      content: Text(
        "0.2",
        style: TextStyle(fontSize: 18),
      ),
    );

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
