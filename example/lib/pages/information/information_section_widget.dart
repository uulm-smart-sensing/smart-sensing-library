import 'package:flutter/material.dart';

class InformationSectionWidget extends StatelessWidget {
  /// The title of the section.
  ///
  /// For example 'License'.
  final String sectionTitle;

  /// The [content] of this information section, which
  /// should be only [Text] or [ListView], but can contain
  /// more complex text constructions too.
  final Widget content;

  const InformationSectionWidget({
    super.key,
    required this.sectionTitle,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    // Display the text, which represents the "title" of
    // this information section
    var header = Text(
      sectionTitle,
      textAlign: TextAlign.left,
      style: const TextStyle(fontSize: 24),
    );

    // Display the information (content) in a rounded, dynamic sized box
    var body = Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        // TODO: change the alpha from 100 to 255 to get correct color
        color: Color.fromARGB(100, 34, 0, 77),
      ),
      child: content,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(
            height: 10,
          ),
          body,
        ],
      ),
    );
  }
}
