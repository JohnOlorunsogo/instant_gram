import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/providers/auth_state_providers.dart';
import 'package:instant_gram/views/constants/app_colors.dart';
import 'package:instant_gram/views/constants/strings.dart';
import 'package:instant_gram/views/login/divder_with_margin.dart';
import 'package:instant_gram/views/login/facebook_button.dart';
import 'package:instant_gram/views/login/google_button.dart';
import 'package:instant_gram/views/login/login_view_sign_up_link.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              Text(
                Strings.welcomeToAppName,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const DividerWithMargin(),
              Text(
                Strings.logIntoYourAccount,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 30),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.loginButtonColor,
                  foregroundColor: AppColors.loginButtonTextColor,
                ),
                onPressed: ref
                    .read(
                      authStateProvider.notifier,
                    )
                    .loginWithGoogle,
                child: const GoogleButton(),
              ),
              const SizedBox(height: 30),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.loginButtonColor,
                  foregroundColor: AppColors.loginButtonTextColor,
                ),
                onPressed: ref
                    .read(
                      authStateProvider.notifier,
                    )
                    .loginWithFacebook,
                child: const FacebookButton(),
              ),
              const DividerWithMargin(),
              const LoginViewSignUpLink(),
            ],
          ),
        ),
      ),
    );
  }
}
