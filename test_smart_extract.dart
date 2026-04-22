
String sanitizeUrlInput(String raw) {
  var s = raw.trim();
  if (s.isEmpty) return s;
  if (s.startsWith('\uFEFF')) s = s.substring(1);
  s = s.replaceAll(RegExp(r'[\u200b\u200e\u200f\u202a-\u202e\u2066-\u2069]'), '');
  return s.trim();
}

String normalizeHttpUrlForFetch(String raw) {
  final t = sanitizeUrlInput(raw);
  if (t.isEmpty) return t;

  final urlMatch = RegExp(r'https?://[^\s,]+').firstMatch(t);
  if (urlMatch != null) {
    return urlMatch.group(0)!;
  }

  if (RegExp(r'^driver?://').hasMatch(t)) return t;
  if (!t.contains('://')) {
    return 'https://$t';
  }
  return t;
}

void main() {
  final inputs = [
    '[20/04/2026 15:06] Opt1C Gh0sT: http://xvip.pro:80/get.php?username=Huyam010&password=esr@213&type=m3u_plus&output=ts',
    '[20/04/2026 15:52] Opt1C Gh0sT: http://sharkiptv.vip:8080/get.php?username=3033692995&password=1072369964&type=m3u',
    'google.com',
    'https://raw.githubusercontent.com/HamaUk/ghosten/refs/heads/main/hama.m3u',
    '  http://example.com/test  '
  ];

  for (final input in inputs) {
    print('Input: $input');
    print('Result: ${normalizeHttpUrlForFetch(input)}');
    print('---');
  }
}
