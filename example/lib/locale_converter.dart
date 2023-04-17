import 'dart:io';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

/// Converts the system locale to a LocaleType.
///
/// The system locale is determined with the `Platform.locale` (type: String)
/// and the localeType (type: LocaleType) is used by the `DatePicker` package.
///
/// The default return value is _LocaleType.en_, because LocaleType don't
/// support all locales that are theoretically possible and could be get
/// by `Platform.localeName`.
LocaleType getLocaleTypeFromSystemLocale() {
  var systemLocale = Platform.localeName.split("_")[0];
  var localeType = LocaleType.values.firstWhere(
    (element) => element.toString() == systemLocale,
    orElse: () => LocaleType.en,
  );

  return localeType;
}
