import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {

  // APIKEY For BROWSER
  static String? apiKey = dotenv.env['APIKEY'];
  static String? apiKey4 = dotenv.env['APIKEY4'];
  static String? apiKey5 = dotenv.env['APIKEY5'];

  static String authDomain = "map1-6175b.firebaseapp.com";
  static String databaseURL = "https://map1-6175b-default-rtdb.firebaseio.com";
  static String projectId = "map1-6175b";
  static String storageBucket = "map1-6175b.appspot.com";
  static String messagingSenderId = "213956498409";
  static String appId = "1:213956498409:web:e3a458ee9868dbc27d7178";
  static String measurementId = "G-83MB3EG7EN";
}
