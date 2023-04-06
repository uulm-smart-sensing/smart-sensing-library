import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/device_name_title.dart';
import '../../general_widgets/stylized_container.dart';
import '../../theme.dart';
import 'sensor_toggle_list_element.dart';

class SensorSearchPage extends StatefulWidget {
  const SensorSearchPage({super.key});

  @override
  State<SensorSearchPage> createState() => _SensorSearchPageState();
}

class _SensorSearchPageState extends State<SensorSearchPage> {
  final _controller = TextEditingController();
  var sensorNameFilter = "";

  @override
  Widget build(BuildContext context) {
    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const DeviceNameTitle(
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        Checkbox(
          value: true,
          onChanged: (isChecked) {},
        ),
      ],
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
    // TODO: Replace with favorite sensors
    var favorites = SensorId.values.take(3).toList();
    var favoritesBody = _getSensorsListFromIds(
      sensorIds: favorites,
      sensorNameFilter: sensorNameFilter,
    );

    var allSensorsHeader = const Text(
      "All",
      style: TextStyle(
        fontSize: 24,
      ),
    );
    // Show all sensors that are not favorites
    var allSensors =
        SensorId.values.where((id) => !favorites.contains(id)).toList();
    var allSensorsBody = _getSensorsListFromIds(
      sensorIds: allSensors,
      containerFlex: 2,
      sensorNameFilter: sensorNameFilter,
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
        appBar: AppBar(
          title: const Text(
            "Sensors",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              child: Column(
                children: [
                  header,
                  const Divider(thickness: 2),
                ],
              ),
            ),
          ),
        ),
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
    int containerFlex = 1,
    required String sensorNameFilter,
  }) =>
      Expanded(
        flex: containerFlex,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: sensorIds
                  .where(
                    (id) =>
                        sensorNameFilter == "" ||
                        id.name
                            .toLowerCase()
                            .contains(sensorNameFilter.toLowerCase()),
                  )
                  .map(
                    (id) => [
                      _getSensorToggleListElementFromSensorId(id),
                      const SizedBox(height: 6)
                    ],
                  )
                  .expand((element) => element)
                  .toList(),
            ),
          ),
        ),
      );

  SensorToggleListElement _getSensorToggleListElementFromSensorId(
    SensorId sensorId,
  ) =>
      SensorToggleListElement(
        color: sensorIdToColor[sensorId] ?? Colors.white,
        activeTrackColor: const Color.fromARGB(255, 66, 234, 7),
        inactiveTrackColor: const Color.fromARGB(255, 144, 149, 142),
        activeColor: Colors.white,
        textColor: Colors.black,
        sensorId: sensorId,
        onChanged: (isToggledOn) {
          setState(() {
            // TODO: Make call to smart sensing library
          });
        },
      );
}
