import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path;

void showDialogMesssageToUser(BuildContext context,
    {required String title, required String message}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        backgroundColor: Colors.white,
        elevation: 10,
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

void showDeleteDialog(BuildContext context,
    {required String title,
    required String message,
    required void Function() onDelete}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title),
        elevation: 10,
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              // style: TextStyle(color: AppColor.primaryColor),
            ),
          ),
          TextButton(
            onPressed: onDelete,
            child: Text('Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ],
      );
    },
  );
}

String getNameFromEmail(String email) {
  return email.split('@').first;
}

void showMessageToUser(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        showCloseIcon: true,
      ),
    );
}

final _picker = ImagePicker();
Future<XFile?> pickImageFromGallery() async {
  final image = await _picker.pickImage(source: ImageSource.gallery);

  return image;
}

Future<XFile?> takeImageWithCamera() async {
  final image = await _picker.pickImage(source: ImageSource.camera);

  return image;
}

Future<bool> showDeleteCartItemDialog(
  BuildContext context,
  void Function() onDelete,
) async {
  final confirm = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Delete Item'),
        elevation: 10,
        content: Text('Are you sure you want to delete this item from cart?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              'Cancel',
            ),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.of(context).pop(true);
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
  return confirm ?? false;
}

void showLogoutConfirmDialog(BuildContext context, void Function() onLogout) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Logout'),
        elevation: 10,
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
            ),
          ),
          TextButton(
            onPressed: onLogout,
            child: Text('Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ],
      );
    },
  );
}

Future<String> compressImageFile(String filePath) async {
  final tempDir = await path.getTemporaryDirectory();
  final imgExt = filePath.split('.').last;
  final targetPath =
      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.$imgExt';
  final result = await FlutterImageCompress.compressAndGetFile(
    filePath,
    targetPath,
    quality: 50, // 50% compression
  );
  if (result == null) {
    throw Exception("Image compression failed.");
  }

  return result.path;
}
