import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qcu/common/orders/CancelDialog.dart';
import 'package:qcu/common/settings/settingsSheet.dart';
import 'package:qcu/features/Users/profile/uEditProfileDialog.dart';
import 'package:qcu/services/AuthService.dart';
import 'package:qcu/services/FirestoreService.dart';

import '../../../common/authentication/AuthView.dart';
import '../../../common/cart/CartView.dart';
import '../../../common/orders/OrderDetailsView.dart';
import '../../../cosntants/colors.dart';
import '../../../services/AdMob/ad_helper.dart';
import '../../ViewModels/AuthViewModel.dart';
import '../../ViewModels/OrderViewModel.dart';
import '../../ViewModels/UserViewModel.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {

  Future<double> calculateTotal(items) async{
    var total = 0.0;
    for(var item in items){
      var itemData = await FirebaseFirestore.instance.collection("Items").doc(item.toString().split(",")[0]).get();
      total += double.parse(itemData.data()!["Price"]) * int.parse(items.toString().split(",")[1]);
    }

    return total;
  }

  Future<Map<String, dynamic>?> getResource(id) async {
    var snapshot = await FirebaseFirestore.instance.collection("Items").doc(id).get();
    return snapshot.data();
  }

  // TODO: Add _bannerAd
  BannerAd? _bannerAd;

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

    var authState = ref.watch(authStateProvider);
    var orders = ref.watch(orderProvider);

    return authState.when(
      data: (data){
        var user = ref.watch(userProvider);
        return DefaultTabController(
          length: 4,
          child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
              child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage("assets/images/QCUlogo.jpg"),
                              backgroundColor: Colors.transparent,
                            ),
                            const SizedBox(width: 20,),
                            Text(
                              "Profile",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                FirestoreService().convertToSeller(AuthService().getID());
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.store_mall_directory_outlined,
                                color: AppColors().primary,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showMaterialModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (context) => const CartView(),
                                );
                              },
                              icon: Icon(
                                Icons.shopping_cart_outlined,
                                color: AppColors().primary,
                              ),
                            ),
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
                        )
                      ],
                    ),
                    const SizedBox(height: 20,),
                    data?.uid != null ?
                    user.when(
                      data: (data1){
                        return Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors().primary,
                              radius: 35,
                              backgroundImage:data1.data()!["Image"] == "" ?
                              const NetworkImage("http://via.placeholder.com/300x300") :
                              NetworkImage(data1.data()!["Image"]),
                            ),
                            const SizedBox(width: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data1.data()!["Name"],
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: TextButton(
                                    onPressed: () {
                                      showDialog(context: context, builder: (builder){
                                        return UEditProfileDialog(data: data1,);
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(0),
                                    ),
                                    child: Text(
                                      "Edit Profile",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors().primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                showMaterialModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (builder){
                                  return SettingsSheet();
                                },);
                                //AuthService().signOut();
                              },
                              icon: Icon(
                                Icons.settings,
                                color: AppColors().primary,
                              ),
                            ),
                          ],
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
                    )

                        :

                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors().primary,
                          radius: 35,
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "You need an account",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              child: TextButton(
                                onPressed: () {
                                  context.go("/auth");
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(0),
                                ),
                                child: Text(
                                  "Login or Signup",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors().primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Text(
                      "My Orders",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
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
                      child: data?.uid == null ?
                      Center(
                        child: Text(
                          "Login to continue",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ) :
                      orders.when(
                        data: (data1){
                          var userID = AuthService().getID();
                          var toPay = data1.docs.where((element) => element.data()["Status"] == "0" && element.data()["User"] == userID).toList();
                          var preparing = data1.docs.where((element) => element.data()["Status"] == "1" && element.data()["User"] == userID).toList();
                          var forPickup = data1.docs.where((element) => element.data()["Status"] == "2" && element.data()["User"] == userID).toList();
                          var completed = data1.docs.where((element) => element.data()["Status"] == "3" && element.data()["User"] == userID).toList();

                          return TabBarView(
                            children: [
                              ListView.separated(
                                itemCount: toPay.length,
                                itemBuilder: (context, index){
                                  return FutureBuilder(
                                    future: getResource(toPay[index].data()["Items"][0].toString().split(",")[0]),
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
                                                IconButton(
                                                  onPressed: (){
                                                    showDialog(context: context, builder: (builder){
                                                      return CancelDialog(orderID: toPay[index].id,);
                                                    });
                                                  },
                                                  icon: const Icon(Icons.cancel_outlined),
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
                                itemCount: preparing.length,
                                itemBuilder: (context, index){
                                  return FutureBuilder(
                                    future: getResource(preparing[index].data()["Items"][0].toString().split(",")[0]),
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
                                    future: getResource(forPickup[index].data()["Items"][0].toString().split(",")[0]),
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
                                                const SizedBox(width: 10),
                                                IconButton(
                                                  onPressed:(){
                                                    FirestoreService().updateOrderStatus(forPickup[index].id, "3");
                                                  },
                                                  icon: const Icon(
                                                    CupertinoIcons.cube_box,
                                                    color: Colors.black,
                                                    size: 30,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      return SizedBox();
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) => const SizedBox(height: 10),
                              ),
                              ListView.separated(
                                itemCount: completed.length,
                                itemBuilder: (context, index){
                                  return FutureBuilder(
                                    future: getResource(completed[index].data()["Items"][0].toString().split(",")[0]),
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
                                      return SizedBox();
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
                 /*     TabBarView(
                          children: [
                            ListView.builder(
                              itemCount: 2,
                              itemBuilder: (context, index){
                                return ListTile(
                                  leading: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset("assets/images/QCUlogo.jpg"),
                                  ),
                                  title: Text(
                                    "Order #${index + 1}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Order Price",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  trailing: Text(
                                    "View",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors().primary,
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListView.builder(
                              itemCount: 4,
                              itemBuilder: (context, index){
                                return ListTile(
                                  leading: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset("assets/images/QCUlogo.jpg"),
                                  ),
                                  title: Text(
                                    "Order #${index + 1}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Order Price",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  trailing: Text(
                                    "View",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors().primary,
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index){
                                return ListTile(
                                  leading: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset("assets/images/QCUlogo.jpg"),
                                  ),
                                  title: Text(
                                    "Order #${index + 1}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Order Price",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  trailing: Text(
                                    "View",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors().primary,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ]
                      ),*/
                    ),
                    if(_bannerAd != null)
                      SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                  ]
              )
          ),
        );
      },
      error: (error, stack){
        return Center(
          child: Text(
            error.toString(),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
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
