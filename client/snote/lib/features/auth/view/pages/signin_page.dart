// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snote/core/resources/data_state.dart';
import 'package:snote/core/utils/extensions.dart';
import 'package:snote/features/auth/repository/auth_remote_repository.dart';
import 'package:snote/features/auth/view/pages/signup_page.dart';
import 'package:snote/features/auth/view/widgets/auth_grad_button.dart';
import 'package:snote/features/auth/view/widgets/text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _changeScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  void _onSignInSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign In success')),
    );
  }

  void _onAuthFailure(String? text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text ?? 'Sign In failed')),
    );
  }

  void onSignIn() async {
    final res = await AuthRemoteRepository().signIn(
      emailController.text,
      passwordController.text,
    );
    if (res is DataSuccess) {
      _onSignInSuccess();
    } else {
      _onAuthFailure(res.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildBody(),
        ),
      ),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            'Hi, Welcome back!',
            style: GoogleFonts.poppins(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          Text(
            'Hello again, you have been missed.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          // TextFields
          const SizedBox(
            height: 60,
          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                MyFormTextField(
                  hintText: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  label: 'Email',
                  keyboardAction: TextInputAction.next,
                  validator: (val) {
                    if (!val!.isValidEmail) {
                      return 'Enter a valid email.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                MyFormTextField(
                  hintText: 'Password',
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  label: 'Password',
                  keyboardAction: TextInputAction.done,
                  obscureText: true,
                  validator: (val) {
                    if (!val!.isValidPassword) {
                      return 'Enter a valid password.';
                    }
                    return null;
                  },
                ),
                // Elevated btn
                const SizedBox(
                  height: 280,
                ),
                AuthGradButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      onSignIn();
                    }
                  },
                  text: 'Sign Up',
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () => _changeScreen(const SignUpPage()),
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
