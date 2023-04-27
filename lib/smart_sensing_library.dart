library smart_sensing_library;

export 'package:sensing_plugin/sensing_plugin.dart'
    show
        SensorId,
        SensorInfo,
        Unit,
        SensorAccuracy,
        SensorData,
        SensorTaskResult,
        SensorConfig,
        configValidatorMinPrecision,
        configValidatorMaxPrecision;

export 'package:smart_sensing_library/device_information_manager.dart'
    show getOSVersion, getFreeStorage, getDeviceName;

export 'package:smart_sensing_library/io_manager.dart' show IOManager;

export 'package:smart_sensing_library/src/import_export_module/supported_file_format.dart'
    show SupportedFileFormat;
