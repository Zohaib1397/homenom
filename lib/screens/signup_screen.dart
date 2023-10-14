import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homenom/screens/authentication_status.dart';

import '../constants/constants.dart';
import '../services/TextFieldHandler.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String id = "Signup_Screen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailField = TextFieldHandler();
  final _phoneField = TextFieldHandler();
  final _passwordField = TextFieldHandler();
  final _confirmPasswordField = TextFieldHandler();
  final _username = TextFieldHandler();
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  final _auth = FirebaseAuth.instance;

  Future<bool> createAccount() async {
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
      final userCredentials = await _auth.createUserWithEmailAndPassword(
          email: _emailField.controller.text,
          password: _passwordField.controller.text);

      await FirebaseFirestore.instance.collection("Users").doc(userCredentials.user!.email).set(
          {
            "username" : _username.controller.text,
            "phone" : _phoneField.controller.text,
            "Address": "Not set yet",
            "is_phone_verified": false,

          });
      await _auth.currentUser!.updateDisplayName(_username.controller.text);
      return true;
    } on FirebaseAuthException catch (e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        Navigator.pop(context);
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                            height: 100,
                          ),
                        ),
                      ),
                      const Text("HomeNom"),
                      const Text(
                        "Signup",
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
                            controller: _username.controller,
                            decoration: kInputFieldDecoration.copyWith(
                              hintText: "Enter full name",
                              errorText: _username.errorText,
                            ),
                          ),
                          TextField(
                            controller: _emailField.controller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: kInputFieldDecoration.copyWith(
                              hintText: "Enter email address",
                              errorText: _emailField.errorText,
                            ),
                          ),
                          TextField(
                            controller: _phoneField.controller,
                            keyboardType: TextInputType.phone,
                            decoration: kInputFieldDecoration.copyWith(
                              hintText: "Enter phone number",
                              prefixIcon: const Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text('+92 ')),
                              errorText: _phoneField.errorText,
                            ),
                          ),
                          TextField(
                            obscureText: isPasswordVisible,
                            controller: _passwordField.controller,
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
                            onChanged: (value) => setState((){
                              _confirmPasswordField.errorText = "";
                              _passwordField.errorText = "";
                            }),
                          ),
                          TextField(
                            obscureText: isConfirmPasswordVisible,
                            controller: _confirmPasswordField.controller,
                            decoration: kInputFieldDecoration.copyWith(
                              hintText: "Confirm password",
                              errorText: _confirmPasswordField.errorText,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              height: 50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              color: const Color(0xff3D3D3D),
                              child: const Text(
                                "Signup",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if(_emailField.controller.text.isEmpty || _username.controller.text.isEmpty || _passwordField.controller.text.isEmpty){
                                  if(_emailField.controller.text.isEmpty){
                                    setState(() {
                                      _emailField.errorText = "Email is required";
                                    });
                                  }
                                  if(_username.controller.text.isEmpty){
                                    setState(() {
                                      _username.errorText = "Name is required";
                                    });
                                  }
                                  if( _passwordField.controller.text.isEmpty){
                                    setState(() {
                                      _passwordField.errorText="Password is required";
                                    });
                                  }
                                  if(_confirmPasswordField.controller.text.isEmpty){
                                    setState(() {
                                      _confirmPasswordField.errorText = "Password didn't match";
                                    });
                                  }
                                  if(_phoneField.controller.text.isEmpty){
                                    setState(() {
                                      _phoneField.errorText = "Phone Number is required";
                                    });
                                  }
                                  return;
                                }
                                if(_passwordField.controller.text != _confirmPasswordField.controller.text){
                                  setState(() {
                                    _confirmPasswordField.errorText = "Password didn't match";
                                  });
                                  return;
                                }
                                if(_phoneField.controller.text[0] == '0'){
                                  _phoneField.controller.text = _phoneField.controller.text.substring(1);
                                }
                                if(_phoneField.controller.text.length!=10){
                                  setState(() {
                                    _phoneField.errorText = "Invalid phone number";
                                  });
                                  return;
                                }
                                if(await createAccount()){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Inside if")));
                                  Navigator.pushNamed(context, AuthenticationStatus.id);
                                }else {
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
                          const Text("Already have an account?"),
                          TextButton(
                            child: const Text("Login"),
                            onPressed: () {
                              if(_auth.currentUser!=null){
                                _auth.signOut();
                              }
                              Navigator.pop(context);
                            },
                          )
                        ],
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
