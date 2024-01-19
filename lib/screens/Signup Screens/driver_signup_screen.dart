import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homenom/screens/authentication_status.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/Utils.dart';
import '../../structure/Role.dart';
import '../../structure/Driver.dart' as Model;
import '../../constants/constants.dart';
import '../../structure/TextFieldHandler.dart';
import 'dart:io';

import '../login_screen.dart';

class DriverSignUpScreen extends StatefulWidget {
  const DriverSignUpScreen({super.key});

  static const String id = "Driver_Signup_Screen";

  @override
  State<DriverSignUpScreen> createState() => _DriverSignUpScreenState();
}

class _DriverSignUpScreenState extends State<DriverSignUpScreen> {
  final _emailField = TextFieldHandler();
  final _phoneField = TextFieldHandler();
  final _cnicField = TextFieldHandler();
  final _bikeNumber = TextFieldHandler();
  final _license = TextFieldHandler();
  final _bikeRegNo = TextFieldHandler();
  final _passwordField = TextFieldHandler();
  final _confirmPasswordField = TextFieldHandler();
  final _username = TextFieldHandler();
  final _bikeType = TextFieldHandler();
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  final _auth = FirebaseAuth.instance;
  final imagePicker = ImagePicker();
  File? image;
  bool isLoading = false;

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
      ROLE role = ROLE.DRIVER;
      final userCredentials = await _auth.createUserWithEmailAndPassword(
          email: _emailField.controller.text,
          password: _passwordField.controller.text);
      final newUser = Model.Driver(
        name: _username.controller.text,
        username: _emailField.controller.text.split('@')[0],
        address: "Null",
        email: _emailField.controller.text,
        id: UniqueKey().toString(),
        phoneNum: _phoneField.controller.text,
        isPhoneVerified: false,
        rating: 0,
        role: role.toString(),
        latitude: 0.0,
        longitude: 0.0,
        bikeNumber : _bikeNumber.controller.text,
        bikeType : _bikeType.controller.text,
        license : _license.controller.text,
        bikeRegNo : _bikeRegNo.controller.text,
      );
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredentials.user!.email)
          .set(newUser.toJson());
      await _auth.currentUser!.updateDisplayName(_username.controller.text);
      return true;
    } on FirebaseAuthException catch (e) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        Navigator.pop(context);
      });
      return false;
    }
  }

  Future<void> getImageFromGallery(ImageSource source) async {
    try {
      setState(() => isLoading = true);
      final imagePick = await imagePicker.pickImage(source: source);
      final imageTemporary = File(imagePick!.path);
      setState(() => image = imageTemporary);
      setState(() => isLoading = false);
    } catch (e) {
      Utils.showPopup(context, "Image Error", "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
                      image == null
                          ? const Hero(
                              tag: "homenom",
                              child: Padding(
                                padding: EdgeInsets.all(30.0),
                                child: Image(
                                  image: AssetImage("assets/homenom.png"),
                                  height: 100,
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(300),
                              child: Image.file(
                                image!,
                                fit: BoxFit.fill,
                                height: 100,
                                width: 100,
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () =>
                                  getImageFromGallery(ImageSource.gallery),
                              child: const Text("Add Image")),
                          TextButton(
                            onPressed: () =>
                                getImageFromGallery(ImageSource.camera),
                            child: const Text("Capture Image"),
                          ),
                        ],
                      ),
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
                            controller: _cnicField.controller,
                            decoration: kInputFieldDecoration.copyWith(
                              hintText: "Enter CNIC",
                              errorText: _cnicField.errorText,
                            ),
                          ),
                          TextField(
                            controller: _bikeNumber.controller,
                            decoration: kInputFieldDecoration.copyWith(
                              hintText: "Enter bike number",
                              errorText: _bikeNumber.errorText,
                            ),
                          ),
                          TextField(
                            controller: _license.controller,
                            decoration: kInputFieldDecoration.copyWith(
                              hintText: "Enter license number",
                              errorText: _license.errorText,
                            ),
                          ),
                          TextField(
                            controller: _bikeRegNo.controller,
                            decoration: kInputFieldDecoration.copyWith(
                              hintText: "Enter bike registration number",
                              errorText: _bikeRegNo.errorText,
                            ),
                          ),
                          TextField(
                            readOnly: true,
                            controller: _bikeType.controller,
                            decoration: kInputFieldDecoration.copyWith(
                              hintText: "Select bike type",
                              errorText: _bikeType.errorText,
                              suffixIcon: DropdownButton(
                                  items: const [
                                    DropdownMenuItem(
                                      value: "50cc",
                                      child: Text("50cc"),
                                    ),
                                    DropdownMenuItem(
                                      value: "70cc",
                                      child: Text("70cc"),
                                    ),
                                    DropdownMenuItem(
                                      value: "125cc",
                                      child: Text("125cc"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _bikeType.controller.text = value!;
                                    });
                                  }),
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
                            onChanged: (value) => setState(() {
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
                                if (_emailField.controller.text.isEmpty ||
                                    _username.controller.text.isEmpty ||
                                    _passwordField.controller.text.isEmpty ||
                                    _cnicField.controller.text.isEmpty ||
                                    _bikeNumber.controller.text.isEmpty) {
                                  if (_emailField.controller.text.isEmpty) {
                                    setState(() {
                                      _emailField.errorText =
                                          "Email is required";
                                    });
                                  }
                                  if (_username.controller.text.isEmpty) {
                                    setState(() {
                                      _username.errorText = "Name is required";
                                    });
                                  }
                                  if (_bikeNumber.controller.text.isEmpty) {
                                    setState(() {
                                      _bikeNumber.errorText =
                                          "Restaurant name is required";
                                    });
                                  }
                                  if (_passwordField.controller.text.isEmpty) {
                                    setState(() {
                                      _passwordField.errorText =
                                          "Password is required";
                                    });
                                  }
                                  if (_cnicField.controller.text.isEmpty) {
                                    setState(() {
                                      _cnicField.errorText = "CNIC is required";
                                    });
                                  }
                                  if (_confirmPasswordField
                                      .controller.text.isEmpty) {
                                    setState(() {
                                      _confirmPasswordField.errorText =
                                          "Password didn't match";
                                    });
                                  }
                                  if (_phoneField.controller.text.isEmpty) {
                                    setState(() {
                                      _phoneField.errorText =
                                          "Phone Number is required";
                                    });
                                  }
                                  return;
                                }
                                if (_passwordField.controller.text !=
                                    _confirmPasswordField.controller.text) {
                                  setState(() {
                                    _confirmPasswordField.errorText =
                                        "Password didn't match";
                                  });
                                  return;
                                }
                                if (_phoneField.controller.text[0] == '0') {
                                  _phoneField.controller.text =
                                      _phoneField.controller.text.substring(1);
                                }
                                if (_phoneField.controller.text.length != 10) {
                                  setState(() {
                                    _phoneField.errorText =
                                        "Invalid phone number";
                                  });
                                  return;
                                }
                                if (_cnicField.controller.text.length != 13) {
                                  setState(() {
                                    _cnicField.errorText = "Invalid CNIC";
                                  });
                                  return;
                                }


                                if(await createAccount()){
                                  print("Account Status: Created But wait for approval");
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email verification required")));
                                  Navigator.popAndPushNamed(context, AuthenticationStatus.id);
                                }else{
                                  Utils.showPopup(context, "Error Creating Account", "Something went wrong please refer to Driver Signup Function");
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
                              if (_auth.currentUser != null) {
                                _auth.signOut();
                              }
                              Navigator.popAndPushNamed(context, LoginScreen.id);
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
