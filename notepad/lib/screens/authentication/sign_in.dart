import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notepad/screens/authentication/otpPage.dart';
import 'package:notepad/screens/home/home_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailFieldController = TextEditingController();

  String error = "";
  bool isLoading = false;
  bool isSigningin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Divider(
                        color: Colors.green,
                        thickness: 5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                  controller: emailFieldController,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                              BorderSide(color: Color(0xFFd8d8d8), width: 1)),
                      hintText: 'Email Address or phone number',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ))),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                          BorderSide(color: Color(0xFFd8d8d8), width: 1)),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ))),
              const SizedBox(
                height: 18,
              ),
              GestureDetector(
                onTap: () {
                  if(emailFieldController.text.isNotEmpty){
                    setState(() {
                      isLoading = true;
                    });
                    signUP();
                  }else{
                    print('Credentials required');
                  }

                },
                child: Center(
                  child: isLoading ? const CupertinoActivityIndicator(color: Colors.white, radius: 30,) :
                  Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4)),
                      height: 53,
                      width: 300,
                      child: Center(
                        child: Text(
                          'Create Account',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )) ,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              GestureDetector(
                onTap: () {
                  if(emailFieldController.text.isNotEmpty){
                    setState(() {
                      isSigningin = true;
                    });
                    signIn();
                  }else{
                    print('Credentials required');
                  }

                },
                child: Center(
                    child: isSigningin ? const CupertinoActivityIndicator(color: Colors.white, radius: 30,) :
                     Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4)),
                      height: 53,
                      width: 300,
                      child: Center(
                        child: Text(
                          'Sign in',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  error,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: () async {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: emailFieldController.text.trim()).then((value) => {
                  setState(() {
                  error = "Password reset link has been sent to your email ${emailFieldController.text.trim()}";
                  })
                  });
                },
                child: const Center(
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.green, fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isEmailValid(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    return emailRegex.hasMatch(email);
  }


  signUP() async {
    setState(() {
      error = "";
    });
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailFieldController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          error = "The password provided is too weak.";
          isLoading = false;
        });
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          isLoading = false;
          error = "The account already exists for that email.";
        });
        print('The account already exists for that email.');
      }
    } catch (exception) {
      setState(() {
        isLoading = false;
        error = "$exception";
      });
      print(exception);
    }
  }

  signIn() async {
    setState(() {
      error = "";
    });
    try {
      if(isEmailValid(emailFieldController.text.trim())) {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailFieldController.text.trim(),
          password: passwordController.text.trim(),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomeScreen()));
      }else{
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: emailFieldController.text.toString(),
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              isSigningin = false;
              error = "$e";
            });
          },
          codeSent: (String verificationId, int? resendToken) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => OtpPage(verificationID: verificationId)));
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          error = "No user found for that email.";
        });
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        setState(() {
          error = "Wrong password provided for that user.";
        });
        print('Wrong password provided for that user.');
      }
    } catch (exception) {
      print(exception);
    }
  }

  // try{
  // //Perform operation
  // }catch(exception){
  // //Catch errors during operation
  // }
}
