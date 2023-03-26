import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qcu/cosntants/strings.dart';

import '../../cosntants/colors.dart';
import '../../features/ViewModels/FeedViewModel.dart';
import '../itemDetails/ItemView.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {

  TextEditingController searchCtrl = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var feed = ref.watch(feedProvider);

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(left: 35, right: 35, top: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: searchCtrl,
                    onChanged: (value){
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "Search",
                      contentPadding: const EdgeInsets.only(left: 40, right: 40),
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors().primary,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors().primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                          color: AppColors().primary,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                          color: AppColors().primary,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                          color: AppColors().primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Expanded(
                  child: feed.when(
                    data: (data){
                      var searchResult = data.docs.where((element) => element.data()["Name"].toString().toLowerCase().contains(searchCtrl.text.toLowerCase())).toList();
                      var suggestions = Strings().suggestions.where((element) => element.toLowerCase().contains(searchCtrl.text.toLowerCase())).toList();

                      return searchCtrl.text.length > 2 ?
                      GridView.count(
                        padding: const EdgeInsets.all(0),
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                        children: List.generate(searchResult.length, (index){
                          return InkWell(
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
                                  description:searchResult[index].data()["Description"],
                                  stock: searchResult[index].data()["Stock"],
                                  seller: searchResult[index].data()["Seller"],
                                  category: searchResult[index].data()["Category"],
                                  id: searchResult[index].id,
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
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
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
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
                          );
                        }),
                      )
                          :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Suggestions:",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Expanded(
                            child: ListView.builder(
                              itemCount: suggestions.length,
                              itemBuilder: (context, index){
                                return ListTile(
                                  onTap: (){
                                    searchCtrl.text = suggestions[index];
                                    setState(() {});
                                  },
                                  title: Text(
                                    suggestions[index],
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    error: (error, stack){
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
                    loading: (){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
