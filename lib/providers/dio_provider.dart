import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

///connect laravel to flutter
///in order to connect database we have to create dio provider first
///to post/get data from laravel database
///and since  we use Laravel Sanctum an API Token needed for getting data from JWT

class DioProvider {
  final dio = Dio();
  final String baseUrl = "http://10.0.2.2:8000";

  ///get token
  Future<dynamic> getToken(String email, String password) async {
    try {
      var response = await dio.post('$baseUrl/api/login',
          data: {'email': email, 'password': password});
      dio.options.followRedirects = true;

      ///if request successfully,then return token
      if (response.statusCode == 200 && response.data != '') {
        ///store returned token into shared preferences
        ///for get other data later
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data);
        return response.data;
      }
    } catch (error) {
      return error;
    }
  }

  ///get user data
  Future<dynamic> getUser(String token) async {
    try {
      // var user = await dio.get('$baseUrl/api/user');
      var user = await dio.get('$baseUrl/api/user',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      dio.options.followRedirects = true;

      ///if request succeeds, then return token
      if (user.statusCode == 200 && user.data != '') {
        return json.encode(user.data);
      }
    } catch (error) {
      return error;
    }
  }

  ///register user data
  // Future<dynamic> registerUser(
  //     String name, String email, String password) async {
  //   try {
  //     // var user = await dio.get('$baseUrl/api/user');
  //     var user = await dio.post('$baseUrl/api/register',
  //         data: {'name': email, 'email': email, 'password': password});
  //     dio.options.followRedirects = true;
  //
  //     ///if register successfully
  //     if (user.statusCode == 201 && user.data != '') {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (error) {
  //     return error;
  //   }
  // }
  Future<bool> registerUser(String name, String email, String password) async {
    try {
      var user = await dio.post('$baseUrl/api/register',
          data: {'name': name, 'email': email, 'password': password});
      dio.options.followRedirects = true;

      if (user.statusCode == 201 && user.data != '') {
        return true; // Successful registration
      } else {
        return false; // Registration failed (non-201 status or empty data)
      }
    } catch (error) {
      // print('Registration error: $error'); // Handle the error
      return false; // Indicate registration failure
    }
  }

  //store booking details
  Future<dynamic> bookAppointment(
      String date, String day, String time, int doctor, String token) async {
    try {
      var response = await Dio().post('$baseUrl/api/book',
          data: {'date': date, 'day': day, 'time': time, 'doctor_id': doctor},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //retrieve booking details
  Future<dynamic> getAppointments(String token) async {
    try {
      var response = await Dio().get('$baseUrl/api/appointments',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return json.encode(response.data);
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //store rating details
  Future<dynamic> storeReviews(
      String reviews, double ratings, int id, int doctor, String token) async {
    try {
      var response = await Dio().post('$baseUrl/api/reviews',
          data: {
            'ratings': ratings,
            'reviews': reviews,
            'appointment_id': id,
            'doctor_id': doctor
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }
  //store fav doctor
  Future<dynamic> storeFavDoc(String token, List<dynamic> favList) async {
    try {
      var response = await Dio().post('$baseUrl/api/fav',
          data: {
            'favList': favList,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

//logout
  Future<dynamic> logout(String token) async {
    try {
      var response = await Dio().post('$baseUrl/api/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }
}
