import 'package:animate_do/animate_do.dart';
import 'package:dorak_app/core/routing/routes.dart';
import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:dorak_app/core/widgets/app_text_form_field.dart';
import 'package:dorak_app/features/auth/data/cubit/auth_cubit/auth_cubit.dart';
import 'package:dorak_app/features/auth/data/cubit/auth_cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

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
          Navigator.pop(context); // close loading dialog
          Navigator.pushReplacementNamed(context, Routes.home);
        } else if (state is AuthFailure) {
          Navigator.pop(context); // close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Form(
        key: formKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('تسجيل الدخول'),
            centerTitle: true,
            backgroundColor: ColorManager.mainColor,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
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
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AppTextFormField(
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
                  const SizedBox(height: 20),
                  AppTextFormField(
                    prefixIcon: Icon(Icons.lock, color: ColorManager.mainColor),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final email = emailController.text;
                        final password = passwordController.text;
                        context.read<AuthCubit>().loginUser(
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
                    child: const Text('تسجيل الدخول'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'لديك حساب بالفعل؟',
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.register);
                        },
                        child: Text(
                          ' تسجيل حساب جديد',
                          style: TextStyle(
                            color: ColorManager.mainColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
