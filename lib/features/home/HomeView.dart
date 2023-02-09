import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcu/cosntants/colors.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  var cat = [
    Icons.emoji_food_beverage_outlined,
    Icons.shopping_cart_outlined,
    Icons.house_outlined,
    Icons.payment_outlined,
  ];

  var cat2 = [
    Icons.book_outlined,
    Icons.chair_alt,
    Icons.lightbulb_outline,
    Icons.warehouse_outlined,
    Icons.build_outlined,
    Icons.more_horiz_outlined,
  ];

  var str = [
    "Food",
    "Shopping",
    "Rent",
    "Payment",
  ];

  var str2 = [
    "School",
    "Furniture",
    "Lights",
    "Tents",
    "Tools",
    "More"
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
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
                      onPressed: () {},
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
          ),
          const SizedBox(height: 40,),
          Container(
            height: 125,
            width: MediaQuery.of(context).size.width,
            color: AppColors().primary,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    "Voucher Carousel",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                OverflowBox(
                  child: Transform.translate(
                    offset: const Offset(0, -60),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20, right: 20),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Search",
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors().black
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppColors().primary,
                                width: 2,
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppColors().primary,
                                width: 2,
                              )
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25,),
                  Container(
                    height: 70,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors().primary,
                          width: 2,
                        )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(cat.length, (index){
                        return Column(
                          children: [
                            Icon(
                                cat[index]
                            ),
                            Text(
                              str[index],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors().black,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Container(
                      height: 140,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors().primary,
                            width: 2,
                          )
                      ),
                      child: GridView.count(
                        padding: const EdgeInsets.all(0),
                        crossAxisCount: 4,
                        children: List.generate(cat2.length, (index){
                          return Column(
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
                          );
                        }),
                      )
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
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
                              onPressed: () {},
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
                          height: 200,
                          child: GridView.count(
                            padding: const EdgeInsets.all(0),
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: List.generate(6, (index){
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors().primary,
                                      width: 2,
                                    )
                                ),
                              );
                            }),
                          )
                          ,
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
    );
  }
}
