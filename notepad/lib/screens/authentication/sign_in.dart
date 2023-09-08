import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                      hintText: 'Email Address',
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
                  signUP();
                },
                child: Center(
                  child: Container(
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
                      )),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              GestureDetector(
                onTap: () {
                  signIn();
                },
                child: Center(
                  child: Container(
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

  signUP() async {
    setState(() {
      error = "";
    });
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailFieldController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          error = "The password provided is too weak.";
        });
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          error = "The account already exists for that email.";
        });
        print('The account already exists for that email.');
      }
    } catch (exception) {
      print(exception);
    }
  }

  signIn() async {
    setState(() {
      error = "";
    });
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailFieldController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomeScreen()));
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
