import 'package:flutter/material.dart';
import 'package:notepad/screens/profile/model/profile_model.dart';
import 'package:notepad/screens/profile/profile_controller.dart';
import 'package:notepad/screens/profile/profile_information.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var profileData = ProfileController().userProfileData;

  @override
  void initState() {
    print(profileData);
    getUserData();
    super.initState();
  }

  getUserData() async {
    profileData = await ProfileController().fetchProfile();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (profileData.age != 0) ...[
              Text(
                profileData.name,
                style: TextStyle(fontSize: 18),
              ),
              Text(profileData.age.toString(), style: TextStyle(fontSize: 18)),
              Text(profileData.gender.name, style: TextStyle(fontSize: 18)),
              Text("List of favourite foods",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.separated(
                  itemCount: profileData.favouriteFoods!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Food name: ${profileData.favouriteFoods![index].foodName}",
                            style: TextStyle(fontSize: 18)),
                        Text(
                            "Rating: ${profileData.favouriteFoods![index].rating}",
                            style: TextStyle(fontSize: 18)),
                        Text(
                            "No of Likes: ${profileData.favouriteFoods![index].numberOfLikes}",
                            style: TextStyle(fontSize: 18)),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  var newFavFood = Food(
                      foodName: 'Corn',
                      rating: 3.0,
                      recipe: ['agbado', 'tinubu'],
                      numberOfLikes: 100);
                  profileData.favouriteFoods!.add(newFavFood);
                  setState(() {});
                },
                child: Text("Add new fav food",
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              ),

              GestureDetector(
                onTap: () {
                  if(profileData.favouriteFoods!.isNotEmpty) {
                    profileData.favouriteFoods!.removeLast();
                    setState(() {});
                  }else{
                    print('No more favourite foods');
                  }
                },
                child: Text("Remove from favourite",
                    style:
                    TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfileInformation(title: 'Virtual Card Info')));
                },
                child: Text("Go to information screen",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ]
          ],
        ),
      )),
    );
  }
}
