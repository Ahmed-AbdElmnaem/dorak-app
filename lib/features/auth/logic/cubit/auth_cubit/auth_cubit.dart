import 'dart:developer';

import 'package:dorak_app/features/auth/data/repo/auth_repository.dart';
import 'package:dorak_app/features/auth/logic/cubit/auth_cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthInitial());

  Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await _repository.register(email, password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure('حدث خطأ أثناء التسجيل'));
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await _repository.login(email, password);
      final prefs = await SharedPreferences.getInstance();
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await prefs.setString('userId', userId);
      log('User ID: $userId');

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure('فشل تسجيل الدخول'));
    }
  }
}
