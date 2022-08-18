// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneywallet/Screens/Homescreen/screen_bottomvavigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ScreenLogin extends StatelessWidget {
  ScreenLogin({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 3.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Never spend\nyour money\nbefore you have\nearned it.....',
                  style: GoogleFonts.aclonica(
                    fontSize: 30.sp,
                  )),
              Center(
                child: Image.asset(
                  'lib/assets/images/splashimageold.jpg',
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 5.w, left: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          'Enter Your Name',
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (value.startsWith(
                            RegExp(r'[0-9]'),
                          )) {
                            return "name can't start with numbers";
                          } else if (value.startsWith(
                            RegExp(r'[ !@#$%^&*(),.?":{}|<>]'),
                          )) {
                            return "name can't start with special cheracters";
                          }
                          return null;
                        },
                        controller: nameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    ElevatedButton(
                      onPressed: () async {
                        await getName();
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const ScreenBottomNavbar(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'LETS GET STARTED',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> getName() async {
    final SharedPreferences name = await SharedPreferences.getInstance();
    name.setString('enterName', nameController.text);
  }
}
