import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

String? yearValidator(BuildContext context, String? value) {
  if (value != null && value.isNotEmpty) {
    final year = int.tryParse(value);
    if (year == null || year < 1900 || year > 2100) {
      return AppLocalizations.of(context)!.formValidatorYear;
    }
  }
  return null;
}

String? requiredValidator(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.formValidatorRequired;
  }
  return null;
}

bool _isValidHttpLikeUrl(String candidate) {
  final uri = Uri.tryParse(candidate);
  if (uri == null || !uri.hasScheme) return false;
  if (uri.scheme != 'http' && uri.scheme != 'https') return false;
  if (uri.host.isEmpty) return false;
  return true;
}

/// Normalizes playlist URL input after it has passed [urlValidator].
/// Adds `https://` when the user omitted the scheme (e.g. `example.com/list.m3u`).
String normalizeHttpUrlForFetch(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return t;
  if (RegExp(r'^driver?://').hasMatch(t)) return t;
  if (!t.contains('://')) {
    return 'https://$t';
  }
  return t;
}

String? urlValidator(BuildContext context, String? value, [bool required = false]) {
  if (required && (value == null || value.isEmpty)) {
    return AppLocalizations.of(context)!.formValidatorRequired;
  }
  if (value == null || value.isEmpty) return null;

  final trimmedValue = value.trim();
  if (RegExp(r'^driver?://(\d{1,3})(/\S*)?$').hasMatch(trimmedValue)) {
    return null;
  }
  // Path-only strings are not fetchable HTTP URLs (common paste mistake).
  if (trimmedValue.startsWith('/') && !trimmedValue.startsWith('//')) {
    return AppLocalizations.of(context)!.formValidatorUrl;
  }

  var candidate = trimmedValue;
  if (!candidate.contains('://')) {
    candidate = 'https://$candidate';
  }
  if (_isValidHttpLikeUrl(candidate)) {
    return null;
  }
  return AppLocalizations.of(context)!.formValidatorUrl;
}
