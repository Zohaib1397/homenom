import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  static const String id = "Add_Recipe_Screen";

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
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
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
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
                          Icon(Icons.image_sharp, color: Colors.grey, size: 200,),
                          TextButton(onPressed: (){}, child: const Text("Add Image")),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            decoration: kInputFieldDecoration.copyWith(
                              hintText: "Title",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1
                                )
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            decoration: kInputFieldDecoration.copyWith(
                              hintText: "Price",
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    TextField(
                      keyboardType: TextInputType.number,
                      maxLines: 5,
                      decoration: kInputFieldDecoration.copyWith(
                        hintText: "Description",
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
