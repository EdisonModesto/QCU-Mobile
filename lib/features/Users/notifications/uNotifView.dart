import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:qcu/features/Users/notifications/NotifViewmode.dart";
import "package:qcu/services/AuthService.dart";
import "package:qcu/services/FirestoreService.dart";

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
    var notifData = ref.watch(notifProvider);
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
                        InkWell(
                          onTap: () {
                            FirestoreService().addNotification(
                              AuthService().getID(),
                              "Test notification",
                              DateTime.now(),
                              "This is a test notification",
                            );
                          },
                          child: const CircleAvatar(
                            backgroundImage: AssetImage("assets/images/QCUlogo.jpg"),
                            backgroundColor: Colors.transparent,

                          ),
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
                const SizedBox(height: 10,),
                Expanded(
                  child: notifData.when(
                    data: (notData){

                      return data?.uid != null ?

                       ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: notData.docs.length,
                        itemBuilder: (context, index){
                          return ListTile(
                            leading: const Icon(
                              Icons.notifications_active_outlined,
                            ),
                            title: Text(
                              notData.docs[index]["Name"],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              notData.docs[index]["Message"],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
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
                    }
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
