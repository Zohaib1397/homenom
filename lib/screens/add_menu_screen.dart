import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/recipe_screen.dart';
import 'package:homenom/services/TextFieldHandler.dart';
import 'package:image_picker/image_picker.dart';

import '../services/Utlis.dart';
import '../structure/Menu.dart';

class AddMenuScreen extends StatefulWidget {
  const AddMenuScreen({super.key});

  static const String id = "Add_Menu_Screen";

  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  final imagePicker = ImagePicker();
  TextFieldHandler title = TextFieldHandler();
  File? image;
  bool isLoading = false;

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

  Future<void> createMenu() async {
    try {
      setState(() => isLoading = true);
      final auth = FirebaseAuth.instance;
      final newMenu = Menu(
        title: title.controller.text,
        recipeList: [],
        menuUrl: 'Temporary empty',
      );
      final menuDoc = FirebaseFirestore.instance
          .collection("Menu")
          .doc(auth.currentUser!.email);
      final snapshot = await menuDoc.get();
      if (snapshot.exists){
        await menuDoc.update({
          "menus" : FieldValue.arrayUnion([newMenu.toJson()]),
        });
      }else{
        await menuDoc.set({
          "menus" : FieldValue.arrayUnion([newMenu.toJson()]),
        });
      }
      setState(() => isLoading = false);
    } catch (e) {
      Utils.showPopup(context, "Database Error",
          "Something went wrong with firebase. Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        title: const Text("Add Menu"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        image == null
                            ? const Icon(
                                Icons.image_sharp,
                                color: Colors.grey,
                                size: 200,
                              )
                            : Image.file(
                                image!,
                                fit: BoxFit.cover,
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
                      ],
                    ),
                  ),
                  buildTextField("Title", title, hasErrorText: true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        color: kAppBackgroundColor,
                        onPressed: () async {
                          if (title.controller.text != "" && image != null) {
                            await createMenu();
                            Navigator.pop(context, true);
                          } else {
                            title.errorText = "Title & Image is required";
                          }
                        },
                        child: const Text(
                          "Create Menu",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? Scaffold(
                  backgroundColor: Colors.grey.withAlpha(200),
                )
              : Container(),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ],
      ),
    );
  }
}
