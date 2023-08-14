import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:podcast_app/models/http_error.dart';
import 'package:podcast_app/providers/me_provider.dart';
import '../utils/constants.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';

class AuthNotifier extends StateNotifier<String?> {
  Ref ref;

  AuthNotifier(this.ref): super('');

  Future<void> signIn(String email, String password) async {
    try {
      final dio = Dio();

      final response = await dio.post('${Constants.BASE_URL}/api/auth/sign-in', data: {
        'email': email,
        'password': password
      });

      if (response.statusCode == 200) {
        state = response.data['token'];
        // final box = await Hive.openBox('authBox');
        // box.put('token', response.data['token']);
      } else {
        throw HttpError(statusCode: response.statusCode!, message: response.data['message']);
      }

    } catch(error) {
      rethrow;
    }
  }

  Future<void> signUp(String username, String email, String password) async {
    try {
      final dio = Dio();

      final response = await dio.post('${Constants.BASE_URL}/api/auth/sign-up', data: {
        'username': username,
        'email': email,
        'password': password
      });

      if (response.statusCode == 201) {
        state = response.data['token'];
        // final box = Hive.box('authBox');
        // box.put('token', box);
      }

    } catch(error) {
      
      rethrow;

    }
  }




  Future<void> signOut() async {
    //final box = Hive.box('authBox');
    //box.delete('token');
    //state = Auth(token: null);
    state = null;
  }


  Future<void> fetchMyCredentials() async {
    try {
      final dio = Dio();

      final response = await dio.get('${Constants.BASE_URL}/api/me', options: Options(
        headers: {
          'x-access-token': state
        }
      ));
      
      if (response.statusCode == 200) {
        ref.read(meProvider.notifier).state = User.fromJson(response.data);
      }

    } catch(error) {
      rethrow;
    }
  }



}
final authProvider = StateNotifierProvider<AuthNotifier, String?>((ref) => AuthNotifier(ref));