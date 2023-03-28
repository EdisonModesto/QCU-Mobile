import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qcu/common/itemDetails/ItemView.dart';
import 'package:qcu/features/Sellers/store/addItemDialog.dart';
import 'package:qcu/services/AuthService.dart';
import 'package:qcu/services/FirestoreService.dart';

import '../../../cosntants/colors.dart';
import '../../ViewModels/FeedViewModel.dart';
import 'editItemDialog.dart';

class SStoreView extends ConsumerStatefulWidget {
  const SStoreView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _sStoreViewState();
}

class _sStoreViewState extends ConsumerState<SStoreView> {

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var feed = ref.watch(feedProvider);

    return feed.when(
      data: (data) {
        var filteredData = data.docs
            .where((element) => element["Seller"] == AuthService().getID())
            .toList();

        var searchResult = filteredData
            .where((element) =>
                element["Name"].toString().toLowerCase().contains(searchController.text.toLowerCase()))
            .toList();
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/images/QCUlogo.jpg"),
                        backgroundColor: Colors.transparent,

                      ),
                      const SizedBox(
                        width: 20,
                      ),
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
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (builder) {
                            return AddItemDialog();
                          });
                    },
                    icon: Icon(
                      CupertinoIcons.add,
                      color: AppColors().primary,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: searchController,
                  onChanged: (val){
                    setState(() {});
                  },
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
                        fontSize: 14, color: AppColors().black),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: AppColors().primary,
                          width: 1,
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: AppColors().primary,
                          width: 2,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors().primary,
                          width: 2,
                        )),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: searchController.text == "" ?
                GridView.count(
                  padding: const EdgeInsets.all(0),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.8,
                  children: List.generate(filteredData.length, (index) {
                    return Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            showMaterialModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              builder: (context) => ItemView(
                                url: filteredData[index].data()["Image"],
                                name: filteredData[index].data()["Name"],
                                price: filteredData[index].data()["Price"],
                                description:
                                    filteredData[index].data()["Description"],
                                stock: filteredData[index].data()["Stock"],
                                seller: filteredData[index].data()["Seller"],
                                category:
                                    filteredData[index].data()["Category"],
                                id: filteredData[index].id,
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                border: Border.all(
                                  color: AppColors().primary,
                                  width: 2,
                                )),
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  filteredData[index]
                                                      .data()["Image"]),
                                              fit: BoxFit.cover)),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        filteredData[index].data()["Name"],
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "PHP ${filteredData[index].data()["Price"]}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                CupertinoIcons.pencil,
                                color: AppColors().primary,
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return EditItemDialog(
                                        data: filteredData[index],
                                      );
                                    });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                CupertinoIcons.delete,
                                color: AppColors().primary,
                              ),
                              onPressed: () {
                                FirestoreService()
                                    .deleteItem(filteredData[index].id);
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                )
                :
                GridView.count(
                  padding: const EdgeInsets.all(0),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.8,
                  children: List.generate(searchResult.length, (index) {
                    return Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            showMaterialModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              builder: (context) => ItemView(
                                url: searchResult[index].data()["Image"],
                                name: searchResult[index].data()["Name"],
                                price: searchResult[index].data()["Price"],
                                description:
                                searchResult[index].data()["Description"],
                                stock: searchResult[index].data()["Stock"],
                                seller: searchResult[index].data()["Seller"],
                                category:
                                searchResult[index].data()["Category"],
                                id: searchResult[index].id,
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                border: Border.all(
                                  color: AppColors().primary,
                                  width: 2,
                                )),
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  searchResult[index]
                                                      .data()["Image"]),
                                              fit: BoxFit.cover)),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        searchResult[index].data()["Name"],
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "PHP ${searchResult[index].data()["Price"]}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                CupertinoIcons.pencil,
                                color: AppColors().primary,
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return EditItemDialog(
                                        data: searchResult[index],
                                      );
                                    });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                CupertinoIcons.delete,
                                color: AppColors().primary,
                              ),
                              onPressed: () {
                                FirestoreService()
                                    .deleteItem(searchResult[index].id);
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              )
            ]),
          ),
        );
      },
      error: (error, stack) {
        return Center(
          child: Text(
            error.toString(),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        );
      },
      loading: () {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
