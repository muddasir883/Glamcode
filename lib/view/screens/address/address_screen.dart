import 'package:flutter/material.dart';
import 'package:glamcode/data/api/api_helper.dart';
import 'package:glamcode/data/model/address_details_model.dart';
import 'package:glamcode/util/dimensions.dart';
import 'package:glamcode/view/base/error_screen.dart';
import 'package:glamcode/view/screens/address/edit_address.dart';

import '../../base/custom_divider.dart';
import '../../base/loading_screen.dart';
import '../cart/cart_screen.dart';
import 'getuserlocationmapscreen.dart';

class AddressDetailsScreen extends StatefulWidget {
  const AddressDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  late Future<AddressDetailsModel?> _future;

  @override
  void initState() {
    _future = DioClient.instance.getAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("SELECT ADDRESS"),
      // ),
      body: FutureBuilder<AddressDetailsModel?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.connectionState == ConnectionState.done) {
            AddressDetailsModel addressData = AddressDetailsModel();
            if (snapshot.hasData) {
              addressData = snapshot.data!;
              List<AddressDetails> addressList = [];
              Set<String> uniqueAddresses = {};
              for (var address in addressData.addressDetails!) {
                if (!uniqueAddresses.contains(address.addressHeading)) {
                  uniqueAddresses.add(address.addressHeading.toString());
                  addressList.add(address);
                }
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const CustomDivider(),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => SelectAddressScreen(
                        //       edit: false,
                        //       addressDetails: AddressDetails(),
                        //     ),
                        //   ),
                        // );
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => SearchLocationScreen(
                        //               edit: false,
                        //               addressDetails: AddressDetails(),
                        //             )));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GetUserLocationScreen(
                                      address:
                                          addressList[0].address.toString(),
                                      locAddress:
                                          addressList[0].address.toString(),
                                      latitude:
                                          addressList[0].lattitude!.toDouble(),
                                      longitude:
                                          addressList[0].lattitude!.toDouble(),
                                    )));
                      },
                      //   showDialog(
                      //     context: context,
                      //     builder: (ctx) => AlertDialog(
                      //       title: const Text("Disclosure"),
                      //       content: const Text("Glam Code collects location data to enable you to select addresses even when the app is always in use."),
                      //       actions: <Widget>[
                      //         ElevatedButton(
                      //           style: ButtonStyle(
                      //               backgroundColor: MaterialStateProperty.all(const Color(0xFFA854FC))
                      //           ),
                      //           onPressed: () {
                      //             Navigator.of(context).pop();
                      //           },
                      //           child: const Text("Deny"),
                      //         ),
                      //         ElevatedButton(
                      //           style: ButtonStyle(
                      //               backgroundColor: MaterialStateProperty.all(const Color(0xFFA854FC))
                      //           ),
                      //           onPressed: () {
                      //             Navigator.pop(context);
                      //             Navigator.of(context).push(
                      //               MaterialPageRoute(
                      //                 builder: (context) => SelectAddressScreen(
                      //                   edit: false,
                      //                   addressDetails: AddressDetails(),
                      //                 ),
                      //               ),
                      //             );
                      //             },
                      //           child: const Text("Approve"),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // },
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_DEFAULT),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add),
                            Text(
                              "Add New Address",
                              style: TextStyle(
                                  fontSize: Dimensions.fontSizeExtraLarge),
                            )
                          ],
                        ),
                      ),
                    ),
                    const CustomDivider(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: addressList.length,
                      itemBuilder: (context, index) {
                        return AddressTile(
                          addressDetails: addressList[index],
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return const CustomError();
            }
          } else {
            return const CustomError();
          }
        },
      ),
    );
  }
}

class AddressTile extends StatefulWidget {
  final AddressDetails addressDetails;

  const AddressTile({Key? key, required this.addressDetails}) : super(key: key);

  @override
  State<AddressTile> createState() => _AddressTileState();
}

class _AddressTileState extends State<AddressTile> {
  bool loading = false;
  bool primaryLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT),
      child: Card(
        elevation: 6,
        surfaceTintColor: Colors.white,
        shadowColor: const Color.fromARGB(255, 255, 5, 255),
        borderOnForeground: true,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text(
                  //   widget.addressDetails.addressHeading ?? "",
                  //   style: TextStyle(fontSize: Dimensions.fontSizeExtraLarge),
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${widget.addressDetails.addressHeading}",
                // "${widget.addressDetails.street ?? ""} ${widget.addressDetails.pincode ?? ""}",
                style: TextStyle(fontSize: Dimensions.fontSizeLarge),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditAddressScreen(
                            addressDetails: widget.addressDetails)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.edit,
                      color: Colors.purple,
                      size: Dimensions.fontSizeOverLarge,
                    ),
                  ),
                ),
                loading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : InkWell(
                        onTap: () {
                          setState(() {
                            loading = true;
                          });
                          DioClient.instance
                              .deleteAddress(
                                  widget.addressDetails.addressId?.toInt() ?? 0)
                              .then((value) {
                            print("delete value---$value");
                            setState(() {
                              loading = value;
                              DioClient.instance.getAddress();
                            });
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete_outline_outlined,
                            color: Colors.purple,
                          ),
                        ),
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.phone),
                        Text(
                          "${widget.addressDetails.callingCode ?? ""} ${widget.addressDetails.mobileNumber ?? ""}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: (widget.addressDetails.isPrimary != null &&
                                widget.addressDetails.isPrimary!)
                            ? null
                            : () async {
                                setState(() {
                                  primaryLoading = true;
                                });
                                await DioClient.instance
                                    .setPrimaryAddress(widget.addressDetails)
                                    .then((value) {
                                  Navigator.pop(context);
                                }

                                        // Navigator.of(context)
                                        //     .pushAndRemoveUntil(
                                        //         MaterialPageRoute(
                                        //             builder: (context) =>
                                        //                 const CartScreen()),
                                        //         ModalRoute.withName('/index'))

                                        );
                              },
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(const EdgeInsets.all(
                              Dimensions.PADDING_SIZE_DEFAULT)),
                          minimumSize:
                              WidgetStateProperty.all(const Size(0, 0)),
                          backgroundColor:
                              (widget.addressDetails.isPrimary != null &&
                                      widget.addressDetails.isPrimary!)
                                  ? WidgetStateProperty.all(Colors.grey)
                                  : WidgetStateProperty.all(
                                      const Color(0xFFA854FC)),
                        ),
                        child: primaryLoading
                            ? SizedBox(
                                height: Dimensions.fontSizeDefault,
                                width: Dimensions.fontSizeDefault,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : (widget.addressDetails.isPrimary != null &&
                                    widget.addressDetails.isPrimary!)
                                ? Text(
                                    "Primary",
                                    style: TextStyle(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Colors.white),
                                  )
                                : Text(
                                    "Make it primary",
                                    style: TextStyle(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Colors.white),
                                  ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExPageRoute<T> extends MaterialPageRoute<T> {
  ExPageRoute({required super.builder});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
