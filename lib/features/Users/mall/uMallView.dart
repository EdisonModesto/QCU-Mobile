import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../common/cart/CartView.dart';
import '../../../common/itemDetails/ItemView.dart';
import '../../../cosntants/colors.dart';
import '../../../services/AdMob/ad_helper.dart';
import '../../ViewModels/FeedViewModel.dart';


class MallView extends ConsumerStatefulWidget {
  const MallView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MallViewState();
}

class _MallViewState extends ConsumerState<MallView> {

  TextEditingController searchController = TextEditingController();

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
    searchController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var feed = ref.watch(feedProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.only(left: 35, right: 35, top: 40),
      child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/QCUlogo.jpg"),
                    ),
                    const SizedBox(width: 20,),
                    Text(
                      "QCU Mall",
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
                      onPressed: () {},
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
            SizedBox(
              height: 50,
              child: TextField(
                controller: searchController,
                onChanged: (val){
                  setState(() {});
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors().primary,
                  ),
                  contentPadding: const EdgeInsets.only(left: 20, right: 20),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Search",
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors().black
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppColors().primary,
                        width: 1,
                      )
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppColors().primary,
                        width: 2,
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors().primary,
                        width: 2,
                      )
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: feed.when(
                data: (data){
                  var searchResult = data.docs.where((element) => element.data()["Name"].toString().toLowerCase().contains(searchController.text.toLowerCase())).toList();
                  return searchController.text == "" ?
                  GridView.count(
                    padding: const EdgeInsets.all(0),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                    children: List.generate(data.docs.length, (index){
                      return InkWell(
                        onTap: () {
                          showMaterialModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            builder: (context) => ItemView(
                              url: data.docs[index].data()["Image"],
                              name: data.docs[index].data()["Name"],
                              price: data.docs[index].data()["Price"],
                              description: data.docs[index].data()["Description"],
                              stock: data.docs[index].data()["Stock"],
                              seller: data.docs[index].data()["Seller"],
                              category: data.docs[index].data()["Category"],
                              id: data.docs[index].id,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors().primary,
                                width: 2,
                              )),
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                data.docs[index]
                                                    .data()["Image"]),
                                            fit: BoxFit.cover)),
                                  )),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data.docs[index].data()["Name"],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "PHP ${data.docs[index].data()["Price"]}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  )
                      :
                  GridView.count(
                    padding: const EdgeInsets.all(0),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                    children: List.generate(searchResult.length, (index){
                      return InkWell(
                        onTap: () {
                          showMaterialModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            builder: (context) => ItemView(
                              url: searchResult[index].data()["Image"],
                              name: searchResult[index].data()["Name"],
                              price:searchResult[index].data()["Price"],
                              description: searchResult[index].data()["Description"],
                              stock:searchResult[index].data()["Stock"],
                              seller: searchResult[index].data()["Seller"],
                              category: searchResult[index].data()["Category"],
                              id: searchResult[index].id,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors().primary,
                                width: 2,
                              )),
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                searchResult[index]
                                                    .data()["Image"]),
                                            fit: BoxFit.cover)),
                                  )),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      searchResult[index].data()["Name"],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "PHP ${searchResult[index].data()["Price"]}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ) ;
                },
                error: (error, stack){
                  return Center(
                    child: Text(
                      error.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
              ),
            ),
            if(_bannerAd != null)
              SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
          ]
      ),
    );
  }
}
