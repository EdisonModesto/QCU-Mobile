import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";

import "../../../common/cart/CartView.dart";
import "../../../cosntants/colors.dart";
import "../../ViewModels/AuthViewModel.dart";

class NotifView extends ConsumerStatefulWidget {
  const NotifView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _NotifViewState();
}

class _NotifViewState extends ConsumerState<NotifView> {
  @override
  Widget build(BuildContext context) {
    var authState = ref.watch(authStateProvider);
    return authState.when(
      data: (data){
        return Container(
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
                          "Notifications",
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
                const SizedBox(height: 10,),
                Expanded(
                  child: data?.uid != null ?
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 10,
                    itemBuilder: (context, index){
                      return ListTile(
                        leading: const Icon(
                          Icons.notifications_active_outlined,
                        ),
                        title: Text(
                          "Notification $index",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          "This is a notification",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Text(
                          ">",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ) : Center(
                    child: Text(
                      "You are not logged in",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ]
          ),
        );
      },
      error: (error, stack){
        return Center(
          child: Text(
            "Error: $error",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        );
      },
      loading: (){
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
