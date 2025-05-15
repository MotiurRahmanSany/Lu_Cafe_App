import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_cafe/core/common/constants/appwrite_constants.dart';
import 'package:lu_cafe/core/utils/utils.dart';
import 'package:lu_cafe/features/admin/data/admin_panel_repository.dart';

import '../../../home/data/home_repository.dart';
import '../../../home/domain/food.dart';

final continuouslyFetchFoodByCategoryProvider = FutureProvider.autoDispose
    .family<List<Food>, String>((ref, category) async {
  final repository = ref.read(homeRepositoryProvider);
  final result = await repository.fetchFoodByCategory(category: category);

  return result.map((doc) => Food.fromMap(doc.data)).toList();
});

final adminPanelControllerProvider =
    StateNotifierProvider<AdminPanelController, bool>((ref) {
  return AdminPanelController(
    adminPanelRepository: ref.watch(adminPanelRepositoryProvider),
  );
});

class AdminPanelController extends StateNotifier<bool> {
  final AdminPanelRepository _adminPanelRepository;

  AdminPanelController({
    required AdminPanelRepository adminPanelRepository,
  })  : _adminPanelRepository = adminPanelRepository,
        super(false);

  // create food
  // get the food model, and image file
  // upload the image file, get the image id
  // create the food model with the image id converted to link
  // save the food model to the database
  void createFood(BuildContext context,
      {required Food food, required File imageFile}) async {
    state = true;
    final imageUploadResult =
        await _adminPanelRepository.uploadImage(file: imageFile);

    imageUploadResult.fold((l) {
      showDialogMesssageToUser(
        context,
        title: 'Error!',
        message: 'Error on uploading image',
      );
    }, (r) async {
      final imageLink = AppwriteConstants.imageLinkFromId(
          r, AppwriteConstants.foodImageBucketId);
      final foodWithImage = food.copyWith(image: imageLink);

      // save the food model to the database
      final createFood = await _adminPanelRepository.createFoodItem(
        food: foodWithImage,
      );
      state = false;
      createFood.fold((l) {
        showDialogMesssageToUser(
          context,
          title: 'Error!',
          message: 'Error on creating food item',
        );
      }, (r) {
        showDialogMesssageToUser(
          context,
          title: 'Success!',
          message: 'Food item created successfully!',
        );
      });
    });
  }

  // update food
  // get the food model, and image file(optional)
  // if image file is provided, then get the old image id from the food model image link
  //delete the old image from the storage
  // upload the new image file, get the image id
  // update the food model with the image id converted to link

  void updateFood(BuildContext context,
      {required Food food, File? imageFile}) async {
    if (imageFile != null) {
      final oldImageLink = food.image;

      final oldImageId = AppwriteConstants.extractImageIdFromLink(oldImageLink);

      state = true;
      final imageDeleteResult =
          await _adminPanelRepository.deleteImage(fileId: oldImageId!);
      state = false;

      imageDeleteResult.fold((l) {
        showDialogMesssageToUser(
          context,
          title: 'Error!',
          message: 'Error on deleting old image',
        );
      }, (r) async {
        state = true;
        final newImageUploadResult =
            await _adminPanelRepository.uploadImage(file: imageFile);
        state = false;
        newImageUploadResult.fold((l) {
          showDialogMesssageToUser(context,
              title: 'Error!', message: 'Error on uploading new image');
        }, (r) async {
          final imageLink = AppwriteConstants.imageLinkFromId(
              r, AppwriteConstants.foodImageBucketId);
          final foodWithImage = food.copyWith(image: imageLink);

          // save the food model to the database
          state = true;
          final updateFood = await _adminPanelRepository.updateFoodItem(
            food: foodWithImage,
          );

          state = false;
          updateFood.fold((l) {
            showDialogMesssageToUser(
              context,
              title: 'Error!',
              message: 'Error on updating food item',
            );
          }, (r) {
            showDialogMesssageToUser(
              context,
              title: 'Success!',
              message: 'Food item updated successfully!',
            );
          });
        });
      });
    } else {
      state = true;
      final updatedFood =
          await _adminPanelRepository.updateFoodItem(food: food);
      state = false;

      updatedFood.fold((l) {
        showDialogMesssageToUser(
          context,
          title: 'Error!',
          message: 'Error on updating food item',
        );
      }, (r) {
        showDialogMesssageToUser(
          context,
          title: 'Success!',
          message: 'Food item updated successfully!',
        );
      });
    }
  }

  // delete food
  // get the food model
  // get the image id from the food model image link
  // delete the image from the storage
  // delete the food model from the database

  void deleteFood(BuildContext context, {required Food food}) async {
    final imageId = AppwriteConstants.extractImageIdFromLink(food.image);

    state = true;
    final imageDeleteResult =
        await _adminPanelRepository.deleteImage(fileId: imageId!);
    state = false;

    imageDeleteResult.fold((l) {
      showDialogMesssageToUser(
        context,
        title: 'Error!',
        message: 'Error on deleting image',
      );
    }, (r) async {
      state = true;
      final deleteFood =
          await _adminPanelRepository.deleteFoodItem(foodId: food.id);
      state = false;

      deleteFood.fold((l) {
        showDialogMesssageToUser(
          context,
          title: 'Error!',
          message: 'Error on deleting food item',
        );
      }, (r) {
        showDialogMesssageToUser(
          context,
          title: 'Success!',
          message: 'Food item deleted successfully!',
        );
      });
    });
  }
}
