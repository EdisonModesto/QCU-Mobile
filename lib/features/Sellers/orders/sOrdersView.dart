import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../cosntants/colors.dart';

class SOrdersView extends ConsumerStatefulWidget {
  const SOrdersView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SOrdersViewState();
}

class _SOrdersViewState extends ConsumerState<SOrdersView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
          child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
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
                  ],
                ),
                Expanded(
                  child: TabBarView(
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
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
