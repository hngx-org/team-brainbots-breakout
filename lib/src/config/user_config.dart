import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserConfig extends ChangeNotifier{
  late ValueNotifier<int> highScore;
  late ValueNotifier<int> levelsUnlocked;
  late ValueNotifier<bool> musicOn;
  late ValueNotifier<double> musicVolume;
  late ValueNotifier<double> sfxVolume;
  late ValueNotifier<bool> sfxOn;
  late SharedPreferences prefs;

  Future<void> init() async{
    prefs = await SharedPreferences.getInstance();

    highScore = ValueNotifier(prefs.getInt('highScore') ?? 0);
    levelsUnlocked = ValueNotifier(prefs.getInt('levelsUnlocked') ?? 1);

    musicOn = ValueNotifier(prefs.getBool('musicOn') ?? true);
    musicVolume = ValueNotifier(prefs.getDouble('musicVolume') ?? 0.5);
    sfxVolume = ValueNotifier(prefs.getDouble('sfxVolume') ?? 0.5);
    sfxOn = ValueNotifier(prefs.getBool('sfxOn') ?? true);


    highScore.addListener(() {
      prefs.setInt('highScore', highScore.value);
    });
    levelsUnlocked.addListener(() {
      prefs.setInt('levelsUnlocked', levelsUnlocked.value);
    });

    musicOn.addListener(() {
      prefs.setBool('musicOn', musicOn.value);
    });
    musicVolume.addListener(() {
      prefs.setDouble('musicVolume', musicVolume.value);
    });
    sfxVolume.addListener(() {
      prefs.setDouble('sfxVolume', sfxVolume.value);
    });
    sfxOn.addListener(() {
      prefs.setBool('sfxOn', sfxOn.value);
    });
  }
}

final userConfig = UserConfig();