import 'dart:convert';

import 'package:flutter_command/flutter_command.dart';
import 'package:get_it/get_it.dart';
import 'package:match_number/models/score_model.dart';
import 'package:match_number/services/local_storage_service.dart';

class StatsViewModel {
  late int? _score;
  late String _name;
  late Command<void, bool> saveChampionCommand;
  late Command<void, List<ScoreModel>> loadChampionsCommand;
  late Command<String, String> championNameChangedCommand;
  StatsViewModel(int? score) {
    _score = score;
    championNameChangedCommand =
        Command.createSync((x) => onNameChanged(x), '');
    saveChampionCommand = Command.createSync((x) => onChampionSaved(), false);
    loadChampionsCommand =
        Command.createSync((x) => getChampions(), getChampions());
  }

  List<ScoreModel> getChampions() {
    final service = GetIt.I.get<LocalStorageService>();
    final String highScores = service.getItem('scores');

    if (highScores != "None") {
      final scoreString = jsonDecode(highScores) as List<dynamic>;
      final champions =
          scoreString.map((e) => ScoreModel.fromJson(e as String)).toList();
      champions.sort(
          (a, b) => (a.score > b.score) ? 1 : ((b.score > a.score) ? -1 : 0));
      return champions;
    } else {
      return List<ScoreModel>.empty(growable: true);
    }
  }

  bool onChampionSaved() {
    final service = GetIt.I.get<LocalStorageService>();
    final ScoreModel champObj = ScoreModel(name: _name, score: _score!);
    final List<ScoreModel> scoreModels = getChampions();

    if (scoreModels.length >= 5) {
      scoreModels[4] = champObj;
    } else {
      scoreModels.add(champObj);
    }
    final String serializedScores = jsonEncode(scoreModels);
    service.setItem('scores', serializedScores);
    return true;
  }

  String onNameChanged(String x) {
    return _name = x;
  }
}
