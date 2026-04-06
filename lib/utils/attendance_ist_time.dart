const Duration kIstOffset = Duration(hours: 5, minutes: 30);

bool _hasExplicitTimeZoneOffset(String input) {
  // Examples: 2026-04-06T07:21:39Z, 2026-04-06T07:21:39+05:30
  return RegExp(r'(Z|[+-]\d{2}:\d{2})$').hasMatch(input);
}

DateTime? tryParseApiDateTimeAsUtc(String? value) {
  final v = value?.trim();
  if (v == null || v.isEmpty) return null;

  if (_hasExplicitTimeZoneOffset(v)) {
    return DateTime.tryParse(v)?.toUtc();
  }

  // Treat timezone-less API timestamps as UTC.
  // Supports:
  // - YYYY-MM-DD
  // - YYYY-MM-DDTHH:MM
  // - YYYY-MM-DDTHH:MM:SS
  // - YYYY-MM-DDTHH:MM:SS.ffffff
  final match = RegExp(
    r'^(\d{4})-(\d{2})-(\d{2})'
    r'(?:[T ](\d{2}):(\d{2})'
    r'(?::(\d{2})(?:\.(\d{1,6}))?)?'
    r')?'
    r'$',
  ).firstMatch(v);

  if (match == null) {
    // Fall back to the built-in parser.
    return DateTime.tryParse(v);
  }

  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);

  final hour = int.tryParse(match.group(4) ?? '') ?? 0;
  final minute = int.tryParse(match.group(5) ?? '') ?? 0;
  final second = int.tryParse(match.group(6) ?? '') ?? 0;

  final frac = (match.group(7) ?? '');
  final fracPadded = frac.isEmpty ? '0' : frac.padRight(6, '0');
  final micros = int.tryParse(fracPadded) ?? 0;
  final milli = micros ~/ 1000;
  final microRemainder = micros % 1000;

  return DateTime.utc(
    year,
    month,
    day,
    hour,
    minute,
    second,
    milli,
    microRemainder,
  );
}

DateTime? tryParseApiDateTimeAsIst(String? value) {
  final utc = tryParseApiDateTimeAsUtc(value);
  if (utc == null) return null;
  final ist = utc.add(kIstOffset);
  // Create a "timezone-independent" DateTime carrying IST wall-clock values.
  return DateTime(
    ist.year,
    ist.month,
    ist.day,
    ist.hour,
    ist.minute,
    ist.second,
    ist.millisecond,
    ist.microsecond,
  );
}

String twoDigits(int n) => n.toString().padLeft(2, '0');

String formatIstTime(
  String? value, {
  required bool use24Hour,
  bool showSeconds = true,
}) {
  final dt = tryParseApiDateTimeAsIst(value);
  if (dt == null) {
    final raw = value?.trim();
    return (raw != null && raw.isNotEmpty) ? raw : '-';
  }

  final h = dt.hour;
  final m = twoDigits(dt.minute);
  final s = twoDigits(dt.second);

  if (use24Hour) {
    final hh = twoDigits(h);
    return showSeconds ? '$hh:$m:$s' : '$hh:$m';
  }

  final hour12 = (h % 12 == 0) ? 12 : (h % 12);
  final suffix = h < 12 ? 'AM' : 'PM';
  return showSeconds ? '$hour12:$m:$s $suffix' : '$hour12:$m $suffix';
}

String formatIstDateYmd(String? value) {
  final dt = tryParseApiDateTimeAsIst(value);
  if (dt == null) {
    final raw = value?.trim();
    return (raw != null && raw.isNotEmpty) ? raw : '-';
  }
  return '${dt.year}-${twoDigits(dt.month)}-${twoDigits(dt.day)}';
}
