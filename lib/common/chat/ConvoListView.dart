import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";

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
                child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: (){
                        context.push("/chat");
                      },
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/QCUlogo.jpg"),
                      ),
                      title: Text(
                        "Chat $index",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        "Subtitle $index",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Text(
                        "Time $index",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                )
              ),
            ]
          ),
        ),
      )
    );
  }
}
