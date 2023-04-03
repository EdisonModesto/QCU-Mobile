import "package:animated_text_kit/animated_text_kit.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";

import "../../cosntants/colors.dart";
import "../../cosntants/strings.dart";
import "../../features/ViewModels/FeedViewModel.dart";
import "../../services/AdMob/ad_helper.dart";
import "../cart/CartView.dart";
import "ItemView.dart";

class SellerVisitView extends ConsumerStatefulWidget {
  const SellerVisitView({
    required this.sellerID,
    Key? key,
  }) : super(key: key);
  final sellerID;

  @override
  ConsumerState createState() => _SellerVisitViewState();
}

class _SellerVisitViewState extends ConsumerState<SellerVisitView> {
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

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(left: 35, right: 35, top: 20),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Users").doc(widget.sellerID).snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Column(
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
                                snapshot.data!["Name"],
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      /*    const SizedBox(height: 20,),
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
                          label: AnimatedTextKit(
                              animatedTexts: List.generate(Strings().suggestions.length, (index){
                                return RotateAnimatedText(
                                  Strings().suggestions[index],
                                  textAlign: TextAlign.start,
                                  alignment: Alignment.centerLeft,
                                  textStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Color(0xff414141),
                                  ),
                                  // speed: const Duration(milliseconds: 500),
                                );
                              })
                          ),
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
                    ),*/
                      const SizedBox(height: 20,),
                      Expanded(
                        child: feed.when(
                          data: (data){
                            var sellerFilter = data.docs.where((element) => element.data()["Seller"].toString() == widget.sellerID ).toList();
                            var searchResult = sellerFilter.where((element) => element.data()["Name"].toString().toLowerCase().contains(searchController.text.toLowerCase())).toList();
                            return searchController.text == "" ?
                            GridView.count(
                              padding: const EdgeInsets.all(0),
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.8,
                              children: List.generate(sellerFilter.length, (index){
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
                                        url: sellerFilter[index].data()["Image"],
                                        name: sellerFilter[index].data()["Name"],
                                        price: sellerFilter[index].data()["Price"],
                                        description: sellerFilter[index].data()["Description"],
                                        stock: sellerFilter[index].data()["Stock"],
                                        seller: sellerFilter[index].data()["Seller"],
                                        category: sellerFilter[index].data()["Category"],
                                        id: sellerFilter[index].id,
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
                                                          sellerFilter[index]
                                                              .data()["Image"]),
                                                      fit: BoxFit.cover)),
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                sellerFilter[index].data()["Name"],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "PHP ${sellerFilter[index].data()["Price"]}",
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
                );
              }
              else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          ),
        ),
      ),
    );
  }
}
