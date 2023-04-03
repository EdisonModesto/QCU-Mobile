import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qcu/features/ViewModels/UserViewModel.dart';

import '../../../common/authentication/AuthView.dart';
import '../../../common/settings/settingsSheet.dart';
import '../../../cosntants/colors.dart';
import '../../../services/AuthService.dart';
import '../../../services/FirestoreService.dart';
import '../../Users/profile/uEditProfileDialog.dart';
import '../../ViewModels/AuthViewModel.dart';

class SProfileView extends ConsumerStatefulWidget {
  const SProfileView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SProfileViewState();
}

class _SProfileViewState extends ConsumerState<SProfileView> {
  @override
  Widget build(BuildContext context) {

    var userDetails = ref.watch(userProvider);

    return userDetails.when(
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
                            backgroundColor: Colors.transparent,

                          ),
                          const SizedBox(width: 20,),
                          Text(
                            "Seller Profile",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          FirestoreService().convertToBuyer(AuthService().getID());
                        },
                        icon: Icon(
                          CupertinoIcons.money_dollar_circle,
                          color: AppColors().primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(context: context, builder: (builder){
                            return UEditProfileDialog(data: data,);
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                          color: AppColors().primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors().primary,
                        radius: 35,
                        backgroundImage: NetworkImage(data.data()!["Image"]),
                      ),
                      const SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.data()!["Name"],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            child: RatingBar(
                              itemSize: 20,
                              initialRating: 3,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              ignoreGestures: true,
                              ratingWidget: RatingWidget(
                                full: const Icon(Icons.star, color: Colors.amber),
                                half: const Icon(Icons.star_half, color: Colors.amber),
                                empty: const Icon(Icons.star_border, color: Colors.amber),
                              ),
                              itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
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
                            builder: (builder){
                              return const SettingsSheet();
                            },);
                          //AuthService().signOut();
                        },
                        icon: Icon(
                          Icons.settings,
                          color: AppColors().primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Text(
                    "Reviews",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index){
                        return Card(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 15,
                                      backgroundImage: AssetImage("assets/images/QCUlogo.jpg"),

                                    ),
                                    Text(
                                      "Review Name",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nunc ut aliquam tincidunt, nunc nisl aliquam nisl, eget aliquam nisl nunc eget nisl.",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ]
            )
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
      }
    );
  }
}
