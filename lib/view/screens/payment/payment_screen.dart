import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glamcode/data/model/auth.dart';
import 'package:glamcode/data/repository/payment_repository.dart';
import 'package:glamcode/util/click_throttle.dart';
import 'package:glamcode/view/base/error_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../../../blocs/cart/cart_bloc.dart';
import '../../../blocs/cart_data/cart_data_bloc.dart';
import '../../../data/model/cart_data.dart';
import '../../../data/model/user.dart';
import '../../../util/dimensions.dart';
import '../../base/loading_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isFinished = false;
  int _selectedOption = -1;
  late Razorpay razorpay;
  PaymentRepository paymentRepository = PaymentRepository();
  ClickThrottle clickThrottle = ClickThrottle();
  bool loading = false;

  @override
  void initState() {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  bool _handlePayment(CartData cartData, User user) {
    print(num.parse(((cartData.amountToPay ?? 0) * 100).toStringAsFixed(2)));
    var options = {
      'description': 'Payment for Services',
      'image':
          'https://admin.glamcode.in/user-uploads/front-logo/1734a4db1beccdd08af159f42ade427a.png.webp',
      'currency': 'INR',
      'key': 'rzp_live_KBMHwbrgS5pC5c',
      'amount':
          num.parse(((cartData.amountToPay ?? 0) * 100).toStringAsFixed(2)),
      'name': 'Glam Code',
      'prefill': {
        'email': user.email ?? "",
        'contact': user.mobile ?? "",
        'name': user.name ?? "",
      },
      'retry': {'enabled': true, 'max_count': 1},
    };

    try {
      razorpay.open(options);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('SUCCESS: ${response.paymentId}');
    setState(() {
      loading = true;
    });
    CartData cartData =
        await context.read<CartDataBloc>().cartDataRepository.loadItems();
    _bookOrder(
        cartData, response.paymentId ?? "", cartData.amountToPay.toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('ERROR: ${response.code} | ${response.message}');
    Fluttertoast.showToast(msg: "${response.code} | ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  // void _handlePaymentUPI(Pay response) {
  //   print('ERROR: ${response.code} | ${response.message}');
  //   Fluttertoast.showToast(msg: "${response.code} | ${response.message}");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Options'),
      ),
      body: loading
          ? const LoadingScreen()
          : ListView(
              children: <Widget>[
                ListTile(
                  isThreeLine: false,
                  dense: true,
                  style: ListTileStyle.drawer,
                  tileColor: _selectedOption == 0
                      ? const Color(0xFFA854FC)
                      : Colors.white,
                  onTap: () {
                    setState(() {
                      _selectedOption = 0;
                    });
                  },
                  title: Text(
                    "Pay Online",
                    style: TextStyle(
                        fontSize: Dimensions.fontSizeLarge,
                        color:
                            _selectedOption == 0 ? Colors.white : Colors.black),
                  ),
                ),
                ListTile(
                  isThreeLine: false,
                  dense: true,
                  style: ListTileStyle.drawer,
                  tileColor: _selectedOption == 1
                      ? const Color(0xFFA854FC)
                      : Colors.white,
                  onTap: () {
                    setState(() {
                      _selectedOption = 1;
                    });
                  },
                  title: Text(
                    "Pay with cash",
                    style: TextStyle(
                        fontSize: Dimensions.fontSizeLarge,
                        color:
                            _selectedOption == 1 ? Colors.white : Colors.black),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BlocBuilder<CartDataBloc, CartDataState>(
        builder: (context, cartState) {
          if (cartState is CartDataLoading) {
            return const LoadingScreen();
          } else if (cartState is CartDataLoaded) {
            return loading
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SwipeableButtonView(
                      buttonText:
                          'Rs. ${cartState.cartData.amountToPay} SLIDE TO PAYMENT',
                      buttonWidget: Container(
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey,
                        ),
                      ),
                      activeColor: const Color(0xFF009C41),
                      isFinished: isFinished,
                      onWaitingProcess: () {
                        Future.delayed(const Duration(seconds: 3), () {
                          setState(() {
                            isFinished = true;
                          });
                        });
                      },
                      onFinish: () async {
                        // await Navigator.push(context,
                        //                 PageTransition(
                        //                     type: PageTransitionType.fade,
                        //                     child: DashboardScreen()));

                        //TODO: For reverse ripple effect animation
                        if (!clickThrottle.shouldProcessClick()) {
                          return;
                        }
                        if (_selectedOption == 1) {
                          setState(() {
                            loading = true;
                          });
                          _bookOrder(cartState.cartData, "",
                              cartState.cartData.amountToPay.toString());
                        } else if (_selectedOption == 0) {
                          User user = await Auth.instance.currentUser;
                          bool k = _handlePayment(cartState.cartData, user);
                          if (k) {}
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please select a payment method.",
                              gravity: ToastGravity.BOTTOM);
                        }
                        setState(() {
                          isFinished = false;
                        });
                      },
                    ),
                  );
            // : BottomAppBar(
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Expanded(
            //           child: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               const Text(
            //                 "Total Price",
            //                 style: TextStyle(fontWeight: FontWeight.bold),
            //               ),
            //               Text(
            //                 "Rs. ${cartState.cartData.amountToPay}",
            //                 style: const TextStyle(
            //                     fontWeight: FontWeight.bold),
            //               )
            //             ],
            //           ),
            //         ),
            //         Expanded(
            //           child: Padding(
            //             padding: const EdgeInsets.all(
            //                 Dimensions.PADDING_SIZE_SMALL),
            //             child: TextButton(
            //                 style: TextButton.styleFrom(
            //                     backgroundColor: const Color(0xFFA854FC),
            //                     minimumSize: const Size(double.infinity,
            //                         Dimensions.PADDING_SIZE_DEFAULT),
            //                     padding: const EdgeInsets.symmetric(
            //                         vertical:
            //                             Dimensions.PADDING_SIZE_DEFAULT),
            //                     textStyle: TextStyle(
            //                         fontSize:
            //                             Dimensions.fontSizeExtraLarge)),
            //                 onPressed: () async {
            //                   if (!clickThrottle.shouldProcessClick()) {
            //                     return;
            //                   }
            //                   if (_selectedOption == 1) {
            //                     setState(() {
            //                       loading = true;
            //                     });
            //                     _bookOrder(cartState.cartData, "");
            //                   } else if (_selectedOption == 0) {
            //                     User user = await Auth.instance.currentUser;
            //                     bool k = _handlePayment(
            //                         cartState.cartData, user);
            //                     if (k) {}
            //                   } else {
            //                     Fluttertoast.showToast(
            //                         msg: "Please select a payment method.",
            //                         gravity: ToastGravity.BOTTOM);
            //                   }
            //                 },
            //                 child: const Text("Place Request")),
            //           ),
            //         )
            //       ],
            //     ),
            //   );
          } else {
            return const CustomError();
          }
        },
      ),
    );
  }

  void _bookOrder(CartData cartData, String s, String amount) {
    final facebookAppEvents = FacebookAppEvents();
    paymentRepository.bookingsApi(cartData, "cash").then((result) {
      print(result);
      if (result != null) {
        context.read<CartBloc>().add(CartCleared());
        facebookAppEvents.logPurchase(
            amount: double.parse(amount), currency: "INR");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/payment-success', (Route<dynamic> route) => false,
            arguments: result);
      } else {
        Fluttertoast.showToast(
            msg: "Something went wrong!", gravity: ToastGravity.BOTTOM);
        Navigator.of(context).pop();
      }
    });
  }
}
