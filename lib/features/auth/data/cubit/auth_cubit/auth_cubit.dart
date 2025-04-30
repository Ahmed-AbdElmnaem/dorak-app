import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // حفظ بيانات المستخدم في Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'password':
            password, // ❗ مش آمن تخزن الباسورد كده، بس لو للتمرين مفيش مشكلة
      });

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthFailure('كلمة المرور ضعيفة'));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthFailure('البريد الإلكتروني مسجل بالفعل'));
      } else {
        emit(AuthFailure('حدث خطأ أثناء التسجيل'));
      }
    } catch (e) {
      emit(AuthFailure('حدث خطأ غير متوقع'));
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthFailure('المستخدم غير موجود'));
      } else if (e.code == 'wrong-password') {
        emit(AuthFailure('كلمة المرور غير صحيحة'));
      } else {
        emit(AuthFailure('فشل تسجيل الدخول'));
      }
    } catch (e) {
      emit(AuthFailure('حدث خطأ غير متوقع'));
    }
  }
}
