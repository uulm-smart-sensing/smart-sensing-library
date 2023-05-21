import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../favorite_provider.dart';
import '../../general_widgets/app_bar_with_header.dart';
import '../../general_widgets/device_name_title.dart';
import '../../general_widgets/stylized_container.dart';
import 'checkbox_with_text.dart';
import 'sensor_search_page_sensor_list.dart';

/// Page to (de-)activate sensor tracking, mark sensors as favorites, search
/// for sensors and hide not available sensors.
class SensorSearchPage extends StatefulWidget {
  const SensorSearchPage({super.key});

  @override
  State<SensorSearchPage> createState() => _SensorSearchPageState();
}

class _SensorSearchPageState extends State<SensorSearchPage> {
  final _controller = TextEditingController();
  var sensorNameFilter = "";
  var showOnlyAvailableSensors = false;
  var availableSensors = <SensorId>[];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FavoriteProvider>(context);

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const DeviceNameTitle(
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        CheckBoxWithText(
          text: "Only show available",
          isChecked: showOnlyAvailableSensors,
          onPressed: (isChecked) async {
            availableSensors = await IOManager().getAvailableSensors();
            setState(() {
              showOnlyAvailableSensors = isChecked;
            });
          },
        ),
      ],
    );

    // Fetch sensors which should be displayed
    var sensorIdsToDisplay = SensorId.values.where(
      (id) => !showOnlyAvailableSensors || availableSensors.contains(id),
    );

    var searchBar = StylizedContainer(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            size: 30,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              cursorColor: Colors.white,
              onChanged: (newText) {
                setState(() {
                  sensorNameFilter = newText;
                });
              },
            ),
          ),
        ],
      ),
    );

    var favoritesHeader = const Text(
      "Favorites",
      style: TextStyle(
        fontSize: 24,
      ),
    );

    /// show all Favorites
    var favoritesBody = _getSensorsListFromIds(
      sensorIds: sensorIdsToDisplay
          .where((id) => provider.sensorList.contains(id))
          .toList(),
      containerFlex: provider.sensorList.length,
      sensorNameFilter: sensorNameFilter,
      provider: provider,
      noSensorsText: sensorNameFilter.isEmpty
          ? "No sensors marked as favorite."
          : "No sensor marked as favorite matches the search string.",
    );

    var allSensorsHeader = const Text(
      "All",
      style: TextStyle(
        fontSize: 24,
      ),
    );
    // Show all sensors that are not favorites
    var allSensors = sensorIdsToDisplay
        .where((id) => !provider.sensorList.contains(id))
        .toList();
    var allSensorsBody = _getSensorsListFromIds(
      sensorIds: allSensors,
      containerFlex: allSensors.length,
      sensorNameFilter: sensorNameFilter,
      provider: provider,
      noSensorsText: sensorNameFilter.isEmpty
          ? "No sensors available."
          : "No sensor matches the search string.",
    );
    return GestureDetector(
      onTap: () {
        var currentFocus = FocusScope.of(context);
        // Remove focus of search bar when page is tapped outside of search bar
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBarWithHeader(titleText: "Sensors", header: header),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              searchBar,
              const SizedBox(height: 10),
              favoritesHeader,
              favoritesBody,
              allSensorsHeader,
              allSensorsBody,
            ],
          ),
        ),
      ),
    );
  }

  /// Creates [ListView] from the passed [sensorIds].
  ///
  /// Filters out all ids with a name that doesn't contains the passed
  /// [sensorNameFilter] (for that [sensorNameFilter] must be not empty).
  Widget _getSensorsListFromIds({
    required List<SensorId> sensorIds,
    required String sensorNameFilter,
    String noSensorsText = "No sensors.",
    required FavoriteProvider provider,
    required int containerFlex,
  }) {
    var sensorWidgets = sensorIds
        .where(
          (id) =>
              sensorNameFilter == "" ||
              id.name.toLowerCase().contains(sensorNameFilter.toLowerCase()),
        )
        .map(
          (id) => [
            SensorSearchPageSensorListElement(sensorId: id, provider: provider),
            const SizedBox(height: 10)
          ],
        )
        .expand((element) => element)
        .toList();

    if (sensorWidgets.isEmpty) {
      sensorWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Center(
            child: Text(
              noSensorsText,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }

    return Expanded(
      flex: max(containerFlex, 1),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: sensorWidgets),
        ),
      ),
    );
  }
}
