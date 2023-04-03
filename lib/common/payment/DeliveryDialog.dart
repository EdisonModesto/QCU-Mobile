import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcu/common/chat/MessageModel.dart';
import 'package:qcu/common/payment/PaymentView.dart';
import 'package:qcu/cosntants/colors.dart';
import 'package:qcu/services/AuthService.dart';
import 'package:qcu/services/ChatService.dart';
import 'package:qcu/services/FirestoreService.dart';

class DeliveryDialog extends ConsumerWidget {
  const DeliveryDialog({
    required this.cart,
    required this.name,
    required this.contact,
    required this.address,
    required this.sellerID,
    Key? key,
  }) : super(key: key);

  final cart;
  final name;
  final contact;
  final address;
  final sellerID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delivery Method",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors().primary,
                  )
                ),
                Text(
                  "What delivery method would you like to use?",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        showDialog(context: context, builder: (builder){
                          return AlertDialog(
                            title: const Text("Order Pickup Confirmation"),
                            content: const Text("Are you sure you want to confirm your order? \n\nYour order will be placed and you will be redirected to seller chat."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Close"),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirestoreService().createOrder(
                                      cart,
                                      name,
                                      contact,
                                      address,
                                      "pickup",
                                      "cash",
                                      sellerID,
                                  );
                                  Fluttertoast.showToast(msg: "Order placed successfully!");
                                  ChatService().sendMessage(
                                      Message(
                                          id: AuthService().getID(),
                                          name: name,
                                          message: "Hi! I would like to discuss my order for pickup. Thank you!",
                                          time: DateTime.now()),
                                      AuthService().getID(),
                                      sellerID
                                  );
                                  context.pushNamed("chat", params: {"seller": sellerID, "buyer": AuthService().getID()});
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Confirm"),
                              ),
                            ],
                          );
                        });
                      },
                      child: Text(
                        "Pickup",
                        style: TextStyle(
                          color: AppColors().primary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        //Navigator.of(context).pop();
                        showDialog(context: context, builder: (builder){
                          return AlertDialog(
                            title: const Text("Mode of Payment"),
                            content: const Text("What mode of payment would you like to use?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  FirestoreService().createOrder(
                                      cart,
                                      name,
                                      contact,
                                      address,
                                      "delivery",
                                      "cash",
                                      sellerID,
                                  );
                                  Fluttertoast.showToast(msg: "Order placed successfully!");
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("COD"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await showDialog(context: context, builder: (builder){
                                    return PaymentView(
                                      cart: cart,
                                      name: name,
                                      contact: contact,
                                      address: address,
                                      sellerID: sellerID,
                                    );
                                  });
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("GCash"),
                              ),
                            ],
                          );
                        });
                      },
                      child: Text(
                        "Delivery",
                        style: TextStyle(
                          color: AppColors().primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}