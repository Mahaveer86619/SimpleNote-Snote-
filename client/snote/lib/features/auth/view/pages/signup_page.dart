import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snote/core/resources/data_state.dart';
import 'package:snote/core/utils/extensions.dart';
import 'package:snote/features/auth/repository/auth_remote_repository.dart';
import 'package:snote/features/auth/view/pages/signin_page.dart';
import 'package:snote/features/auth/view/widgets/auth_grad_button.dart';
import 'package:snote/features/auth/view/widgets/text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formkey = GlobalKey<FormState>();

  final nameController = TextEditingController();
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

  void _onSignUpSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign up success')),
    );
  }

  void _onAuthFailure() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign up failed')),
    );
  }

  void onSignUp() async {
    final res = await AuthRemoteRepository().signUp(
      nameController.text,
      emailController.text,
      passwordController.text,
    );
    if (res is DataSuccess) {
      _onSignUpSuccess();
    } else {
      _onAuthFailure();
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
            'Create Account',
            style: GoogleFonts.poppins(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          Text(
            'Connect with your friends!',
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
                  hintText: 'Username',
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  label: 'Username',
                  keyboardAction: TextInputAction.next,
                  validator: (val) {
                    if (!val!.isValidName) {
                      return 'Enter a valid name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
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
                  height: 200,
                ),
                AuthGradButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      onSignUp();
                    }
                  },
                  text: 'Sign Up',
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () => _changeScreen(const SignInPage()),
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign in',
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
