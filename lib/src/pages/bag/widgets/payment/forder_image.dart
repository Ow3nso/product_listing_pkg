import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show DiscountCard, ImageCard, StyleColors, WatchContext;
import 'package:product_listing_pkg/src/controller/cart_controller.dart';

import '../../../../../utils/app_util.dart';

class OrderImage extends StatelessWidget {
  const OrderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          color: StyleColors.lukhuWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8))),
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImageCard(
                fit: BoxFit.fill,
                image: context.watch<CartController>().storeImage.values.first,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 10),
            child: SizedBox(
              width: 90,
              child: DiscountCard(
                color: StyleColors.shadeColor1,
                description: 'Successful',
                style: TextStyle(
                  color: StyleColors.lukhuSuccess200,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                iconImage: AppUtil.dotIcon,
                packageName: AppUtil.packageName,
              ),
            ),
          )
        ],
      ),
    );
  }
}
