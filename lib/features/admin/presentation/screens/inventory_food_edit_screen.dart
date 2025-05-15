import 'dart:io';

// import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lu_cafe/features/admin/presentation/controllers/admin_panel_controller.dart';

import '../../../../core/utils/enums.dart';
import '../../../../core/utils/utils.dart';
import '../../../home/domain/food.dart';
import '../widgets/add_item_text_field.dart';

class InventoryFoodEditScreen extends ConsumerStatefulWidget {
  const InventoryFoodEditScreen({super.key, required this.food});
  final Food food;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InventoryFoodEditScreenState();
}

class _InventoryFoodEditScreenState
    extends ConsumerState<InventoryFoodEditScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _ratingController = TextEditingController();
  Category? _category;
  String? _imagePath;
  File? _imageFile;
  bool? _availability;

  String? _initialImage;
  String? _initialName;
  String? _initialDescription;
  int? _initialCalories;
  double? _initialRating;
  double? _initialPrice;
  Category? _initialCategory;
  bool? _initialAvailability;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialImage = widget.food.image;
    _initialName = widget.food.name;
    _initialDescription = widget.food.description;
    _initialCalories = widget.food.calories;
    _initialRating = widget.food.rating;
    _initialPrice = widget.food.price;
    _initialAvailability = widget.food.isAvailable;
    _initialCategory = widget.food.category;

    _nameController.text = _initialName!;
    _descriptionController.text = _initialDescription!;
    _priceController.text = _initialPrice.toString();
    _caloriesController.text = _initialCalories.toString();
    _ratingController.text = _initialRating.toString();
    _category = _initialCategory;
    _imagePath = _initialImage;
    _availability = _initialAvailability;

    _nameController.addListener(_lookForChanges);
    _descriptionController.addListener(_lookForChanges);
    _priceController.addListener(_lookForChanges);
    _caloriesController.addListener(_lookForChanges);
    _ratingController.addListener(_lookForChanges);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _caloriesController.dispose();
    _ratingController.dispose();

    super.dispose();
  }

  void _lookForChanges() {
    setState(() {});
  }

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

  void _updateFoodItem() {
    final updatedFood = Food(
      id: widget.food.id,
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      calories: int.tryParse(_caloriesController.text) ?? 0,
      rating: double.tryParse(_ratingController.text) ?? 0.0,
      category: _category!,
      image: _imagePath!,
      isAvailable: _availability!,
    );

    // update food item

    if (_imageFile != null) {
      ref.read(adminPanelControllerProvider.notifier).updateFood(
            context,
            food: updatedFood,
            imageFile: _imageFile,
          );
    } else {
      ref
          .read(adminPanelControllerProvider.notifier)
          .updateFood(context, food: updatedFood);

      Navigator.pop(context);
    }
  }

  void _deleteFoodItem() {
    ref
        .read(adminPanelControllerProvider.notifier)
        .deleteFood(context, food: widget.food);

    Navigator.pop(context);
  }

  final List<String> categories = ['Breakfast', 'Lunch', 'Snacks', 'Dinner'];
  String selectedCategory = 'Breakfast';

  @override
  Widget build(BuildContext context) {
    final isSomethingChanged = _initialName != _nameController.text ||
        _initialDescription != _descriptionController.text ||
        _initialPrice != double.tryParse(_priceController.text) ||
        _initialCalories != int.tryParse(_caloriesController.text) ||
        _initialRating != double.tryParse(_ratingController.text) ||
        _initialCategory != _category ||
        _initialImage != _imagePath ||
        _imageFile != null ||
        _initialAvailability != _availability;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Food Item'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDeleteDialog(
                context,
                title: 'Delete Food Item!',
                message:
                    'Are you sure you want to delete this food item?\nThis action cannot be undone!',
                onDelete: _deleteFoodItem,
              );
            },
            icon: Icon(
              Icons.delete_forever_outlined,
              size: 28,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                  borderRadius: BorderRadius.circular(10),
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
                        ? CachedNetworkImage(
                            imageUrl: widget.food.image,
                            fit: BoxFit.cover,
                          )
                        : Image.file(_imageFile!, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Gap(20),
            AddItemTextField(
              controller: _nameController,
              label: 'Food Name',
              hint: 'Enter Food Name',
              isNumber: false,
            ),
            AddItemTextField(
              controller: _descriptionController,
              label: 'Food Description',
              hint: 'Enter Food Description',
              isMultiline: true,
              isNumber: false,
            ),
            AddItemTextField(
              controller: _priceController,
              label: 'Food Price(in BDT)',
              hint: 'Enter Food Price',
            ),
            AddItemTextField(
              controller: _caloriesController,
              label: 'Food Calory',
              hint: 'Enter Food Calory',
            ),
            AddItemTextField(
              controller: _ratingController,
              label: 'Food Rating',
              hint: 'Enter Food Rating',
            ),
            // availability switch: in stock or out of stock (default: as per initial value)
            // two radio check buttons: in stock, out of stock

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Availability:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text('In Stock'),
                    Radio<bool>(
                      value: true,
                      groupValue: _availability,
                      onChanged: (value) {
                        setState(() {
                          _availability = value;
                        });
                      },
                    ),
                    Text('Out of Stock'),
                    Radio<bool>(
                      value: false,
                      groupValue: _availability,
                      onChanged: (value) {
                        setState(() {
                          _availability = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
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

                    value: _category!.type.toCategoryString(),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _category = value!.toCategoryEnum();
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Gap(10),
                  ElevatedButton(
                    onPressed: isSomethingChanged ? _updateFoodItem : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Update Food Item',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ))),
    );
  }
}
