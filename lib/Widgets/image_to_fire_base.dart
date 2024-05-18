// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//
// class FirebaseImageUploader extends StatefulWidget {
//   final List<File> imageFiles;
//
//   const FirebaseImageUploader({Key? key, required this.imageFiles}) : super(key: key);
//
//   @override
//   _FirebaseImageUploaderState createState() => _FirebaseImageUploaderState();
// }
//
// class _FirebaseImageUploaderState extends State<FirebaseImageUploader> {
//   final ScreenshotController controller = ScreenshotController();
//
//   Future<void> uploadImageToFirebase(File imageFile) async {
//     final bytes = await controller.capture();
//     final base64String = base64Encode(bytes as List<int>);
//     final storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.png');
//     await storageRef.putString(base64String,
//         format: PutStringFormat.base64,
//         metadata: SettableMetadata(contentType: 'image/png'));
//     String downloadUrl =
//     (await storageRef.getDownloadURL()).toString();
//     print('Uploaded to Firebase Storage successfully. Download URL: $downloadUrl');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Image Uploader'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: widget.imageFiles.length,
//                 itemBuilder: (context, index) {
//                   return Image.file(widget.imageFiles[index]);
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final imageFile = await controller.capture();
//                 setState(() {
//                   widget.imageFiles.add(imageFile as File);
//                 });
//               },
//               child: Text('Capture and Add Image'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 for (final imageFile in widget.imageFiles) {
//                   await uploadImageToFirebase(imageFile);
//                 }
//               },
//               child: Text('Upload Images to Firebase Storage'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
