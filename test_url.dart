
import 'dart:core';

String sanitizeUrlInput(String raw) {
  var s = raw.trim();
  if (s.isEmpty) return s;
  if (s.startsWith('\uFEFF')) s = s.substring(1);
  s = s.replaceAll(RegExp(r'[\u200e\u200f\u202a-\u202e\u2066-\u2069]'), '');
  return s.trim();
}

bool _isValidHttpLikeUrl(String candidate) {
  final uri = Uri.tryParse(candidate);
  if (uri == null || !uri.hasScheme) return false;
  if (uri.scheme != 'http' && uri.scheme != 'https') return false;
  if (uri.host.isEmpty) return false;
  return true;
}

String? urlValidator(String? value, [bool required = false]) {
  if (required && (value == null || value.isEmpty)) {
    return 'required';
  }
  if (value == null || value.isEmpty) return null;

  final trimmedValue = sanitizeUrlInput(value);
  if (RegExp(r'^driver?://(\d{1,3})(/\S*)?$').hasMatch(trimmedValue)) {
    return null;
  }
  if (trimmedValue.startsWith('/') && !trimmedValue.startsWith('//')) {
    return 'invalid_path';
  }

  var candidate = trimmedValue;
  if (!candidate.contains('://')) {
    candidate = 'https://$candidate';
  }
  if (_isValidHttpLikeUrl(candidate)) {
    return null;
  }
  return 'invalid_url';
}

void main() {
  final url = 'https://raw.githubusercontent.com/HamaUk/ghosten/refs/heads/main/hama.m3u';
  print('Testing URL: $url');
  print('Result: ${urlValidator(url, true)}');
  
  final url2 = 'google.com';
  print('Testing URL: $url2');
  print('Result: ${urlValidator(url2, true)}');

  final url3 = '  https://raw.githubusercontent.com/HamaUk/ghosten/refs/heads/main/hama.m3u  ';
  print('Testing URL with spaces: "$url3"');
  print('Result: ${urlValidator(url3, true)}');
}
