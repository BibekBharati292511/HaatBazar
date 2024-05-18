// // firebase_storage_service.dart
//
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
//
// class FirebaseStorageService {
//   static Future<List<String>> uploadImages(List<File> imageFiles) async {
//     List<String> uploadedUrls = [];
//     try {
//       for (File file in imageFiles) {
//         // Create a reference to the storage path
//         Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');
//
//         // Upload the file to Firebase Storage
//         UploadTask uploadTask = storageReference.putFile(file);
//
//         // Await the completion of the upload task
//         await uploadTask.whenComplete(() async {
//           // Get the download URL for the file
//           String downloadURL = await storageReference.getDownloadURL();
//           uploadedUrls.add(downloadURL);
//         });
//       }
//       return uploadedUrls;
//     } catch (e) {
//       // Handle errors
//       print('Error uploading images: $e');
//       return [];
//     }
//   }
// }
