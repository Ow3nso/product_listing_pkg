import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AccountsController,
        AppBarType,
        BlurDialogBody,
        BottomCard,
        ConfirmationCard,
        DefaultBackButton,
        DefaultInputField,
        DefaultTextBtn,
        Helpers,
        LuhkuAppBar,
        MpesaFields,
        PaymentCommand,
        PaymentController,
        ReadContext,
        ShortMessageType,
        ShortMessages,
        StyleColors,
        Uuid,
        WatchContext;
import 'package:product_listing_pkg/product_listing_pkg.dart';
import 'package:product_listing_pkg/src/controller/checkout_controller.dart';
import 'package:product_listing_pkg/src/pages/bag/widgets/payment/cart_images_display.dart';
import 'package:product_listing_pkg/src/pages/bag/widgets/payment/payment_display.dart';
import 'package:product_listing_pkg/utils/app_util.dart';

import '../widgets/cart_message.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});
  static const routeName = 'checkout_view';

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  late PaymentCommand _paymentCommand;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _paymentCommand = PaymentCommand(context);
    });
  }

  @override
  void dispose() {
    _paymentCommand.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            appBar: LuhkuAppBar(
              color: Theme.of(context).colorScheme.onPrimary,
              enableShadow: true,
              backAction: const DefaultBackButton(),
              appBarType: AppBarType.other,
              centerTitle: true,
              title: Expanded(
                child: Text(
                  "Payment",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: StyleColors.lukhuDark1,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.18,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DefaultTextBtn(
                    onTap: () {
                      _shareBag(context);
                    },
                    child: Text(
                      "Send Bag",
                      style: TextStyle(
                        color: StyleColors.lukhuBlue,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: context.watch<CartController>().cart.isNotEmpty
                  ? ListView(
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 10, right: 16, left: 16),
                          child: CartDisplay(),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: PaymentDisplay(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 16, left: 16, bottom: 30),
                          child: DefaultInputField(
                            label: "Discount Code",
                            onChange: (value) =>
                                context.read<CheckoutController>().setState(),
                            controller: context
                                .read<CheckoutController>()
                                .discountController,
                            suffix:
                                context.watch<CheckoutController>().hasDiscount
                                    ? DefaultTextBtn(
                                        onTap: () {},
                                        child: Text(
                                          'Apply',
                                          style: TextStyle(
                                            color: StyleColors.lukhuBlue,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ))
                                    : null,
                            hintText: 'Enter discount code here',
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (p0) {},
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    )
                  : const CartMessage(),
            ),
            bottomSheet: MediaQuery.of(context).viewInsets.bottom > 0
                ? null
                : BottomCard(
                    label: "Process Payment",
                    onTap: context
                                .watch<AccountsController>()
                                .selectedMethod
                                .keys
                                .isNotEmpty &&
                            context.watch<CartController>().cart.keys.isNotEmpty
                        ? () {
                            context.read<CartController>().initPayment = true;
                            _initOrderProcess(context);
                          }
                        : null,
                  ),
          ),
          if (context.watch<CartController>().initPayment)
            const Positioned(
              child: LoaderCard(
                title:
                    'You’re almost there! We are processing your order payment',
              ),
            ),
        ],
      ),
    );
  }

  void _initOrderProcess(BuildContext context) {
    var payMethod =
        context.read<AccountsController>().selectedMethod.values.first;
    context.read<CartController>().initPayment = true;
    try {
      context.read<CartController>().countOrderDocuments().then((orderCount) {
        context.read<CartController>().orderCount = orderCount;
        context.read<PaymentController>().initiatePayment(
          post: {
            MpesaFields.amount:
                '${context.watch<CartController>().cartTotal.toInt()}',
            MpesaFields.phoneNumber: payMethod.account ?? '',
            MpesaFields.reference: const Uuid().v4(),
          },
          type: payMethod.type!,
        ).then((value) {
          Future.delayed(const Duration(milliseconds: 3500));
          if (value || context.read<PaymentController>().isPaymentComplete) {
            _paymentCommand.execute(true);
            return;
          }
          context.read<CartController>().initPayment = false;
          ShortMessages.showShortMessage(
            message: 'Something went wrong!. Please try again.',
            type: ShortMessageType.error,
          );
        });
      });
    } catch (e) {
      context.read<CartController>().initPayment = false;
      Helpers.debugLog('An error occurred: $e');
    }
  }

  void _shareBag(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return BlurDialogBody(
          bottomDistance: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ConfirmationCard(
              title: "Scan to order",
              assetImage: AppUtil.shareBag,
              packageName: AppUtil.packageName,
              color: StyleColors.lukhuBlue0,
              colorShadeSecond: StyleColors.lukhuBlue10,
              description:
                  "Ask the customer to scan this code or share the Bag link with them to order",
              height: 650,
              primaryLabel: "Share Link",
              secondaryLabel: "Cancel",
              descriptionChild: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
                  height: 340,
                  decoration: BoxDecoration(
                    color: StyleColors.shadeColor1,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(),
                ),
              ),
              onPrimaryTap: () {},
              onSecondaryTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }
}
