import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";
import "package:qcu/features/ViewModels/ChatViewModel.dart";
import "package:qcu/services/AuthService.dart";

class ConvoListView extends ConsumerStatefulWidget {
  const ConvoListView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ConvoListViewState();
}

class _ConvoListViewState extends ConsumerState<ConvoListView> {
  @override
  Widget build(BuildContext context) {

    var chats = ref.watch(chatProvider);

    return Scaffold(
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(left: 35, right: 35, top: 40),
          child: Column(
            children:[
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/QCUlogo.jpg"),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 20,),
                  Text(
                    "Chats",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Expanded(
                child: chats.when(
                  data: (data){
                    var filteredData = data.docs.where((element){
                      return element.id.split("-")[0] == AuthService().getID() || element.id.split("-")[1] == AuthService().getID();
                    }).toList();

                    var ref = FirebaseFirestore.instance.collection("Users");

                    return ListView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                          stream: ref.doc(filteredData[index].id.split("-")[0] == AuthService().getID() ? filteredData[index].id.split("-")[1] : filteredData[index].id.split("-")[0] ).snapshots(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              return ListTile(
                                onTap: (){
                                  context.pushNamed("chat", params: {
                                    "buyer": filteredData[index].id.split("-")[0],
                                    "seller": filteredData[index].id.split("-")[1],
                                  });
                                },
                                leading: const CircleAvatar(
                                  backgroundImage: AssetImage("assets/images/QCUlogo.jpg"),
                                  backgroundColor: Colors.transparent,

                                ),
                                title: Text(
                                  snapshot.data!["Name"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
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
                            }
                            return const SizedBox();
                          }
                        );
                      },
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
                ),
              ),
            ]
          ),
        ),
      )
    );
  }
}
