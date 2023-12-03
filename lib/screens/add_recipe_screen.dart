import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/add_menu_screen.dart';
import 'package:homenom/screens/widgets/build_cache_image.dart';
import 'package:homenom/services/menu_controller.dart';
import 'package:homenom/structure/TextFieldHandler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/Utils.dart';
import '../structure/Menu.dart';
import '../structure/Recipe.dart';
import 'package:http/http.dart' as http;

class AddRecipeScreen extends StatefulWidget {
  int? index;
  dynamic recipe;
  int? menuIndex;

  AddRecipeScreen({super.key, this.index, this.recipe, this.menuIndex});

  static const String id = "Add_Recipe_Screen";

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final menuControllerProvider = MenuControllerProvider();
  late AssetImage recipeImage;
  final imagePicker = ImagePicker();
  File? image;
  final currentUser = FirebaseAuth.instance.currentUser!;
  TextFieldHandler recipeTitle = TextFieldHandler();
  TextFieldHandler recipePrice = TextFieldHandler();
  TextFieldHandler recipeDescription = TextFieldHandler();
  TextFieldHandler recipeQuantity = TextFieldHandler();
  TextFieldHandler deliveryPrice = TextFieldHandler();
  int selectedMenuIndex = 0;
  bool isLoading = false;

  Future<void> getImageFromGallery(ImageSource source) async {
    try {
      final imagePick = await imagePicker.pickImage(source: source);
      final imageTemporary = File(imagePick!.path);
      setState(() => image = imageTemporary);
    } catch (e) {
      Utils.showPopup(context, "Image Error", "Error: $e");
    }
  }

  Widget _createMenuCardWidget(
      Menu menu, int index, ValueChanged<int> onSelect) {
    return Card(
      color: index != selectedMenuIndex
          ? Theme.of(context).colorScheme.surface
          : Theme.of(context).colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          onSelect(index);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              menu.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: generateCachedImage(url: menu.menuUrl, clip: 16),
            // leading: ClipRRect(
            //   borderRadius: BorderRadius.circular(16),
            //   child: Image(
            //     image: NetworkImage(menu.menuUrl),
            //   ),
            // ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Recipes"),
                Text("${menu.recipeList.length}")
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      selectedMenuIndex = widget.index!;
    }
    if (widget.recipe != null) {
      recipeTitle.controller.text = widget.recipe!['name'];
      recipePrice.controller.text = widget.recipe!['price'].toString();
      recipeDescription.controller.text = widget.recipe!['description'];
      recipeQuantity.controller.text = widget.recipe!['quantity'].toString();
      deliveryPrice.controller.text =
          widget.recipe!['deliveryPrice'].toString();
      selectedMenuIndex = widget.menuIndex!;
      downloadImageAndGetFile();
    }
  }

