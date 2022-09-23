// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneywallet/home/welcome/controller/provider/LoginProvider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final values = Provider.of<LoginProvider>(context, listen: false);
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
                      key: values.formKey,
                      child: TextFormField(
                        validator: (value) => values.checkValidate(value),
                        controller: values.nameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    ElevatedButton(
                      onPressed: () async {
                        await values.getName();
                        values.validate(context);
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
}
