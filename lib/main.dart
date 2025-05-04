import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorak_app/core/routing/app_router.dart';
import 'package:dorak_app/core/routing/routes.dart';
import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:dorak_app/features/auth/data/repo/auth_repository.dart';
import 'package:dorak_app/features/auth/logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:dorak_app/features/home/data/repo/groups_repository.dart';
import 'package:dorak_app/features/home/logic/groups_cubit.dart';
import 'package:dorak_app/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      fallbackLocale: const Locale('ar'),
      saveLocale: true,
      startLocale: const Locale('ar'),
      path: 'assets/translations',
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) =>
                    GroupsCubit(GroupsRepository(FirebaseFirestore.instance)),
          ),
          BlocProvider(
            create:
                (context) => AuthCubit(
                  AuthRepository(
                    FirebaseAuth.instance,
                    FirebaseFirestore.instance,
                  ),
                ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Dorak App',
      theme: ThemeData(
        scaffoldBackgroundColor: ColorManager.white,
        colorScheme: ColorScheme.fromSeed(seedColor: ColorManager.mainColor),
      ),
    );
  }
}
