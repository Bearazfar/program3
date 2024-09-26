import 'package:test_flutter/users.dart';

class Configure{
  static const server = "172.16.42.179:3000";
  static Users login = Users();
  static List<String> gender = ["None", "Male", "Female"];
}

//json-server --host 172.16.42.179 data.json
