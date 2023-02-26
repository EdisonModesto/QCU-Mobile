import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qcu/services/AuthService.dart';

import '../../../common/authentication/AuthDialog.dart';
import '../../../common/cart/CartView.dart';
import '../../../cosntants/colors.dart';
import '../../ViewModels/AuthViewModel.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {

    var authState = ref.watch(authStateProvider);

    return authState.when(
      data: (data){
        return DefaultTabController(
          length: 3,
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
                    data?.uid != null ?
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors().primary,
                          radius: 35,
                          backgroundImage: const AssetImage("assets/images/QCUlogo.jpg"),
                        ),
                        const SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Name",
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
                            AuthService().signOut();
                          },
                          icon: Icon(
                            Icons.logout,
                            color: AppColors().primary,
                          ),
                        ),
                      ],
                    ) :

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
                                  showDialog(context: context, builder: (builder){
                                    return const AuthDialog();
                                  });
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
                    )
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
