import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/services/TextFieldHandler.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  static const String id = "Add_Recipe_Screen";

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  late AssetImage recipeImage;
  TextFieldHandler recipeTitle = TextFieldHandler();
  TextFieldHandler recipePrice = TextFieldHandler();
  TextFieldHandler recipeDescription = TextFieldHandler();
  TextFieldHandler recipeQuantity = TextFieldHandler();

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
                    child: Icon(
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
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image_sharp,
                            color: Colors.grey,
                            size: 200,
                          ),
                          TextButton(
                              onPressed: () {}, child: const Text("Add Image")),
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
                          child: buildTextField("Price", recipePrice)
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildTextField("Description", recipeDescription, maxLines: 5, inputType: TextInputType.number),
                    const SizedBox(
                      height: 10,
                    ),
                    buildTextField("Quantity in kilogram", recipeQuantity, inputType: TextInputType.number),
                    const SizedBox(height: 10),
                    MaterialButton(
                      color: kAppBackgroundColor,
                      textColor: Colors.white,
                      onPressed: () {},
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

  TextField buildTextField(String hint, TextFieldHandler handler, {int maxLines = 1, TextInputType inputType = TextInputType.name }) {
    return TextField(
      controller: handler.controller,
      maxLines: maxLines,
      keyboardType: inputType,
      decoration: kInputFieldDecoration.copyWith(
        hintText: hint,
        border: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
      ),
    );
  }
}
