import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/add_menu_screen.dart';
import 'package:homenom/services/TextFieldHandler.dart';
import 'package:image_picker/image_picker.dart';

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
  final currentUser = FirebaseAuth.instance.currentUser!;
  TextFieldHandler recipeTitle = TextFieldHandler();
  TextFieldHandler recipePrice = TextFieldHandler();
  TextFieldHandler recipeDescription = TextFieldHandler();
  TextFieldHandler recipeQuantity = TextFieldHandler();
  TextFieldHandler deliveryPrice = TextFieldHandler();
  int selectedMenuIndex = -1;

  Future<void> getImageFromGallery(ImageSource source) async {
    try {
      final imagePick = await imagePicker.pickImage(source: source);
      final imageTemporary = File(imagePick!.path);
      setState(() => image = imageTemporary);
    } catch (e) {
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
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Menu")
                        .doc(currentUser.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.data() != null) {
                          final data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          final menuList = data['menus'] as List<dynamic>;
                          return Container(
                            decoration: BoxDecoration(
                                color: kAppBackgroundColor,
                                borderRadius: BorderRadius.circular(29),
                                border:
                                    Border.all(width: 2, color: Colors.black)),
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView.builder(
                                  itemCount: menuList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final recipeList = menuList[index]
                                        ['recipeList'] as List<dynamic>;
                                    return Card(
                                      color: index == selectedMenuIndex
                                          ? Colors.grey
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedMenuIndex = index;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            title: Text(
                                              menuList[index]['title'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Image(
                                                image: AssetImage(
                                                    "assets/temporary/food_background.jpg"),
                                              ),
                                            ),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text("Recipes"),
                                                Text("${recipeList.length}")
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          );
                        }
                      }
                      return Container();
                    },
                  ),
                  MaterialButton(
                    color: kAppBackgroundColor,
                    onPressed: () async {
                      final answer = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddMenuScreen()))
                          as bool;
                      if (answer) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Menu added successfully")));
                      }
                    },
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
                    buildTextField("Delivery Price", deliveryPrice,
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
    if (recipeTitle.controller.text != "" &&
        recipePrice.controller.text != "" &&
        recipeDescription.controller.text != "" &&
        recipeQuantity.controller.text != "" &&
        deliveryPrice.controller.text != "" &&
        image != null) {
      if (selectedMenuIndex == -1) {
        Utils.showPopup(context, "Menu Selection Error",
            "Please select a menu to add the recipe");
        return;
      }
      try {
        final auth = FirebaseAuth.instance;
        final recipe = Recipe(
          id: "Temporary Empty",
          url: "Temporary Empty",
          name: recipeTitle.controller.text,
          description: recipeDescription.controller.text,
          price: double.parse(recipePrice.controller.text),
          quantity: int.parse(recipeQuantity.controller.text),
          rating: 0,
          deliveryPrice: double.parse(deliveryPrice.controller.text),
          numberSold: 0,
        );
        final recipeDoc = FirebaseFirestore.instance
            .collection("Menu")
            .doc(auth.currentUser!.email);
        final snapshot = await recipeDoc.get();
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          final menuList = data['menus'] as List<dynamic>;

          if (selectedMenuIndex >= 0 && selectedMenuIndex < menuList.length) {
            final selectedMenu = menuList[selectedMenuIndex];

            final recipeList = selectedMenu['recipeList'] as List<dynamic>;

            // Add the new recipe to the recipeList
            recipeList.add({
              'id': recipe.id,
              'url': recipe.url,
              'name': recipe.name,
              'description': recipe.description,
              'price': recipe.price,
              'quantity': recipe.quantity,
              'rating': recipe.rating,
              'deliveryPrice': recipe.deliveryPrice,
              'numberSold' : recipe.numberSold,
            });

            // Update the recipeList in the selected menu
            selectedMenu['recipeList'] = recipeList;

            // Update the entire menuList in the Firestore document
            await recipeDoc.update({
              'menus': menuList,
            });

            print(
                "Recipe added successfully to the menu at index $selectedMenuIndex");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                    "Recipe Added Successfully. You can add more..")));
            recipeTitle.controller.text = "";
            recipePrice.controller.text = "";
            recipeDescription.controller.text = "";
            recipeQuantity.controller.text = "";
            deliveryPrice.controller.text = "";
          } else {
            print("Invalid selectedMenuIndex");
          }
        }
      } catch (e) {
        Utils.showPopup(context, "Database Connectivity Issue",
            "Something went wrong. Error: $e");
      }
    } else {
      Utils.showPopup(context, "Fields error",
          "You need to fill all the fields to create Recipe.");
    }
  }
}
