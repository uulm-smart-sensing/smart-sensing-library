import 'package:flutter/material.dart';

import '../../general_widgets/smart_sensing_appbar.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget body = const Placeholder();
    return SmartSensingAppBar(
      title: "Information",
      subtitle: "\"Anwendungsprojekt SE\" of University of Ulm",
      body: body,
    );
  }
}
