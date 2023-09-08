import 'model/profile_model.dart';

class ProfileController {
  var userProfileData = ProfileModel(name: '', age: 0, gender: UserGender.nonBinary);

  Future<ProfileModel> fetchProfile() async {
    var profileFromDatabase = ProfileModel(
        name: 'Wisdom Michael',
        age: 25,
        gender: UserGender.male,
        favouriteFoods: [
          Food(
              foodName: 'Beans',
              rating: 5.0,
              recipe: ['Raw beans', 'Salt'],
              numberOfLikes: 1),
          Food(
              foodName: 'Amala',
              rating: 3.0,
              recipe: ['Yam', 'Plantain', 'Water'],
              numberOfLikes: 3)
        ],
        dislikedFoods: []);

    await Future.delayed(Duration(seconds: 5));

    userProfileData = profileFromDatabase;
    return userProfileData;
  }
}
