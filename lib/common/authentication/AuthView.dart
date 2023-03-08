import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../cosntants/colors.dart';
import '../../services/AuthService.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AuthDialogState();
}

class _AuthDialogState extends ConsumerState<AuthView> {
  var key = GlobalKey<FormState>();
  var key2 = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 75,),
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/QCUlogo.jpg"),
                      radius: 50,
                    ),
                    const SizedBox(height: 50,),
                    TabBar(
                      isScrollable: true,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppColors().primary,
                      ),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 30),
                      splashBorderRadius: BorderRadius.circular(50),
                      tabs: [
                        Tab(
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Signup",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(
                        height: 300,
                        child: TabBarView(

                          children: [
                            Form(
                              key: key,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        labelText: "Email",
                                        labelStyle: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),

                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15,),
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        labelText: "Password",
                                        labelStyle: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15,),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (key.currentState!.validate()){
                                        AuthService().signIn(emailController.text, passwordController.text);
                                        context.go('/nav');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                                      elevation: 0,
                                      backgroundColor: AppColors().primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    ),
                                    child: const Text("Login"),
                                  ),
                                  const SizedBox(height: 15,),
                                  TextButton(
                                    onPressed: () {
                                      if(emailController.text.isNotEmpty){
                                        AuthService().resetPassword(emailController.text);
                                      } else {
                                        Fluttertoast.showToast(msg: "Email field is empty, cannot reset password");
                                      }
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )

                                ],
                              ),
                            ),
                            Form(
                              key: key2,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        labelText: "Email",
                                        labelStyle: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),

                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15,),
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        labelText: "Password",
                                        labelStyle: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 25,),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (key2.currentState!.validate()){
                                        AuthService().signUp(emailController.text, passwordController.text);
                                        context.go('/nav');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                                      elevation: 0,
                                      backgroundColor: AppColors().primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    ),
                                    child: const Text("Signup"),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}