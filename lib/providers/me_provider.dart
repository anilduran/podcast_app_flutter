import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import './auth_provider.dart';
import 'package:dio/dio.dart';
import '../utils/constants.dart';



final meProvider = StateProvider<User?>((ref) {
  return null;
});