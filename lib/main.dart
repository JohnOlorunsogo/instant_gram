import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/firebase_options.dart';
import 'package:instant_gram/state/auth/backend/authenticator.dart';
import 'package:instant_gram/state/auth/providers/auth_state_providers.dart';

import 'dart:developer' as developer show log;

import 'package:instant_gram/state/auth/providers/is_logged_in_provider.dart';
import 'package:instant_gram/views/components/loading/loading_screen.dart';

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
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: Consumer(
        builder: (context, ref, child) {
          final isLoggedIn = ref.watch(isLoggedInProvider);
          if (isLoggedIn) {
            return const MainView();
          } else {
            return const LogInView();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main View'),
        centerTitle: true,
      ),
      body: TextButton(
        onPressed: () async {
          await ref.read(authStateProvider.notifier).logOut();
        },
        child: const Text('Log Out'),
      ),
    );
  }
}

class LogInView extends ConsumerWidget {
  const LogInView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log In")),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              // final result = await Authenticator().loginWithGoogle();

              ref.read(authStateProvider.notifier).loginWithGoogle();

              // result.log();
            },
            child: const Text("Sign In with Google"),
          ),
          TextButton(
            onPressed: () async {
              final result = await Authenticator().loginWithFacebook();
              result.log();
            },
            child: const Text("Sign In with Facebook"),
          ),
        ],
      ),
    );
  }
}
