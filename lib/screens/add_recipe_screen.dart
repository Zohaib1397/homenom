
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/services/TextFieldHandler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/Utlis.dart';
import '../structure/Recipe.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  static const String id = "Add_Recipe_Screen";

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  late AssetImage recipeImage;
  final imagePicker = ImagePicker();
  File? image;

  TextFieldHandler recipeTitle = TextFieldHandler();
  TextFieldHandler recipePrice = TextFieldHandler();
  TextFieldHandler recipeDescription = TextFieldHandler();
  TextFieldHandler recipeQuantity = TextFieldHandler();

  Future<void> getImageFromGallery(ImageSource source) async{
    try{
      final imagePick = await imagePicker.pickImage(
          source: source);
      final imageTemporary = File(imagePick!.path);
      setState(() => image = imageTemporary);
    }catch (e){
      Utils.showPopup(context, "Image Error", "Error: $e");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Recipe"),
        backgroundColor: kAppBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Select Menu",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: const Text(
                          "BackCAPS Food",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image(
                              image: AssetImage(
                                  "assets/temporary/food_background.jpg"),
                            )),
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: kAppBackgroundColor,
                    onPressed: () {},
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Recipe Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      child: Column(
                        children: [
                          image == null ? const Icon(
                            Icons.image_sharp,
                            color: Colors.grey,
                            size: 200,
                          ) : Image.file(image!,fit: BoxFit.cover,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () => getImageFromGallery(ImageSource.gallery),
                                  child: const Text("Add Image")),
                              TextButton(
                                onPressed: () => getImageFromGallery(ImageSource.camera),
                                child: const Text("Capture Image"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: buildTextField("Title", recipeTitle),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            flex: 1,
                            child: buildTextField("Price", recipePrice)),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildTextField("Description", recipeDescription,
                        maxLines: 5, inputType: TextInputType.number),
                    const SizedBox(
                      height: 10,
                    ),
                    buildTextField("Quantity in kilogram", recipeQuantity,
                        inputType: TextInputType.number),
                    const SizedBox(height: 10),
                    MaterialButton(
                      color: kAppBackgroundColor,
                      textColor: Colors.white,
                      onPressed: () {
                        addRecipeToDatabase();
                      },
                      child: const Text(
                        "Create Recipe",
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Future<void> addRecipeToDatabase() async {
    if (recipeTitle.controller.text!="" && recipePrice.controller.text!="" && recipeDescription.controller.text!="" && recipeQuantity.controller.text!=""){
      try{
        final auth = await FirebaseAuth.instance;
        final recipe = Recipe(
          id: "Temporary Empty",
          url: "Temporary Empty",
          name: recipeTitle.controller.text,
          description: recipeDescription.controller.text,
          price: double.parse(recipePrice.controller.text),
          quantity: int.parse(recipeQuantity.controller.text),
          rating: 0,
        );
        await FirebaseFirestore.instance.collection("Recipes").doc(auth.currentUser!.email).set(recipe.toJson());
        print("recipe added successfully");
      }catch (e){
        Utils.showPopup(context, "Database Connectivity Issue", "Something went wrong. Error: $e");
      }
    }else{
      Utils.showPopup(context, "Fields error", "You need to fill all the fields to create Recipe.");
    }
  }
}
