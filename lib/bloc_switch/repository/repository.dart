import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepositories {
  static String mainUrl = "https://reqres.in";
  var loginUrl = '$mainUrl/api/login';

  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
  final Dio dio = Dio();
  Future<bool> hasToken() async {
    var value = await flutterSecureStorage.read(key: 'token');
    if (value != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> persistToken(String token) async {
    await flutterSecureStorage.write(key: 'token', value: token);
  }

  Future<void> deleteToken() async {
    await flutterSecureStorage.delete(key: 'token');
    flutterSecureStorage.deleteAll();
  }

  Future<String> login(String email, String password) async {
    Response response =
        await dio.post(loginUrl, data: {"email": email, "password": password});
    return response.data['token'];
  }
}