  Future<void> downloadImageAndGetFile() async {
    final url = widget.recipe!['url']; // Replace with your image URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;

      final file = File('$tempPath/${recipePrice.controller.text}.jpg');
      await file.writeAsBytes(bytes);

      setState(() {
        image = file;
      });
    } else {
      // Handle error
      print('Failed to download image: ${response.statusCode}');
    }
  }
  Future<String> getImageURL() async {
    setState(() => isLoading = true);
    try {
      String path = "menus/recipes/${FirebaseAuth.instance.currentUser!.email}/${recipeTitle.controller.text}.jpg";
      final reference = FirebaseStorage.instance.ref().child(path);
      print("Getting reference: $reference");
      UploadTask? uploadTask = reference.putFile(image!);
      final snapshot = await uploadTask.whenComplete((){});

      final urlDownload = await snapshot.ref.getDownloadURL();

      setState(() => isLoading = false);
      return urlDownload;
    } catch (error) {
      setState(() => isLoading = false);
      return "Unexpected Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text(widget.recipe == null ? "Add Recipe" : "Edit Recipe"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Consumer<MenuControllerProvider>(
                        builder: (context, menuControllerProvider, _) {
                          List<Menu> menuList = menuControllerProvider.menuList;
                          return Column(
                            children: List.generate(menuList.length, (index) {
                              return _createMenuCardWidget(menuList[index], index,
                                  (selectedIndex) {
                                setState(() {
                                  selectedMenuIndex = selectedIndex;
                                });
                              });
                            }),
                          );
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
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
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.file(
                                        image!,
                                        fit: BoxFit.cover,
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
                                child: buildTextField("Price", recipePrice,
                                    inputType: TextInputType.number)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        buildTextField("Description", recipeDescription,
                            maxLines: 5),
                        const SizedBox(
                          height: 10,
                        ),
                        buildTextField("Quantity in kilogram", recipeQuantity,
                            inputType: TextInputType.number),
                        const SizedBox(height: 10),
                        buildTextField("Delivery Price", deliveryPrice,
                            inputType: TextInputType.number),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: () {
                            addRecipeToDatabase();
                          },
                          child: Text(
                            widget.recipe != null?
                            "Edit Recipe" : "Create Recipe",
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
          isLoading
              ? Scaffold(
            backgroundColor: Colors.black.withAlpha(200),
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
      if (widget.recipe != null && widget.index != null) {
        if (widget.index != selectedMenuIndex) {
          final confirmChange = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm Menu Change"),
                content: const Text(
                    "Are you sure you want to add this recipe to another Menu?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Confirm"),
                  ),
                ],
              );
            },
          );
          if (!confirmChange) {
            return;
          }
        }
        String url = await getImageURL();
        if(url == "Unexpected Error"){
          Utils.showPopup(context, "Network Error", "Please check your network connection.");
          return;
        }
        final menuID = await Provider.of<MenuControllerProvider>(context, listen: false).getMenuId(selectedMenuIndex);
        final recipe = Recipe(
          id: widget.recipe!['id'],
          url: url,
          name: recipeTitle.controller.text,
          description: recipeDescription.controller.text,
          price: double.parse(recipePrice.controller.text),
          quantity: int.parse(recipeQuantity.controller.text),
          rating: widget.recipe!['rating'],
          menuID: menuID,
          deliveryPrice: double.parse(deliveryPrice.controller.text),
          numberSold: widget.recipe!['numberSold'],
        );
        try {
          final result = await Provider.of<MenuControllerProvider>(context, listen: false)
                  .updateRecipeInList(recipe, widget.menuIndex!, widget.index!);
          print("Recipe update Status : $result");
          print(
              "Recipe added successfully to the menu at menu index $selectedMenuIndex");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text("Recipe Updated Successfully. Add more recipe..")));
          // Navigator.pop(context)
          setState(() {
            recipeTitle.controller.text = "";
            recipePrice.controller.text = "";
            recipeDescription.controller.text = "";
            recipeQuantity.controller.text = "";
            deliveryPrice.controller.text = "";
            selectedMenuIndex = 0;
            image = null;
          });
          return;
        } catch (e) {
          Utils.showPopup(context, "Database Connectivity Issue",
              "Something went wrong. Error: $e");
          return;
        }
      }
      String url = await getImageURL();
      if(url == "Unexpected Error"){
        Utils.showPopup(context, "Network Error", "Please check your network connection.");
        return;
      }
      final menuID = await Provider.of<MenuControllerProvider>(context, listen: false).getMenuId(selectedMenuIndex);
      final recipe = Recipe(
        id: UniqueKey().toString(),
        url: url,
        name: recipeTitle.controller.text,
        description: recipeDescription.controller.text,
        price: double.parse(recipePrice.controller.text),
        quantity: int.parse(recipeQuantity.controller.text),
        rating: 0,
        menuID: menuID,
        deliveryPrice: double.parse(deliveryPrice.controller.text),
        numberSold: 0,
      );
      try {
        Provider.of<MenuControllerProvider>(context, listen: false)
            .addRecipeToMenu(recipe, selectedMenuIndex);

        print(
            "Recipe added successfully to the menu at index $selectedMenuIndex");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Recipe Added Successfully. You can add more..")));
        setState(() {
          recipeTitle.controller.text = "";
          recipePrice.controller.text = "";
          recipeDescription.controller.text = "";
          recipeQuantity.controller.text = "";
          deliveryPrice.controller.text = "";
          selectedMenuIndex = 0;
          image = null;
        });
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
