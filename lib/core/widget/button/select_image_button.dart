import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../function/pick_image.dart';

class SelectImageButton extends StatelessWidget {
  final IconData icon;
  final ImageSource imageSource;
  final void Function(File) onImageSelect;

  const SelectImageButton(
      {super.key,
      required this.icon,
      required this.imageSource,
      required this.onImageSelect});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        var file = await imagePicker(imageSource);
        if (file != null) {
          onImageSelect(file);
        }
      },
      icon: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(50)),
          child: Icon(icon)),
    );
  }
}
