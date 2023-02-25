import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../cosntants/colors.dart';


class MallView extends ConsumerStatefulWidget {
  const MallView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MallViewState();
}

class _MallViewState extends ConsumerState<MallView> {
  @override
  Widget build(BuildContext context) {
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
                      "QCU Mall",
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
            const SizedBox(height: 20,),
            SizedBox(
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors().primary,
                  ),
                  contentPadding: const EdgeInsets.only(left: 20, right: 20),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Search",
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
            ),
            const SizedBox(height: 20,),
            Expanded(
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
              ),
            )
          ]
      ),
    );
  }
}
