import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qcu/cosntants/colors.dart';
import 'package:qcu/features/Users/home/FeaturedViewModel.dart';
import 'package:qcu/features/Users/home/uCategoryView.dart';

import '../../../common/cart/CartView.dart';
import '../../../common/itemDetails/ItemView.dart';
import '../../../cosntants/strings.dart';
import '../../../services/AdMob/ad_helper.dart';
import '../../ViewModels/FeedViewModel.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>  {

  TextEditingController searchCtrl = TextEditingController();

  var cat2 = [
    Icons.emoji_food_beverage_outlined,
    Icons.book_outlined,
    Icons.print_outlined,
    Icons.menu_book_outlined,
    CupertinoIcons.tag,
    Icons.more_horiz_outlined,
  ];

  var str2 = [
    "Food",
    "School",
    "Print",
    "Bookbind",
    "Merch",
    "More"
  ];
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {

    var feed = ref.watch(feedProvider);
    var featured = ref.watch(featureProvider);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 35, top: 40),
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
                          "Home",
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
              ),
              const SizedBox(height: 17,),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /*Container(
                        height: 125,
                        width: MediaQuery.of(context).size.width,
                        color: AppColors().primary,
                        child: Center(
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              height: 100.0,
                              autoPlay: true,
                              enlargeCenterPage: true,
                            ),
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: Image.asset(
                                    "assets/images/v${itemIndex+1}.png",
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                          ),
                        ),
                      ),*/
                      Padding(
                        padding: const EdgeInsets.only(left: 35, right: 35,),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: searchCtrl,
                            focusNode: _focusNode,
                            onTap: () {
                              _focusNode.unfocus();
                              context.push("/search");
                            },
                            decoration: InputDecoration(
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
                              contentPadding: const EdgeInsets.only(left: 40, right: 40),
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors().primary,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors().primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: BorderSide(
                                  color: AppColors().primary,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: BorderSide(
                                  color: AppColors().primary,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: BorderSide(
                                  color: AppColors().primary,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Container(
                        height: 70,
                        margin: const EdgeInsets.symmetric(horizontal: 35),
                        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors().primary,
                              width: 2,
                            )
                        ),
                        child: featured.when(
                          data: (data){
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(data.docs.length, (index){
                                return FutureBuilder(
                                  future: FirebaseFirestore.instance.collection("Users").doc(data.docs[index]["ID"]).get(),
                                  builder: (context, result){
                                    if(result.hasData){
                                      return InkWell(
                                        onTap: () {
                                          context.pushNamed("sellerStore", params: {
                                            "sellerID":data.docs[index]["ID"],
                                          });
                                        },
                                        child: SizedBox(
                                          width: 50,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 17,
                                                backgroundImage: NetworkImage(result.data!["Image"]),
                                              ),
                                              Text(
                                                result.data!["Name"],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: AppColors().black,
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
                              }),
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
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Container(
                          height: 150,
                          margin: const EdgeInsets.symmetric(horizontal: 35),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors().primary,
                                width: 2,
                              )
                          ),
                          child: GridView.count(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(0),
                            crossAxisCount: 4,
                            childAspectRatio: 1,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 0,
                            children: List.generate(cat2.length, (index){
                              return InkWell(
                                onTap: () {
                                  showMaterialModalBottomSheet(
                                    context: context,
                                    expand: true,
                                    builder: (context){
                                      return UCategoryView(category: str2[index],);
                                    },
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                        cat2[index]
                                    ),
                                    Text(
                                      str2[index],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: AppColors().black,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          )
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Flash Sale",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    showMaterialModalBottomSheet(
                                      context: context,
                                      expand: true,
                                      builder: (context){
                                        return const UCategoryView(category: "Flash Sale",);
                                      },
                                    );
                                  },
                                  child: Text(
                                    "See All >>",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: AppColors().primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: feed.when(
                                data: (data){
                                  return GridView.count(
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
                                  );
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
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]
          ),
        ],
      ),
    );
  }
}
