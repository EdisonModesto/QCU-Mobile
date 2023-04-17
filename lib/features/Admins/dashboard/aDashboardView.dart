import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcu/features/ViewModels/FeedViewModel.dart';
import 'package:qcu/features/ViewModels/OrderViewModel.dart';

import '../../../cosntants/colors.dart';
import '../../ViewModels/BuyerViewModel.dart';
import '../../ViewModels/SellerViewModel.dart';

class ADashboardView extends ConsumerStatefulWidget {
  const ADashboardView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ADashboardViewState();
}

class _ADashboardViewState extends ConsumerState<ADashboardView> {


  Future<String> getName(id) async {
    var user = await FirebaseFirestore.instance.collection("Users").doc(id).get();
    return user.data()!["Name"];
  }

  Future<double> calculateTotal(items) async{
    var total = 0.0;
    for(var item in items){
      var itemData = await FirebaseFirestore.instance.collection("Items").doc(item.toString().split(",")[0]).get();
      total += double.parse(itemData.data()!["Price"]) * double.parse(item.toString().split(",")[1]);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {

    var orders = ref.watch(orderProvider);
    var buyer = ref.watch(buyerProvider);
    var seller = ref.watch(sellerProvider);
    var product = ref.watch(feedProvider);

    return orders.when(
      data: (data){
        return SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.8,
          child: Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage(
                                "assets/images/QCUlogo.jpg"),
                            backgroundColor: Colors.transparent,


                          ),
                          const SizedBox(width: 20,),
                          Text(
                            "Dashboard",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 25,),
                  /*         Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total Revenue: ",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "500PHP",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors().primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25,),*/
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Total Users",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5,),
                              buyer.when(
                                data: (data){
                                  return Text(
                                    data.docs.length.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors().primary,
                                    ),
                                  );
                                },
                                error: (error, stackTrace){
                                  return Text(
                                    "0",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors().primary,
                                    ),
                                  );
                                },
                                loading: (){
                                  return Text(
                                    "0",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors().primary,
                                    ),
                                  );
                                }
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Total Sellers",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5,),
                              seller.when(
                                  data: (data){
                                    return Text(
                                      data.docs.length.toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors().primary,
                                      ),
                                    );
                                  },
                                  error: (error, stackTrace){
                                    return Text(
                                      "0",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors().primary,
                                      ),
                                    );
                                  },
                                  loading: (){
                                    return Text(
                                      "0",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors().primary,
                                      ),
                                    );
                                  }
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Total Products",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5,),
                              product.when(
                                  data: (data){
                                    return Text(
                                      data.docs.length.toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors().primary,
                                      ),
                                    );
                                  },
                                  error: (error, stackTrace){
                                    return Text(
                                      "0",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors().primary,
                                      ),
                                    );
                                  },
                                  loading: (){
                                    return Text(
                                      "0",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors().primary,
                                      ),
                                    );
                                  }
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25,),
                  Text(
                    "Recent Transactions",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 25,),
                  orders.when(
                    data: (data){
                      return Expanded(
                        child: ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemCount: data.docs.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "User: ",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 5,),
                                              Text(
                                                "Seller: ",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 5,),
                                              Text(
                                                "No. of Products: ",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 5,),
                                              Text(
                                                "Date & time purchase: ",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 5,),
                                              Text(
                                                "Date & time delivery: ",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 5,),
                                              Text(
                                                "Total: ",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                FutureBuilder(
                                                    future: getName(data.docs[index].data()['User']),
                                                    builder: (context, snapshot1) {
                                                      if (snapshot1.hasData) {
                                                        return Text(
                                                          snapshot1.data.toString(),
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500,
                                                            color: AppColors().primary,
                                                          ),
                                                        );
                                                      }
                                                      return Text(
                                                        "Loading",
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          color: AppColors().primary,
                                                        ),
                                                      );
                                                    }
                                                ),
                                                const SizedBox(height: 5,),
                                                FutureBuilder(
                                                    future: getName(data.docs[index].data()['Seller']),
                                                    builder: (context, snapshot1) {
                                                      if (snapshot1.hasData) {
                                                        return Text(
                                                          snapshot1.data.toString(),
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500,
                                                            color: AppColors().primary,
                                                          ),
                                                        );
                                                      }
                                                      return Text(
                                                        "Loading",
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          color: AppColors().primary,
                                                        ),
                                                      );
                                                    }
                                                ),
                                                const SizedBox(height: 5,),
                                                Text(
                                                  data.docs[index].data()['Items'].length.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors().primary,
                                                  ),
                                                ),
                                                const SizedBox(height: 5,),
                                                Text(
                                                  data.docs[index].data()['DatePurchase'].toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors().primary,
                                                  ),
                                                ),
                                                const SizedBox(height: 5,),
                                                Text(
                                                  data.docs[index].data()['DateDelivered'].toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors().primary,
                                                  ),
                                                ),
                                                const SizedBox(height: 5,),
                                                FutureBuilder(
                                                  future: calculateTotal(data.docs[index].data()['Items']),
                                                  builder: (context, snapshot1) {
                                                    if (snapshot1.hasData) {
                                                      return Text(
                                                        "PHP ${snapshot1.data.toString()}",
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          color: AppColors().primary,
                                                        ),
                                                      );
                                                    }
                                                    return Text(
                                                      "Loading",
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        color: AppColors().primary,
                                                      ),
                                                    );
                                                  }
                                                )
                                              ]
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                              );},
                            separatorBuilder: (context, index) => const SizedBox(height: 10,)
                        ),
                      );
                    },
                    error: (error, stack){
                      return Center(
                        child: Text(error.toString()),
                      );
                    },
                    loading: (){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  ),
                ]
            ),
          ),
        );
      },
      error: (error, stack){
        return Center(
          child: Text(error.toString()),
        );
      },
      loading: (){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }
}