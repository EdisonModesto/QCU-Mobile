import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcu/cosntants/colors.dart';
import 'package:qcu/cosntants/routes.dart';

void main() {
  runApp(
    ProviderScope(child:const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'QCU Mobile',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routerConfig: AppRoute().router,
    );
  }
}

class AppRoot extends ConsumerStatefulWidget {
  const AppRoot({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<AppRoot> {

  void endSplash()async{
    await Future.delayed(const Duration(seconds: 3));
    context.go("/login");
  }

  @override
  void initState() {
    endSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage("assets/images/QCUlogo.jpg"),
              ),
              SizedBox(height: 15,),
              Text(
                "QCU Mobile",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors().primary
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
