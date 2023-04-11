import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/app_bar_with_header.dart';
import '../../general_widgets/device_name_title.dart';
import '../../general_widgets/stylized_container.dart';
import '../../theme.dart';
import 'checkbox_with_text.dart';
import 'sensor_toggle_element.dart';

class SensorSearchPage extends StatefulWidget {
  const SensorSearchPage({super.key});

  @override
  State<SensorSearchPage> createState() => _SensorSearchPageState();
}

class _SensorSearchPageState extends State<SensorSearchPage> {
  final _controller = TextEditingController();
  var sensorNameFilter = "";
  var showOnlyAvailableSensors = false;

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
        CheckBoxWithText(
          text: "Only show available",
          isChecked: showOnlyAvailableSensors,
          onPressed: (isChecked) {
            setState(() {
              showOnlyAvailableSensors = isChecked;
            });
          },
        ),
      ],
    );

    // TODO: Replace with call to smart sensing library
    bool isAvailable(SensorId sensorId) => sensorId != SensorId.barometer;

    // Fetch sensors which should be displayed
    var sensorIdsToDisplay = SensorId.values
        .where((id) => !showOnlyAvailableSensors || isAvailable(id));

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
    var favorites = sensorIdsToDisplay.take(3).toList();
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
        sensorIdsToDisplay.where((id) => !favorites.contains(id)).toList();
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

  Future<String> _getSensorAvailability(SensorId sensorId) async {
    // TODO: Replace with call to smart sensing library
    await Future.delayed(const Duration(milliseconds: 100));
    return sensorId == SensorId.barometer ? "false" : "true";
  }

  /// Creates a [SensorToggleElement] for the passed [sensorId].
  ///
  /// If [disableToggling] is true, the [SensorToggleElement] is also disabled,
  /// the colors for the disabeld state are replaced with the colors for the
  /// inactive state of the switch.
  /// This has the reason that the [SensorToggleElement] can be shown without
  /// knowing whether the sensor for the passed [sensorId] is actually available
  /// in which case the [SensorToggleElement] would be disabled.
  SensorToggleElement _createSensorToggleListElement({
    required SensorId sensorId,
    required bool isDisabled,
    bool disableToggling = false,
  }) =>
      SensorToggleElement(
        color: sensorIdToColor[sensorId] ?? Colors.white,
        activeColor: const Color.fromARGB(255, 217, 217, 217),
        activeTrackColor: const Color.fromARGB(255, 66, 234, 7),
        inactiveColor: const Color.fromARGB(255, 217, 217, 217),
        inactiveTrackColor: const Color.fromARGB(255, 144, 149, 142),
        isDisabled: isDisabled || disableToggling,
        disabledColor: disableToggling
            ? const Color.fromARGB(255, 217, 217, 217)
            : const Color.fromARGB(255, 158, 162, 157),
        disabledTrackColor: disableToggling
            ? const Color.fromARGB(255, 144, 149, 142)
            : const Color.fromARGB(255, 144, 149, 142),
        textColor: Colors.black,
        sensorId: sensorId,
        onChanged: (isToggledOn) {
          if (disableToggling) {
            return;
          }

          setState(() {
            // TODO: Make call to smart sensing library
          });
        },
      );

  /// Creates a [SensorToggleElement] from the passed [sensorId].
  ///
  /// Checks whether the sensor with the passed [sensorId] is available and
  /// displays [SensorToggleElement] with disabled toggling as long as the
  /// request lasts.
  FutureBuilder _getSensorToggleListElementFromSensorId(
    SensorId sensorId,
  ) =>
      FutureBuilder(
        future: _getSensorAvailability(sensorId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var isAvailable = snapshot.data! == "true";
            return _createSensorToggleListElement(
              sensorId: sensorId,
              isDisabled: !isAvailable,
            );
          }

          return _createSensorToggleListElement(
            sensorId: sensorId,
            isDisabled: true,
            disableToggling: true,
          );
        },
      );
}
