import 'package:flutter_dotenv/flutter_dotenv.dart';

String convertUrl(String url) {

  String result = url.replaceAll("http://s3:8333", "http://${dotenv.get("S3_URL")}").replaceAll("http://localhost:8333", "http://${dotenv.get("S3_URL")}");

  print("Edited url: $result");

  return result;

}