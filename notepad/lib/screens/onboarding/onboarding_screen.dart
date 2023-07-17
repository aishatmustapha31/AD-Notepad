import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notepad/models/onboarding_model.dart';
import 'package:notepad/screens/home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _initialPage = 0;

  List<OnboardingModel> items = [
    OnboardingModel(
        image: 'assets/icons/onboarding_icon1.svg',
        title: 'Everything Note',
        description: 'Everything note, easy and organised'),
    OnboardingModel(
        image: 'assets/icons/onboarding_icon2.svg',
        title: 'Stay organised',
        description: 'Everything note, easy and organised'),
    OnboardingModel(
        image: 'assets/icons/onboarding_icon3.svg',
        title: 'Read daily',
        description: 'Everything note, easy and organised'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _initialPage = value),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(items[index].image,
                          width: MediaQuery.of(context).size.width * .8,
                          semanticsLabel: 'Onboarding images'),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        items[index].title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        items[index].description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 50),
                    ],
                  );
                },
              ),
            ),
            Visibility(
              visible: _initialPage == 2,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
                  },
                  child: const Text(
                    'Get Started',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
