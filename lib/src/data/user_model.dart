import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier{
  UserModel(){
    init();
  }
  late ValueNotifier<int> highScore = ValueNotifier(0);
  late ValueNotifier<int> levelsUnlocked = ValueNotifier(1);
  late SharedPreferences prefs;

  void init() async{
    prefs = await SharedPreferences.getInstance();
    highScore = ValueNotifier(prefs.getInt('highScore') ?? 0);
    // levelsUnlocked = ValueNotifier(prefs.getInt('levelsUnlocked') ?? 1);

    highScore.addListener(() {
      prefs.setInt('highScore', highScore.value);
    });
    levelsUnlocked.addListener(() {
      prefs.setInt('levelsUnlocked', levelsUnlocked.value);
    });
  }
}