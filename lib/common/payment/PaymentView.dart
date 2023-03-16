import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:google_fonts/google_fonts.dart";
import "package:qcu/cosntants/colors.dart";

import "../../services/FirestoreService.dart";

class PaymentView extends ConsumerWidget {
  const PaymentView({
    required this.cart,
    required this.name,
    required this.contact,
    required this.address,
    Key? key,
  }) : super(key: key);

  final cart;
  final name;
  final contact;
  final address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          height: 400,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors().primary,
                  ),
                ),
                const SizedBox(height: 25,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Total Amount: ",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 25,),
                Text(
                  "Please pay the amount to the following Gcash Number: ",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 25,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Gcash: 0912345678\nName: Seller Name",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          FirestoreService().createOrder(
                            cart,
                            name,
                            contact,
                            address,

                          );
                          Fluttertoast.showToast(msg: "Order placed successfully");
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Confirm",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppColors().primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}