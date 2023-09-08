enum UserGender{
  male,
  female,
  nonBinary
}

class ProfileModel {
  String name;
  int age;
  UserGender gender;
  List<Food>? favouriteFoods = [];
  List<Food>? dislikedFoods = [];

  ProfileModel({required this.name, required this.age, required this.gender,
  this.favouriteFoods, this.dislikedFoods});
}

class Food {
  String foodName;
  double rating;
  List<String> recipe;
  int numberOfLikes;

  Food(
      {required this.foodName,
      required this.rating,
      required this.recipe,
      required this.numberOfLikes});
}
