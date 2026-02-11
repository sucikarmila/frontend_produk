import 'package:flutter/foundation.dart';

class BaseUrl {
  static String get host => kIsWeb ? "localhost" : "10.0.2.2";
  static String get baseUrl => "http://$host/database/produk";
  static String get list => "$baseUrl/list.php";
  static String get create => "$baseUrl/create.php";
  static String get update => "$baseUrl/update.php";
  static String get delete => "$baseUrl/delete.php";
  static String get imagePath => "$baseUrl/uploads/";
}