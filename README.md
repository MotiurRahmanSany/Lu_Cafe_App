# LU Cafeteria

A Flutter application for food ordering in a university cafeteria environment. This app provides both client and admin interfaces for a streamlined cafeteria management experience.

## Features

### Client Features

- **Browse Menu**: View food items categorized by breakfast, lunch, snacks, and dinner
- **Food Details**: See detailed information about food items including price, calories, and ratings
- **Cart Management**: Add/remove items and adjust quantities in cart
- **Order Placement**: Complete checkout process with order details
- **Order Tracking**: View order status and delivery animation
- **User Profile**: Manage account information

### Admin Features

- **CRUD Operations**: Add, view, edit, and delete food items
- **Inventory Management**: Update food availability, prices, and details
- **Order Tracking**: View and manage customer orders
- **Sales Dashboard**: See sales statistics and customer information

## Technology Stack

- **Frontend**: Flutter (Dart)
- **Backend as a Service**: Appwrite
- **State Management**: Riverpod
- **Navigation**: Go Router
- **Image Management**: Cached Network Image
- **Animations**: Lottie
- **Image Handling**: Image Picker, Flutter Image Compress

## Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/YOUR_USERNAME/lu_cafe.git
   cd lu_cafe
   ```

2. **Create the Appwrite Constants file**

   Important: The `appwrite_constants.dart` file is not included in the repository as it contains sensitive information. You need to create this file at:

   ```
   lib/core/common/constants/appwrite_constants.dart
   ```

   With the following structure:

   ```dart
   class AppwriteConstants {
     static const String projectId = 'YOUR_PROJECT_ID';
     static const String endPoint = 'https://cloud.appwrite.io/v1';

     static const String databaseId = 'YOUR_DATABASE_ID';
     static const String foodCollectionId = 'YOUR_FOOD_COLLECTION_ID';
     static const String usersCollectionId = 'YOUR_USERS_COLLECTION_ID';
     static const String cartCollectionId = 'YOUR_CART_COLLECTION_ID';
     static const String adminCollectionId = 'YOUR_ADMIN_COLLECTION_ID';

     static const String foodImageBucketId = 'YOUR_FOOD_IMAGE_BUCKET_ID';

     // return the image link from the imageId and bucketId which is viewable through network request
     static String imageLinkFromId(String imageId, String bucketId) {
       return '$endPoint/storage/buckets/$bucketId/files/$imageId/view?project=$projectId';
     }

     // extract the imageId from the image link
     static String? extractImageIdFromLink(String imageLink) {
       final RegExp regExp = RegExp(r'\/files\/([^\/]+)');
       final match = regExp.firstMatch(imageLink);
       if (match != null && match.groupCount > 0) {
         return match.group(1); // This will return the imageId
       }
       return null; // Return null if imageId is not found
     }
   }
   ```

3. **Setup Appwrite**

   - Create an Appwrite project
   - Set up database collections as per the IDs defined in constants
   - Create a storage bucket for food images

4. **Install dependencies**

   ```bash
   flutter pub get
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Appwrite Setup Guide

To use this application, you will need to set up the following in your Appwrite instance:

1. **Create a Project**
2. **Database Collections**:
   - Food Collection (with fields for name, price, description, image, category, etc.)
   - Users Collection (for client users)
   - Cart Collection (to store cart items)
   - Admin Collection (for admin users)
3. **Storage**:
   - Create a bucket for food images

## Usage Notes

- The payment functionality in this app is currently simulated and does not process real payments.
- Cash on Delivery is the only available payment method.

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check issues page.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Notes

This project is a demonstration of Flutter development with Appwrite integration. It showcases:

- Client-server architecture using Appwrite BaaS
- State management with Riverpod
- UI design for food ordering applications
- Admin dashboard implementation
- User authentication and authorization
