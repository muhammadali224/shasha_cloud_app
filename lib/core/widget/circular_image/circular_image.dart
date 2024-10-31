import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image_plus/flutter_cached_network_image_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/color.dart';

class CircularImage extends StatelessWidget {
  final String imageUrl;
  final double? radius;

  const CircularImage({super.key, required this.imageUrl, this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius ?? 30,
        backgroundColor: AppColor.primaryColor,
        child: CacheNetworkImagePlus(
          imageUrl: imageUrl,
          imageBuilder: (_, image) =>
              CircleAvatar(backgroundImage: image, radius: radius ?? 30),
          errorWidget: AutoSizeText(
            "H",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ));
  }
}
