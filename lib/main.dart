import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/firebase_options.dart';
import 'dart:developer' as developer show log;
import 'package:instant_gram/state/auth/providers/is_logged_in_provider.dart';
import 'package:instant_gram/state/providers/is_loading_provider.dart';
import 'package:instant_gram/views/components/loading/loading_screen.dart';
import 'package:instant_gram/views/login/login_view.dart';
import 'package:instant_gram/views/main/main_view.dart';

extension Log on Object {
  void log() => developer.log(toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Consumer(
        builder: (context, ref, child) {
          //Display loading screen globally
          ref.listen<bool>(
            isLoadingProvider,
            (previous, isLoading) {
              if (isLoading) {
                LoadingScreen.instance().show(context: context);
              } else {
                LoadingScreen.instance().hide();
              }
            },
          );

          final isLoggedIn = ref.watch(isLoggedInProvider);
          if (isLoggedIn) {
            return const MainView();
          } else {
            return const LoginView();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
