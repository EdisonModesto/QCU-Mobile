import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../cosntants/colors.dart';

class SStoreView extends ConsumerStatefulWidget {
  const SStoreView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _sStoreViewState();
}

class _sStoreViewState extends ConsumerState<SStoreView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
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
                        "Your Store",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: (){},
                    icon: Icon(
                      CupertinoIcons.add,
                      color: AppColors().primary,
                    ),
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
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.8,
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
      ),
    );
  }
}
