import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../cosntants/colors.dart';
import '../../Users/notifications/NotifViewmode.dart';
import '../../ViewModels/AuthViewModel.dart';

class SNotifView extends ConsumerStatefulWidget {
  const SNotifView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SNotifViewState();
}

class _SNotifViewState extends ConsumerState<SNotifView> {



  @override
  Widget build(BuildContext context) {
    var notifData = ref.watch(notifProvider);

    var authState = ref.watch(authStateProvider);
    return authState.when(
      data: (data){
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
          child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/QCUlogo.jpg"),
                      backgroundColor: Colors.transparent,

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
                    Spacer(),
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
