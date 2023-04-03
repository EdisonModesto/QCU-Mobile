import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qcu/services/AuthService.dart';

import '../../../common/orders/OrderDetailsView.dart';
import '../../../cosntants/colors.dart';
import '../../../services/FirestoreService.dart';
import '../../ViewModels/OrderViewModel.dart';

class SOrdersView extends ConsumerStatefulWidget {
  const SOrdersView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SOrdersViewState();
}

class _SOrdersViewState extends ConsumerState<SOrdersView> {

  Future<double> calculateTotal(items) async{
    var total = 0.0;
    for(var item in items){
      var itemData = await FirebaseFirestore.instance.collection("Items").doc(item.toString().split(",")[0]).get();
      total += double.parse(itemData.data()!["Price"]) * int.parse(items.toString().split(",")[1]);
    }

    return total;
  }


  Future<Map<String, dynamic>?> getData(id) async {
    var snapshot = await FirebaseFirestore.instance.collection("Items").doc(id).get();

    return snapshot.data();
  }

  @override
  Widget build(BuildContext context) {
    var orders = ref.watch(orderProvider);
    return DefaultTabController(
      length: 4,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
          child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage("assets/images/QCUlogo.jpg"),
                    ),
                    const SizedBox(width: 20,),
                    Text(
                      "Orders",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () async {
                        context.push("/convoList");
                      },
                      icon: Icon(
                        CupertinoIcons.chat_bubble_text,
                        color: AppColors().secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                TabBar(
                  indicator: BoxDecoration(
                    color: AppColors().primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  isScrollable: true,
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Text(
                        "To pay",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Preparing",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "For Pickup",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Completed",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: orders.when(
                    data: (data1){
                      var toPay = data1.docs.where((element) => element.data()["Status"] == "0" && element.data()["Seller"] == AuthService().getID()).toList();
                      var preparing = data1.docs.where((element) => element.data()["Status"] == "1" && element.data()["Seller"] == AuthService().getID()).toList();
                      var forPickup = data1.docs.where((element) => element.data()["Status"] == "2" && element.data()["Seller"] == AuthService().getID()).toList();
                      var completed = data1.docs.where((element) => element.data()["Status"] == "3" && element.data()["Seller"] == AuthService().getID()).toList();

                      return TabBarView(
                        children: [
                          ListView.separated(
                            itemCount: toPay.length,
                            itemBuilder: (context, index){
                              return FutureBuilder(
                                future: getData(toPay[index].data()["Items"][0].toString().split(",")[0]),
                                builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    return InkWell(
                                      onTap: (){
                                        showMaterialModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                            builder: (context){
                                              return OrderDetailsView(
                                                orderData: toPay[index],
                                              );
                                            }
                                        );
                                      },
                                      child: Container(
                                        height: 100,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  color: AppColors().primary,
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          snapshot.data!["Image"]
                                                      )
                                                  )
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data!["Name"],
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "Total Items: ${toPay[index].data()["Items"].length}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  FutureBuilder(
                                                      future: calculateTotal(toPay[index].data()["Items"]),
                                                      builder: (context, result) {
                                                        if(result.hasData){
                                                          return Text(
                                                            "Total Price: ${result.data}",
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          );
                                                        }
                                                        return const SizedBox();
                                                      }
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            IconButton(
                                              onPressed:(){
                                                FirestoreService().updateOrderStatus(toPay[index].id, "1");
                                              },
                                              icon: const Icon(
                                                CupertinoIcons.upload_circle,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                          ),
                          ListView.separated(
                            itemCount: preparing.length,
                            itemBuilder: (context, index){
                              return FutureBuilder(
                                future: getData(preparing[index].data()["Items"][0].toString().split(",")[0]),
                                builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    return InkWell(
                                      onTap: (){
                                        showMaterialModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                            builder: (context){
                                              return OrderDetailsView(
                                                orderData: preparing[index],
                                              );
                                            }
                                        );
                                      },
                                      child: Container(
                                        height: 100,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  color: AppColors().primary,
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          snapshot.data!["Image"]
                                                      )
                                                  )
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data!["Name"],
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "Total Items: ${preparing[index].data()["Items"].length}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  FutureBuilder(
                                                      future: calculateTotal(preparing[index].data()["Items"]),
                                                      builder: (context, result) {
                                                        if(result.hasData){
                                                          return Text(
                                                            "Total Price: ${result.data}",
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          );
                                                        }
                                                        return const SizedBox();
                                                      }
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            IconButton(
                                              onPressed:(){
                                                FirestoreService().updateOrderStatus(preparing[index].id, "2");
                                              },
                                              icon: const Icon(
                                                CupertinoIcons.upload_circle,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                          ),
                          ListView.separated(
                            itemCount: forPickup.length,
                            itemBuilder: (context, index){
                              return FutureBuilder(
                                future: getData(forPickup[index].data()["Items"][0].toString().split(",")[0]),
                                builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    return InkWell(
                                      onTap: (){
                                        showMaterialModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                            builder: (context){
                                              return OrderDetailsView(
                                                orderData: forPickup[index],
                                              );
                                            }
                                        );
                                      },
                                      child: Container(
                                        height: 100,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                color: AppColors().primary,
                                                borderRadius: BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    snapshot.data!["Image"]
                                                  )
                                                )
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data!["Name"],
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "Total Items: ${forPickup[index].data()["Items"].length}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  FutureBuilder(
                                                      future: calculateTotal(forPickup[index].data()["Items"]),
                                                      builder: (context, result) {
                                                        if(result.hasData){
                                                          return Text(
                                                            "Total Price: ${result.data}",
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          );
                                                        }
                                                        return const SizedBox();
                                                      }
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                          ),
                          ListView.separated(
                            itemCount: completed.length,
                            itemBuilder: (context, index){
                              return FutureBuilder(
                                future: getData(completed[index].data()["Items"][0].toString().split(",")[0]),
                                builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    return InkWell(
                                      onTap: (){
                                        showMaterialModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                            builder: (context){
                                              return OrderDetailsView(
                                                orderData: completed[index],
                                              );
                                            }
                                        );
                                      },
                                      child: Container(
                                        height: 100,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                color: AppColors().primary,
                                                borderRadius: BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: NetworkImage(snapshot.data!["Image"]),
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
                                                    snapshot.data!["Name"],
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "Total Items: ${completed[index].data()["Items"].length}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  FutureBuilder(
                                                      future: calculateTotal(completed[index].data()["Items"]),
                                                      builder: (context, result) {
                                                        if(result.hasData){
                                                          return Text(
                                                            "Total Price: ${result.data}",
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          );
                                                        }
                                                        return const SizedBox();
                                                      }
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                          ),

                        ],
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
                    },
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
