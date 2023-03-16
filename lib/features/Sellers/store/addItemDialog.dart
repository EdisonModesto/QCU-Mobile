import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcu/cosntants/colors.dart';
import 'package:qcu/services/AuthService.dart';
import 'package:qcu/services/CloudService.dart';
import 'package:qcu/services/FilePickerService.dart';
import 'package:qcu/services/FirestoreService.dart';

class AddItemDialog extends ConsumerStatefulWidget {
  const AddItemDialog({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends ConsumerState<AddItemDialog> {

  var key = GlobalKey<FormState>();

  var image = "";
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController stock = TextEditingController();


  var categories =  [
    const DropdownMenuItem(
      value: "Food",
      child: Text("Food"),
    ),
    const DropdownMenuItem(
      value: "School",
      child: Text("School"),
    ),
    const DropdownMenuItem(
      value: "Print",
      child: Text("Print"),
    ),
    const DropdownMenuItem(
      value: "Bookbind",
      child: Text("Bookbind"),
    ),
    const DropdownMenuItem(
      value: "Merch",
      child: Text("Merch"),
    ),
    const DropdownMenuItem(
      value: "More",
      child: Text("More"),
    ),
  ];


  var catValue = "Food";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: key,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: SizedBox(
            height: 525,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add Item",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors().primary,
                            ),
                          ),
                          const SizedBox(height: 15,),
                          Container(
                            height: 125,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: image == "" ? NetworkImage("https://via.placeholder.com/500") : NetworkImage(image),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                image = await FilePickerService().pickImage();
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.image_outlined,
                                size: 25,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: name,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                errorStyle: GoogleFonts.poppins(
                                  height: 0,
                                ),
                                labelText: "Item Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: 50,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: price,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                errorStyle: GoogleFonts.poppins(
                                  height: 0,
                                ),
                                labelText: "Item Price",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: stock,
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return "";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      errorStyle: GoogleFonts.poppins(
                                        height: 0,
                                      ),
                                      labelText: "Stock",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: DropdownButton(
                                    value: catValue,
                                    items: categories,
                                    onChanged: (value){
                                      setState(() {
                                        catValue = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: 125,
                            child: TextFormField(
                              maxLines: 10,
                              controller: description,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                errorStyle: GoogleFonts.poppins(
                                  height: 0,
                                ),
                                labelText: "Item Description",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 100,),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppColors().black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: (){
                          if(key.currentState!.validate() && image != ""){
                            // add item
                            FirestoreService().addItem(name.text, price.text, description.text, image, AuthService().getID(), catValue, stock.text);
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Add",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppColors().primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}
