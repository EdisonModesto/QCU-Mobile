import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:philippines/city.dart';
import 'package:philippines/philippines.dart';
import 'package:philippines/province.dart';
import 'package:philippines/region.dart';
import 'package:qcu/services/borzo/BorzoService.dart';

import '../../cosntants/colors.dart';
import '../../services/FirestoreService.dart';
import 'PaymentView.dart';

class AddressDialog extends ConsumerStatefulWidget {
  const AddressDialog({
    required this.cart,
    required this.name,
    required this.contact,
    required this.address,
    required this.sellerID,
    Key? key,
  }) : super(key: key);

  final cart;
  final name;
  final contact;
  final address;
  final sellerID;
  @override
  ConsumerState createState() => _AddressDialogState();
}

class _AddressDialogState extends ConsumerState<AddressDialog> {

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController contactCtrl = TextEditingController();
  TextEditingController streetCtrl = TextEditingController();

  var key = GlobalKey<FormState>();
  var reg = "NCR";
  var city = "Caloocan";
  var url = "";
  var shippingFee = "0.0";

  List<City> cities = getCities();
  List<Province> provinces = getProvinces();
  List<Region> regions = getRegions();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          height: 400,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: key,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: 500,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Set Address",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
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
                                width: 2.0,
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
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: contactCtrl,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 14
                          ),
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(height: 0),
                            label: Text("Contact Number"),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
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
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: streetCtrl,
                          style: const TextStyle(
                              fontSize: 14
                          ),
                          onEditingComplete: (){
                            setState(() {});
                          },
                          onFieldSubmitted: (value) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(height: 0),
                            label: Text("House Number & Street Name"),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
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
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Shipping Fee: ",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance.collection("Users").doc(widget.sellerID).snapshots(),
                            builder: (context, snapshot1) {
                              if (snapshot1.hasData) {
                                return FutureBuilder(
                                  future: BorzoService().calculatePrice("${streetCtrl.text}, $reg, $city", snapshot1.data!["Address"].toString().replaceAll("%", ", ")),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      shippingFee = "${snapshot.data}";
                                      return Text(
                                        "₱${snapshot.data}",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      );
                                    }
                                    return const Text(
                                      "₱0",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    );
                                  },
                                );

                              }
                              return Center(
                                child: CircularProgressIndicator()
                              );
                            }
                          )
                        ]
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (key.currentState!.validate()){

                          }
                          showDialog(context: context, builder: (builder){
                          return AlertDialog(
                            title: const Text("Mode of Payment"),
                            content: const Text("What mode of payment would you like to use?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  FirestoreService().createOrder(
                                      widget.cart,
                                    widget.name,
                                    widget.contact,
                                    widget.address,
                                      "delivery",
                                      "cash",
                                    widget.sellerID,
                                    shippingFee
                                  );
                                  Fluttertoast.showToast(msg: "Order placed successfully!");
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("COD"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await showDialog(context: context, builder: (builder){
                                    return PaymentView(
                                      cart: widget.cart,
                                      name: widget.name,
                                      contact: widget.contact,
                                      address: widget.address,
                                      sellerID: widget.sellerID,
                                      shippingFee: shippingFee,
                                    );
                                  });
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("GCash"),
                              ),
                            ],
                          );
                        });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: Size(MediaQuery.of(context).size.width, 50),
                          backgroundColor: AppColors().primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Select Payment Method"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
