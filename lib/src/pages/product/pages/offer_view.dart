import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AppBarType,
        DefaultBackButton,
        DeliveryStatus,
        LuhkuAppBar,
        ReadContext,
        StyleColors,
        WatchContext;
import 'package:product_listing_pkg/src/controller/offer_controller.dart';
import 'package:product_listing_pkg/src/controller/product_controller.dart';
import '../widgets/offer_container.dart';

class OfferView extends StatelessWidget {
  const OfferView({super.key});
  static const routeName = 'offer_view';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: LuhkuAppBar(
          appBarType: AppBarType.other,
          backAction: const DefaultBackButton(),
          title: Text(
            'Your Offers',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: StyleColors.lukhuDark1,
            ),
          ),
          bottomHeight: kTextTabBarHeight,
          bottom: Column(
            children: [
              TabBar(
                  indicatorColor: StyleColors.lukhuDark,
                  labelColor: StyleColors.lukhuDark,
                  labelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700),
                  unselectedLabelColor: StyleColors.lukhuDark,
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
                  tabs: const [
                    Tab(
                      text: 'Active Offers',
                    ),
                    Tab(
                      text: 'Past Offers',
                    ),
                  ]),
            ],
          ),
        ),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: TabBarView(children: [
            OfferContainer(
              type: DeliveryStatus.approved,
              future: context.read<OfferController>().getUserOffers(
                  userId: context.read<ProductController>().userId!),
              offers: context.watch<OfferController>().similarOffers[
                      context.read<ProductController>().userId!] ??
                  {},
              refresh: () {
                refresh(context);
              },
              text: 'You have no past offers available.',
            ),
            OfferContainer(
              text: 'You have no past offers available.',
              
              future: context.read<OfferController>().getUserOffers(
                    userId: context.read<ProductController>().userId!,
                  ),
              offers: context.watch<OfferController>().similarOffers[
                      context.read<ProductController>().userId!] ??
                  {},
              refresh: () {
                refresh(context);
              },
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> refresh(BuildContext context) async {
    context.read<OfferController>().getUserOffers(
        userId: context.read<ProductController>().userId!,
        isRefreshMode: true,
        limit: 10);
  }
}
