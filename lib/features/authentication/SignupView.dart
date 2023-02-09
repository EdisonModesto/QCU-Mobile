import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../cosntants/colors.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.95,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("assets/images/QCUlogo.jpg"),
                    ),
                    const SizedBox(height: 15,),
                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Register",
                            style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors().primary
                            ),
                          ),
                          const SizedBox(height: 25,),
                          SizedBox(
                            height: 50,
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20),
                                hintText: "Email",
                                hintStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppColors().black
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: AppColors().black
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: AppColors().black
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: AppColors().black
                                    )
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: 50,
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20),
                                hintText: "Password",
                                hintStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppColors().black
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: AppColors().black
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: AppColors().black
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: AppColors().black
                                    )
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: 50,
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20),
                                hintText: "Confirm Password",
                                hintStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppColors().black
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: AppColors().black
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: AppColors().black
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: AppColors().black
                                    )
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15,),
                          ElevatedButton(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(500, 50),
                                backgroundColor: AppColors().primary,
                                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                )
                            ),
                            child: Text(
                              "Register",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    RichText(
                      text: TextSpan(
                          text: "Have an account? ",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors().black
                          ),
                          children: [
                            TextSpan(
                              text: "Login",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors().primary
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.go("/login");
                                },
                            )
                          ]
                      ),
                    )
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
