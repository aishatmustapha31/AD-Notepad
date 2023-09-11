import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notepad/screens/authentication/widgets.dart';

import '../home/home_screen.dart';

class OtpPage extends StatefulWidget {
  final String verificationID;

  const OtpPage({super.key, required this.verificationID});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController otpController1 = TextEditingController();
  TextEditingController otpController2 = TextEditingController();
  TextEditingController otpController3 = TextEditingController();
  TextEditingController otpController4 = TextEditingController();
  TextEditingController otpController5 = TextEditingController();
  TextEditingController otpController6 = TextEditingController();

  FocusNode otpFocusNode1 = FocusNode();
  FocusNode otpFocusNode2 = FocusNode();
  FocusNode otpFocusNode3 = FocusNode();
  FocusNode otpFocusNode4 = FocusNode();
  FocusNode otpFocusNode5 = FocusNode();
  FocusNode otpFocusNode6 = FocusNode();

  final _formKey = GlobalKey<FormState>();

  var _start = 10;
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (clockTimer) {
      if (_start == 0) {
        setState(() {
          clockTimer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  verifyPhone() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String smsCode = '${otpController1.text}${otpController2.text}${otpController3.text}${otpController4.text}${otpController5.text}${otpController6.text}';
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationID, smsCode: smsCode);
    await auth.signInWithCredential(credential).then((value) => Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
          padding:
              const EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 30),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                          ),
                        )),

                    const Text(
                      'OTP Verification',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                          fontFamily: 'Roboto',
                          color: Colors.black),
                    ),
                  ],
                ),


                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Enter the one time password sent to your phone number',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      otpBox(otpController1, otpFocusNode1, otpFocusNode2, null, Colors.blueGrey, Colors.red, Colors.blue, 10),
                      otpBox(otpController2, otpFocusNode2, otpFocusNode3, otpFocusNode1, Colors.blueGrey, Colors.red, Colors.blue, 10),
                      otpBox(otpController3, otpFocusNode3, otpFocusNode4, otpFocusNode2, Colors.blueGrey, Colors.red, Colors.blue, 10),
                      otpBox(otpController4, otpFocusNode4, otpFocusNode5, otpFocusNode3, Colors.blueGrey, Colors.red, Colors.blue, 10),
                      otpBox(otpController5, otpFocusNode5, otpFocusNode6, otpFocusNode4, Colors.blueGrey, Colors.red, Colors.blue, 10),
                      otpBox(otpController6, otpFocusNode6, null, otpFocusNode5, Colors.blueGrey, Colors.red, Colors.blue, 10),
                    ],
                  ),
                ),

                Row(
                  children: [
                     Text(
                        'Didnt get code? Resend in $_start seconds',
                   style: TextStyle(
                     fontFamily: 'roboto',
                     fontWeight: FontWeight.w200,
                     fontSize: 15
                   ),

                    )


                  ],
                ),

                SizedBox(height: 10),
                // Visibility(
                //     visible: !_formKey.currentState!.validate(),
                //     child: Text('Incomplete OTP provided', style: TextStyle(color: Colors.red),)),
                largeHeight(),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      _formKey.currentState!.save();
                    });
                    if (_formKey.currentState!.validate()) {
                      verifyPhone();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing OTP')),
                      );
                    }
                  },


                  child: Container(
                    // margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5)),
                      height: 50,
                      child: Center(
                        child: Text(
                          'Verify ',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Roboto', fontSize: 25),
                        ),
                      )),
                ),
           SizedBox(height: 30,),
            const Align(
              alignment: Alignment.center,
                 child: Text(
                   'Receive code via email',
                   style: TextStyle(
                       color: Colors.blue,
                       fontFamily: 'roboto',
                       fontWeight: FontWeight.w200,
                       fontSize: 15
                   ),


                 ),
            )

              ]),
    )));
  }
}
