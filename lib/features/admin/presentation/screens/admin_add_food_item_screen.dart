import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lu_cafe/core/utils/enums.dart';
import 'package:lu_cafe/features/admin/presentation/controllers/admin_panel_controller.dart';

import '../../../../core/common/ui/custom_button.dart';
import '../../../../core/utils/utils.dart';
import '../../../home/domain/food.dart';
import '../widgets/add_item_text_field.dart';

class AdminAddFoodItemScreen extends ConsumerStatefulWidget {
  const AdminAddFoodItemScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminAddFoodItemScreenState();
}

class _AdminAddFoodItemScreenState
    extends ConsumerState<AdminAddFoodItemScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final caloriesController = TextEditingController();
  final ratingController = TextEditingController();
  // final categoryController = TextEditingController();
  // final isAvailableController = TextEditingController();
  File? _imageFile;

  final List<String> categories = ['Breakfast', 'Lunch', 'Snacks', 'Dinner'];
  String selectedCategory = 'Breakfast';

  void _imageFromGallery() async {
    final selectedImage = await pickImageFromGallery();

    if (selectedImage != null) {
      final compressedImagePath = await compressImageFile(selectedImage.path);
      setState(() {
        _imageFile = File(compressedImagePath);
      });
    }
  }

  void _imageFromCamera() async {
    final takenImage = await takeImageWithCamera();

    if (takenImage != null) {
      final compressedImagePath = await compressImageFile(takenImage.path);
      setState(() {
        _imageFile = File(compressedImagePath);
      });
    }
  }

  void _showPickImageOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Select Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image_outlined),
                title: Text('From Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _imageFromGallery();
                },
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              ListTile(
                leading: Icon(Icons.camera_alt_outlined),
                title: Text('With Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _imageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addFoodItem() {
    final name = nameController.text;
    final description = descriptionController.text;
    final price = priceController.text;
    final calories = caloriesController.text;
    final rating = ratingController.text;

    if (name.isEmpty ||
        description.isEmpty ||
        price.isEmpty ||
        calories.isEmpty ||
        rating.isEmpty) {
      showMessageToUser(context,
          message: 'Please fill all the fields to create a food item');
      return;
    }

    if (_imageFile == null) {
      showMessageToUser(context, message: 'Please select an image');
      return;
    }

    final food = Food(
      id: '',
      name: name,
      description: description,
      price: double.parse(price),
      calories: int.parse(calories),
      rating: double.parse(rating),
      category: selectedCategory.toCategoryEnum(),
      isAvailable: true,
      image: '',
    );

    ref
        .read(adminPanelControllerProvider.notifier)
        .createFood(context, food: food, imageFile: _imageFile!);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isCreatingFood = ref.watch(adminPanelControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Add Food Item'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Upload food Item Picture',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(20),
                Center(
                  child: GestureDetector(
                    onTap: _showPickImageOptions,
                    child: ClipRRect(
                      child: Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          // color: Colors.grey,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _imageFile == null
                            ? Icon(Icons.add_a_photo_outlined)
                            : Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                Gap(20),
                AddItemTextField(
                  controller: nameController,
                  label: 'Food Name',
                  hint: 'Enter Food Name',
                  isNumber: false,
                ),
                AddItemTextField(
                  controller: descriptionController,
                  label: 'Food Description',
                  hint: 'Enter Food Description',
                  isMultiline: true,
                  isNumber: false,
                ),
                AddItemTextField(
                  controller: priceController,
                  label: 'Food Price(in BDT)',
                  hint: 'Enter Food Price',
                ),
                AddItemTextField(
                  controller: caloriesController,
                  label: 'Food Calory',
                  hint: 'Enter Food Calory',
                ),
                AddItemTextField(
                  controller: ratingController,
                  label: 'Food Rating',
                  hint: 'Enter Food Rating',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select Category',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Gap(10),
                      DropdownButtonFormField(
                        borderRadius: BorderRadius.circular(20),
                        // padding: EdgeInsets.all(10),
                        elevation: 5,

                        value: selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value.toString();
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Gap(10),
                      CustomButton(
                        button: 'Add Food Item',
                        onPressed: _addFoodItem,
                        isLoading: isCreatingFood,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
