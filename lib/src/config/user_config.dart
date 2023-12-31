import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserConfig extends ChangeNotifier{
  late ValueNotifier<int> highScore;
  late ValueNotifier<int> noGamesPlayed;
  late ValueNotifier<int> noGamesWon;
  late ValueNotifier<Duration> totalGameTime;
  late ValueNotifier<Duration> bestTime;
  late ValueNotifier<int> levelsUnlocked;
  late ValueNotifier<bool> musicOn;
  late ValueNotifier<bool> sfxOn;
  late SharedPreferences prefs;

  Future<void> init() async{
    prefs = await SharedPreferences.getInstance();

    highScore = ValueNotifier(prefs.getInt('highScore') ?? 0);
    noGamesPlayed = ValueNotifier(prefs.getInt('noGamesPlayed') ?? 0);
    noGamesWon = ValueNotifier(prefs.getInt('noGamesWon') ?? 0);
    totalGameTime = ValueNotifier(Duration(seconds: prefs.getInt('totalGameTime') ?? 0));
    bestTime = ValueNotifier(Duration(seconds: prefs.getInt('bestTime') ?? 0));
    levelsUnlocked = ValueNotifier(prefs.getInt('levelsUnlocked') ?? 1);
    
    musicOn = ValueNotifier(prefs.getBool('musicOn') ?? true);
    sfxOn = ValueNotifier(prefs.getBool('sfxOn') ?? true);


    highScore.addListener(() {
      prefs.setInt('highScore', highScore.value);
    });
    noGamesPlayed.addListener(() {
      prefs.setInt('noGamesPlayed', noGamesPlayed.value);
    });
    noGamesWon.addListener(() {
      prefs.setInt('noGamesWon', noGamesWon.value);
    });
    totalGameTime.addListener(() {
      prefs.setInt('totalGameTime', totalGameTime.value.inSeconds);
    });
    bestTime.addListener(() {
      prefs.setInt('bestTime', bestTime.value.inSeconds);
    });
    levelsUnlocked.addListener(() {
      prefs.setInt('levelsUnlocked', levelsUnlocked.value);
    });

    musicOn.addListener(() {
      prefs.setBool('musicOn', musicOn.value);
    });
    sfxOn.addListener(() {
      prefs.setBool('sfxOn', sfxOn.value);
    });
  }
}

final userConfig = UserConfig();