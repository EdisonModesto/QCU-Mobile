import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qcu/common/payment/DeliveryDialog.dart';
import 'package:qcu/common/payment/PaymentView.dart';
import 'package:qcu/features/ViewModels/UserViewModel.dart';

import '../../cosntants/colors.dart';
import '../../services/AdMob/ad_helper.dart';
import '../../services/FirestoreService.dart';

class CartView extends ConsumerStatefulWidget {
  const CartView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {

  List<int> itemQuantity = List.filled(100, 1);
  List<double> itemPrice = List.filled(100, 0);

  double total = 0.0;

  Future<double> computeTotal() async {
    await Future.delayed(const Duration(seconds: 1));
    double total = 0;
    for (int i = 0; i < itemPrice.length; i++) {
      total = total + ( itemPrice[i] * itemQuantity[i]);
    }
    return total;
  }

  // TODO: Add _bannerAd
  BannerAd? _bannerAd;


  bool isSame = true;

  @override
  void initState() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var cart = ref.watch(userProvider);

    return cart.when(
      data: (data){
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                  decoration: BoxDecoration(
                    color: AppColors().primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage("assets/images/QCUlogo.jpg"),
                          ),
                          const SizedBox(width: 20,),
                          Text(
                            "Shopping Cart",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Expanded(
                  child: ListView.separated(
                    itemCount: data.data()!['Cart'].length,
                    padding: const EdgeInsets.only(top: 0, bottom: 0, left: 30, right: 30),
                    itemBuilder: (context, index){
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("Items").doc(data.data()!['Cart'][index].toString().split(",")[0]).snapshots(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            itemQuantity[index] = int.parse(data
                                .data()!["Cart"][index]
                                .toString()
                                .split(",")[1]);
                            itemPrice[index] = double.parse(
                                snapshot.data!.data()!["Price"].toString());
                            return Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(snapshot.data!['Image']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!['Name'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          snapshot.data!['Description'].toString().substring(0, 13) + "...",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "PHP ${snapshot.data!['Price']}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: (){
                                      FirestoreService().updateCartQuantity(
                                          data
                                              .data()!["Cart"][index]
                                              .toString()
                                              .split(",")[0],
                                          itemQuantity[index] - 1,
                                          data.data()!["Cart"][index]);
                                      itemQuantity[index] =
                                          itemQuantity[index] - 1;
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: AppColors().primary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${itemQuantity[index]}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: (){
                                      FirestoreService().updateCartQuantity(
                                          data
                                              .data()!["Cart"][index]
                                              .toString()
                                              .split(",")[0],
                                          itemQuantity[index] + 1,
                                          data.data()!["Cart"][index]);
                                      itemQuantity[index] =
                                          itemQuantity[index] + 1;
                                      print(itemQuantity[index]);
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: AppColors().primary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                var sellerId = data.data()!['Cart'][0].toString().split(",")[2];
                                for (int i = 0; i < data.data()!['Cart'].length; i++) {
                                  if(data.data()!['Cart'][i].toString().split(",")[2] != sellerId ){
                                    isSame = false;
                                    Fluttertoast.showToast(msg: "You can only checkout items from one seller");
                                    return;
                                  }
                                }
                                if (data.data()!["Cart"].isNotEmpty && data.data()!["Name"].toString() != "" && data.data()!["Address"].toString() != "" && data.data()!["Contact"].toString() != "" && isSame)  {
                                  showDialog(context: context, builder: (builder){
                                    return DeliveryDialog(
                                      name: data.data()!["Name"],
                                      cart: data.data()!["Cart"],
                                      address: data.data()!["Address"],
                                      contact: data.data()!["Contact"],
                                      sellerID: data.data()!['Cart'][0].toString().split(",")[2]
                                    );
                                  });
                                } else {
                                  Fluttertoast.showToast(msg: "No items in basket or you have not filled up your profile yet");
                                }
                              },
                              child: Container(
                                height: 55,
                                color: AppColors().primary,
                                child: Center(
                                  child: Text(
                                    "Checkout",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: FutureBuilder(
                                future: computeTotal(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      "Total: PHP ${snapshot.data}",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
              ]
          ),
        );
      },
      error: (error, stack){
        return const Center(
          child: Text("Error"),
        );
      },
      loading: (){
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
