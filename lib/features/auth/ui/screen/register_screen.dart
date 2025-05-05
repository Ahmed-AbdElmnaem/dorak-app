import 'package:animate_do/animate_do.dart';
import 'package:dorak_app/core/routing/routes.dart';
import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:dorak_app/core/widgets/app_text_form_field.dart';
import 'package:dorak_app/features/auth/logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:dorak_app/features/auth/logic/cubit/auth_cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthSuccess) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, Routes.login);
        } else if (state is AuthFailure) {
          Navigator.pop(context);
          showErrorDialog(context, state.message);
        }
      },
      child: Form(
        key: formKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('تسجيل حساب جديد'),
            centerTitle: true,
            backgroundColor: ColorManager.mainColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZoomIn(
                    duration: const Duration(milliseconds: 800),
                    child: Pulse(
                      duration: const Duration(seconds: 2),
                      infinite: true,
                      child: Image.asset(
                        'assets/images/home_logo.jpeg',
                        height: 150,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'إنشاء حساب جديد',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  // ======= Animated Text Fields =======
                  FadeInDown(
                    delay: const Duration(milliseconds: 200),
                    child: AppTextFormField(
                      hintText: 'البريد الإلكتروني',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'من فضلك أدخل البريد الإلكتروني';
                        } else if (!RegExp(
                          r'^[^@]+@[^@]+\.[^@]+',
                        ).hasMatch(value)) {
                          return 'البريد الإلكتروني غير صالح';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInDown(
                    delay: const Duration(milliseconds: 400),
                    child: AppTextFormField(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'كلمة المرور',
                      controller: passwordController,
                      obsecureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'من فضلك أدخل كلمة المرور';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final email = emailController.text;
                          final password = passwordController.text;
                          context.read<AuthCubit>().registerUser(
                            email: email,
                            password: password,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: ColorManager.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('تسجيل حساب'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'لديك حساب بالفعل؟',
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            '  تسجيل الدخول',
                            style: TextStyle(color: ColorManager.mainColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('خطأ'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('موافق'),
            ),
          ],
        );
      },
    );
  }
}
