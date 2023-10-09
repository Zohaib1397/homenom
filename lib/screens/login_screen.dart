import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/authentication_status.dart';
import 'package:homenom/screens/signup_screen.dart';

import '../services/TextFieldHandler.dart';
import 'ForgetPasswordScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String id = "Login_Screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailField = TextFieldHandler();
  final _passwordField = TextFieldHandler();
  bool isPasswordVisible = true;

  Future<bool> signInWithEmailAndPassword() async {
    try {
      showDialog(
        context: context,
        builder: (_) => Center(
          child: Container(
            padding: const EdgeInsets.all(40),
            child: const CircularProgressIndicator(),
          ),
        ),
      );
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailField.controller.text,
        password: _passwordField.controller.text,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      setState(() {
        _emailField.errorText = "Invalid Email";
        _passwordField.errorText = "Invalid Password";
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        Navigator.pop(context);
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Hero(
                        tag: "homenom",
                        child: Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Image(
                            image: AssetImage("assets/homenom.png"),
                            height: 200,
                          ),
                        ),
                      ),
                      const Text("HomeNom"),
                      const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextField(
                            controller: _emailField.controller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: kInputFieldDecoration.copyWith(
                              hintText: "Enter email address",
                              errorText: _emailField.errorText,
                            ),
                          ),
                          TextField(
                            controller: _passwordField.controller,
                            obscureText: isPasswordVisible,
                            decoration: kInputFieldDecoration.copyWith(
                              hintText: "Enter password",
                              errorText: _passwordField.errorText,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => setState(
                              () {
                                Navigator.pushNamed(context, ForgetPasswordScreen.id);
                              },
                            ),
                            child: const Text("Forget Password?"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              height: 50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              color: Color(0xff3D3D3D),
                              child: const Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                setState(() {
                                  if(_emailField.controller.text[0] == '0'){
                                    _emailField.controller.text = _emailField.controller.text.substring(1);
                                  }
                                });
                                if (await signInWithEmailAndPassword()){
                                  Navigator.pushNamed(context, AuthenticationStatus.id);
                                }
                                else{
                                  return;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            child: const Text("Signup"),
                            onPressed: () {
                              Navigator.pushNamed(context, SignUpScreen.id);
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
