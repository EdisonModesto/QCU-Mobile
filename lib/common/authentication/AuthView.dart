import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:philippines/city.dart';
import 'package:philippines/philippines.dart';
import 'package:philippines/province.dart';
import 'package:philippines/region.dart';
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

  var isObscured = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController contactCtrl = TextEditingController();
  TextEditingController streetCtrl = TextEditingController();

  var reg = "NCR";
  var city = "Caloocan";
  var url = "";

  List<City> cities = getCities();
  List<Province> provinces = getProvinces();
  List<Region> regions = getRegions();

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
                      backgroundColor: Colors.transparent,
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
                                      obscureText: isObscured,
                                      decoration: InputDecoration(
                                        labelText: "Password",
                                        labelStyle: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        suffix: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isObscured = !isObscured;
                                            });
                                          },
                                          icon: Icon(
                                            !isObscured ? Icons.visibility : Icons.visibility_off,
                                            color: Colors.grey,
                                          ),
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
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      child: TextFormField(
                                        controller: nameCtrl,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                        decoration: const InputDecoration(
                                          errorStyle: TextStyle(height: 0),
                                          label: Text("Name"),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),

                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                              width: 6.0,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 15,),
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
                                        obscureText: isObscured,
                                        decoration: InputDecoration(
                                          labelText: "Password",
                                          labelStyle: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          suffix: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isObscured = !isObscured;
                                              });
                                            },
                                            icon: Icon(
                                              !isObscured ? Icons.visibility : Icons.visibility_off,
                                              color: Colors.grey,
                                            ),
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
                                        controller: streetCtrl,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                        decoration: const InputDecoration(
                                          errorStyle: TextStyle(height: 0),
                                          label: Text("House Number & Street Name"),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),

                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                              width: 6.0,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Region: ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Spacer(),
                                        DropdownButton(
                                          value: reg,
                                          items: List.generate(regions.length, (index){
                                            return DropdownMenuItem(
                                              value: regions[index].name,
                                              child: Text(
                                                  regions[index].name
                                              ),
                                            );
                                          }),
                                          onChanged: (value) {
                                            setState(() {
                                              reg = value.toString();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "City: ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Spacer(),
                                        DropdownButton(
                                          value: city,
                                          items: List.generate(regions.length, (index){
                                            return DropdownMenuItem(
                                              value: cities[index].name,
                                              child: Text(
                                                  cities[index].name
                                              ),
                                            );
                                          }),
                                          onChanged: (value) {
                                            setState(() {
                                              city = value.toString();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 25,),

                                    ElevatedButton(
                                      onPressed: () async {
                                        if (key2.currentState!.validate()){
                                          AuthService().signUp(emailController.text, passwordController.text, nameCtrl.text, "${streetCtrl.text}%$reg%$city");
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