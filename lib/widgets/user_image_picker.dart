import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  void Function(File? pickedImage)? imagePickFn;
  //void Function(Uint8List? webImage)? webImagePickFn;
  UserImagePicker({
    this.imagePickFn, // this.webImagePickFn
  });

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  //Uint8List? _webImage;

  final ImagePicker _picker = ImagePicker();

  void _pickImage(ImageSource src) async {
    if (!kIsWeb) {
      final pickedImageFile =
          //Due to small size of the picture so we don't need high quality
          await _picker.pickImage(source: src, imageQuality: 50, maxWidth: 150);

      if (pickedImageFile != null) {
        setState(() {
          _pickedImage = File(pickedImageFile.path);
        });
        widget.imagePickFn!(_pickedImage!);
      } else {
        print(
            'No image selected\nthis message from _UserImagePickerState class');
      }
    }
    // try {
    //   if (kIsWeb) {
    //     XFile? pickedImageFile =
    //         //Due to small size of the picture so we don't need high quality
    //         await _picker.pickImage(
    //             source: src, imageQuality: 50, maxWidth: 150);

    //     if (pickedImageFile != null) {
    //       var f = await _pickedImage!.readAsBytes();
    //       setState(() {
    //         _webImage = f;
    //       });
    //       widget.webImagePickFn!(_webImage);
    //     } else {
    //       print(
    //           'No image selected\nthis message from _UserImagePickerState class');
    //     }
    //   }
    //} catch (e) {
    //   print(e.toString());
    // }
    else {
      print('something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              //  kIsWeb && _webImage != null
              //     ? Image.memory(_webImage!, fit: BoxFit.fill).image
              //     : kIsWeb && _webImage == null
              //         ? null
              //         :!kIsWeb &&
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _pickImage(ImageSource.gallery),
          child: 
              const Text(
                'Add Image',
              )
        )
      ],
    );
  }
}
