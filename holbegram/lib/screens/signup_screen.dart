import 'package:flutter/material.dart';
import 'package:holbegram/screens/upload_image_screen.dart';
import '../widgets/text_field.dart';
import 'login_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 28),
                        const Text(
                          "Holbegram",
                          style: TextStyle(
                            fontFamily: "Billabong",
                            fontSize: 50,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Image.asset(
                          "assets/images/logo.webp",
                          width: 80,
                          height: 60,
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: 220,
                          child: Text(
                            "Sign up to see photos and videos from your friends.",
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 24),

                        TextFieldInput(
                          controller: emailController,
                          ispassword: false,
                          hintText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          suffixIcon: null,
                        ),
                        const SizedBox(height: 28),

                        TextFieldInput(
                          controller: usernameController,
                          ispassword: false,
                          hintText: "Full Name",
                          keyboardType: TextInputType.text,
                          suffixIcon: null,
                        ),
                        const SizedBox(height: 24),

                        TextFieldInput(
                          controller: passwordController,
                          ispassword: !_passwordVisible,
                          hintText: "Password",
                          keyboardType: TextInputType.visiblePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                () => _passwordVisible = !_passwordVisible,
                              );
                            },
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color.fromARGB(218, 226, 37, 24),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        TextFieldInput(
                          controller: passwordConfirmController,
                          ispassword: !_passwordVisible,
                          hintText: "Confirm password",
                          keyboardType: TextInputType.visiblePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                () => _passwordVisible = !_passwordVisible,
                              );
                            },
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color.fromARGB(218, 226, 37, 24),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),
                        SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                const Color.fromARGB(218, 226, 37, 24),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddPicture(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    username: usernameController.text,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Have an account? "),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Log in",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(218, 226, 37, 24),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
