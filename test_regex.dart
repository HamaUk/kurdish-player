void main() {
  var url1 = 'http://xvip.pro:80/get.php?username=Huyam010&password=esr@213&type=m3u_plus&output=ts';
  var url2 = 'http://sharkiptv.vip:8080/get.php?username=3033692995&password=1072369964&type=m3u';
  var regex = RegExp(r'^https?://[a-zA-Z0-9\-.]+\.[a-zA-Z0-9\-.]{2,}(:[0-9]{1,5})?(/\S*)?$');
  print('URL1 Match: ${regex.hasMatch(url1)}');
  print('URL2 Match: ${regex.hasMatch(url2)}');
}
