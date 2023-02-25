import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../cosntants/colors.dart';

class ADashboardView extends ConsumerStatefulWidget {
  const ADashboardView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ADashboardViewState();
}

class _ADashboardViewState extends ConsumerState<ADashboardView> {
  @override
  Widget build(BuildContext context) {
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
                ],
              ),
              const SizedBox(height: 25,),
              Row(
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
              const SizedBox(height: 25,),
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
                          Text(
                            "100",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors().primary,
                            ),
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
                          Text(
                            "100",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors().primary,
                            ),
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
                          Text(
                            "100",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors().primary,
                            ),
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
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
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
                                  "Product: ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  "Quantity: ",
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "User",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors().primary,
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  "Seller",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors().primary,
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  "Product",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors().primary,
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  "Quantity",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors().primary,
                                  ),
                                ),
                                const SizedBox(height: 5,),]),]),),);},
                  separatorBuilder: (context, index) => const SizedBox(height: 10,)
                ),
              )
            ]
        ),
      ),
    );
  }
}