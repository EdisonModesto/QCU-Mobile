import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcu/common/payment/DeliveryDialog.dart';
import 'package:qcu/features/ViewModels/UserViewModel.dart';

import '../../cosntants/colors.dart';
import '../payment/PaymentView.dart';

class BuyNowSheet extends ConsumerStatefulWidget {
  const BuyNowSheet({
    required this.id,
    required this.sellerID,
    Key? key,
  }) : super(key: key);

  final String id;
  final String sellerID;

  @override
  ConsumerState createState() => _BuyNowSheetState();
}

class _BuyNowSheetState extends ConsumerState<BuyNowSheet> {
  int value = 1;

  @override
  Widget build(BuildContext context) {

    var user = ref.watch(userProvider);
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Buy Now",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Quantity",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if(value > 1){
                          value--;
                        }
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "-",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "$value",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        value++;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "+",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              user.when(
                  data: (data){
                    return ElevatedButton(
                      onPressed: () {
                        showDialog(context: context, builder: (builder){
                          return DeliveryDialog(
                            name: data.data()!["Name"],
                            cart: ["${widget.id},$value,${widget.sellerID}"],
                            address: data.data()!["Address"],
                            contact: data.data()!["Contact"],
                            sellerID: widget.sellerID,
                          );
                        });
                        // FirestoreService().addToCart(AuthService().getID(), widget.id, value);
                        // FirestoreService().addToBasket(widget.id, value);

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        fixedSize: Size(MediaQuery.of(context).size.width, 50),
                        backgroundColor: AppColors().primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Buy Now",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                  error: (error, stack){
                    return Center(
                      child: Text("Error"),
                    );
                  },
                  loading: (){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
