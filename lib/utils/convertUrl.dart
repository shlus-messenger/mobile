String convertUrl(String url) {

  String result = url.replaceAll("http://s3:8333", "http://10.0.2.2:8333").replaceAll("http://localhost:8333", "http://10.0.2.2:8333");

  print("Edited url: $result");

  return result;

}