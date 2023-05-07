import 'package:flutter/material.dart';

import './information_page.dart';
import '../../theme/theme.dart';

/// Widget displaying a information section.
///
/// This means, this widget will display a unit containing
/// * a [_sectionTitle] - showing the topic of this section
/// * as well as [_content] below the [_sectionTitle] -
/// showing all the information related to the topic.
///
/// For example the current license could be showed by this
/// [InformationSectionWidget]:
///
/// 'License' (= [_sectionTitle])
/// MIT (= [_content])
///
/// This [InformationSectionWidget] can be used on the [InformationPage]
/// to display the several information.
class InformationSectionWidget extends StatelessWidget {
  /// The title of the section.
  ///
  /// For example 'License'.
  final String _sectionTitle;

  /// The [_content] of this information section, which
  /// should be only [Text] or [ListView], but can contain
  /// more complex text constructions too.
  final Widget _content;

  const InformationSectionWidget({
    super.key,
    required String sectionTitle,
    required Widget content,
  })  : _content = content,
        _sectionTitle = sectionTitle;

  @override
  Widget build(BuildContext context) {
    // Display the text, which represents the "title" of
    // this information section
    var header = Text(
      _sectionTitle,
      textAlign: TextAlign.left,
      style: const TextStyle(fontSize: 24),
    );

    // Display the information (content) in a rounded, dynamic sized box
    var body = Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: secondaryColor,
      ),
      child: _content,
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
