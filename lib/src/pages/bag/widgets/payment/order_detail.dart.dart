import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        CartController,
        CustomerController,
        DateFormat,
        DefaultButton,
        ShortMessages,
        StyleColors,
        TransactionController,
        WatchContext;
import 'package:product_listing_pkg/src/pages/bag/widgets/payment/description_tile.dart';
import 'package:product_listing_pkg/utils/app_util.dart';

class OrderDetail extends StatelessWidget {
  const OrderDetail({super.key});

  @override
  Widget build(BuildContext context) {
    var order = context.watch<CartController>().order;
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: StyleColors.lukhuWhite,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.only(top: 20, right: 16, left: 16, bottom: 20),
      child: Column(
        children: [
          DescriptionTile(
            title: 'Lukhu Order Number',
            description: order?.orderId ?? '',
          ),
          DescriptionTile(
            title: 'Item Name',
            description: order?.name ?? '',
          ),
          DescriptionTile(
            title: 'Customer Name',
            description:
                context.watch<CustomerController>().customer?.name ?? '',
          ),
          DescriptionTile(
            title: 'Date',
            description: DateFormat('MMM dd, yyyy')
                .format(order?.createdAt ?? DateTime.now()),
          ),
          DescriptionTile(
            title: 'Time',
            description: DateFormat('hh:mm a')
                .format(order?.createdAt ?? DateTime.now()),
          ),
          DescriptionTile(
            title: 'Payment Method',
            description:
                context.watch<TransactionController>().invoice?.provider ?? '',
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 40),
            child: DescriptionTile(
              title: 'Amount',
              allowBold: true,
              description:
                  'KSh ${context.watch<CartController>().cartTotal.toStringAsFixed(0)}',
            ),
          ),
          DefaultButton(
            label: 'Download PDF',
            onTap: () {
              ShortMessages.showShortMessage(message: 'Coming soon.');
            },
            asssetIcon: AppUtil.documeDownloadIcon,
            packageName: AppUtil.packageName,
            color: StyleColors.lukhuWhite,
            textColor: StyleColors.lukhuBlue,
            boarderColor: StyleColors.lukhuBlue,
          )
        ],
      ),
    );
  }
}
