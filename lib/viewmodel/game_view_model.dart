import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:get_it/get_it.dart';
import 'package:match_number/models/number_model.dart';
import 'package:match_number/services/local_storage_service.dart';

class GameViewModel {
  int score;
  final AudioPlayer player = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  final AudioCache playerCache = AudioCache();

  int _target;
  int _output;
  int timeOut;
  List<NumberModel> numbers;
  List<int> _travelledNumbers;
  late Timer _timer;
  late Command<void, void> onMouseUp;
  late Command<int, void> onMouseMove;
  late Command<int, void> onMouseDown;
  late Command<int, int> scoreCommand;
  late Command<int, int> targetCommand;
  late Command<int, int> outputCommand;
  late Command<int, int> timeOutCommand;
  late Command<bool, bool> gamePausedOrOverCommand;
  late Command<bool, bool> gameResumedCommand;
  late LocalStorageService service;
  List<Command<NumberModel, NumberModel>> tileCommands =
      List.empty(growable: true);

  GameViewModel()
      : numbers = List.empty(growable: true),
        _target = 0,
        _output = 0,
        score = 0,
        timeOut = 31,
        _travelledNumbers = List.empty(growable: true) {
    _initGame();
    service = GetIt.I.get<LocalStorageService>();
  }

  int generateRandom(int max) {
    final Random random = Random();
    return random.nextInt(max) + 1;
  }

  void startTimer(int timerDuration) {
    _timer.cancel();

    timeOut = timerDuration;
    timeOutCommand.execute(timerDuration);

    _timer = initTimer();
  }

  Timer initTimer() {
    const oneSec = Duration(seconds: 1);
    return Timer.periodic(
      oneSec,
      (Timer timer) {
        if (timeOut <= 0) {
          gamePausedOrOverCommand.execute(true);
          playerCache.play('audio/game_over.mp3');
          timer.cancel();
        } else {
          timeOut = timeOut - 1;
          timeOutCommand.execute(timeOut);
        }
      },
    );
  }

  void dispose() {
    _timer.cancel();
  }

  void onPaused() {
    service.setItem("timeOut", timeOut.toString());
    service.setItem("score", score.toString());
    _timer.cancel();
  }

  void playWinAudio() {
    playerCache.play('audio/win1.wav');
  }

  void resumeGame() {
    final String savedTimeOut = service.getItem("timeOut");
    final String savedScore = service.getItem("score");

    createGame();

    if (savedTimeOut == "None" || savedScore == "None") {
    } else {
      final int convertedTime = int.parse(savedTimeOut);
      _timer = initTimer();
      startTimer(convertedTime);
      scoreCommand.execute(int.parse(savedScore));
      timeOutCommand.execute(convertedTime);
    }
  }

  void onResumed() {
    gameResumedCommand.execute(true);
  }

  void _initGame() {
    playerCache.loadAll(['audio/win1.wav', 'audio/game_over.mp3']);
    targetCommand = Command.createSync((x) => onTargetChanged(x), 0);
    outputCommand = Command.createSync((x) => onOutputChanged(x), 0);
    scoreCommand = Command.createSync((x) => onScoreChanged(x), 0);
    onMouseUp = Command.createSync((x) => onGameMouseUp(), null);
    onMouseDown = Command.createSync((x) => onGameMouseDown(x), null);
    onMouseMove = Command.createSync((x) => onGameMouseMove(x), null);
    timeOutCommand = Command.createSync((x) => x, timeOut);
    gamePausedOrOverCommand = Command.createSync((x) => x, false);
    gameResumedCommand = Command.createSync((x) => x, false);
  }

  void createGame() {
    _timer = initTimer();
    startTimer(31);
    outputCommand.execute(0);
    scoreCommand.execute(0);
    numbers.clear();
    for (var index = 0; index < 16; index++) {
      final NumberModel model = NumberModel(
          color: generateRandom(3),
          isRotate: false,
          isTouched: false,
          numberIndex: index,
          numberValue: generateRandom(3));
      numbers.add(model);
      if (tileCommands.length == 16) {
        tileCommands[index].execute(model);
      } else {
        tileCommands.add(Command.createSync((x) => onTileMouseMove(x), model));
      }
    }
    gameResumedCommand.execute(false);
    gamePausedOrOverCommand.execute(false);
    targetCommand.execute(generateTarget(generateRandom(15), -1, 1));
  }

  int generateTarget(int startNum, int inputTarget, int iterate) {
    int target = 0;
    int targetVal = inputTarget;
    int currStartNum = startNum;
    for (var index = 0; index < iterate; index++) {
      targetVal = numbers[currStartNum].color == 1
          ? -numbers[currStartNum].numberValue
          : numbers[currStartNum].numberValue;

      currStartNum = getNextPosition(currStartNum);
      final color = numbers[currStartNum].color;
      target = getOutput(color, targetVal, numbers[currStartNum].numberValue);
    }
    return target;
  }

  int getNextPosition(int startNum) {
    int currStartNum = startNum;
    var nextTarget = -1;
    switch (currStartNum) {
      case 0:
        nextTarget = generateRandom(2);
        if (nextTarget == 1) {
          currStartNum = currStartNum + 1;
        } else {
          currStartNum = currStartNum + 4;
        }
        break;
      case 4:
      case 8:
        nextTarget = generateRandom(3);
        if (nextTarget == 1) {
          currStartNum = currStartNum + 1;
        } else if (nextTarget == 2) {
          currStartNum = currStartNum + 4;
        } else {
          currStartNum = currStartNum - 4;
        }
        break;
      case 12:
        nextTarget = generateRandom(2);
        if (nextTarget == 1) {
          currStartNum = currStartNum + 1;
        } else {
          currStartNum = currStartNum - 4;
        }
        break;
      case 3:
        nextTarget = generateRandom(2);
        if (nextTarget == 1) {
          currStartNum = currStartNum - 1;
        } else {
          currStartNum = currStartNum + 4;
        }
        break;
      case 7:
      case 11:
        nextTarget = generateRandom(3);
        if (nextTarget == 1) {
          currStartNum = currStartNum - 1;
        } else if (nextTarget == 2) {
          currStartNum = currStartNum + 4;
        } else {
          currStartNum = currStartNum - 4;
        }
        break;
      case 15:
        nextTarget = generateRandom(2);
        if (nextTarget == 1) {
          currStartNum = currStartNum - 1;
        } else {
          currStartNum = currStartNum - 4;
        }
        break;
      default:
        break;
    }
    return currStartNum;
  }

  int getOutput(int color, int targetVal, int currNum) {
    if (color == 1) {
      return targetVal - currNum;
    } else if (color == 2) {
      return targetVal + currNum;
    } else {
      return targetVal * currNum;
    }
  }

  int rejectOutput(int color, int targetVal, int currNum) {
    if (color == 2) {
      return targetVal - currNum;
    } else if (color == 1) {
      return targetVal + currNum;
    } else {
      return targetVal ~/ currNum;
    }
  }

  void onGameMouseMove(int currEleIndex) {
    final travelledNumbersLength = _travelledNumbers.length;
    final touchingData = numbers[currEleIndex];
    final int currIndex = currEleIndex;
    if (travelledNumbersLength > 1) {
      final index = _travelledNumbers[travelledNumbersLength - 2];
      if (index == currIndex) {
        final removedData = numbers.firstWhere((NumberModel num) =>
            num.numberIndex == _travelledNumbers[travelledNumbersLength - 1]);

        tileCommands[_travelledNumbers[travelledNumbersLength - 1]]
            .execute(removedData.copyWith(isTouched: false));
        removedData.isTouched = false;

        _travelledNumbers.removeLast();
        outputCommand.execute(
            rejectOutput(removedData.color, _output, removedData.numberValue));
      }
    }

    if (_travelledNumbers.contains(currIndex)) {
      return;
    }

    if (travelledNumbersLength > 0) {
      final index = _travelledNumbers.last;

      if (!(index == currIndex - 1 ||
          index == currIndex + 1 ||
          index == currIndex + 4 ||
          index == currIndex - 4)) return;
    }
    _travelledNumbers.add(currIndex);

    tileCommands[currEleIndex].execute(touchingData.copyWith(isTouched: true));
    touchingData.isTouched = true;

    outputCommand.execute(
        getOutput(touchingData.color, _output, touchingData.numberValue));
  }

  int onTargetChanged(int x) {
    _target = x;
    return _target = x;
  }

  int onOutputChanged(int x) {
    _output = x;
    return _output = x;
  }

  NumberModel onTileMouseMove(NumberModel x) {
    numbers[x.numberIndex] = x;
    return x;
  }

  void onGameMouseDown(int index) {
    final model = numbers[index];
    tileCommands[index].execute(model.copyWith(isTouched: true));
    outputCommand.execute(numbers[index].color == 1
        ? -numbers[index].numberValue
        : numbers[index].numberValue);
    _travelledNumbers.add(index);
  }

  void onGameMouseUp() {
    final List<NumberModel> numbersTouched =
        numbers.where((NumberModel num) => num.isTouched == true).toList();
    final bool success = _target == _output;
    if (numbersTouched.length == 1) {
      _output = 0;
      _travelledNumbers = List.empty(growable: true);
      final NumberModel model = numbersTouched[0];
      tileCommands[model.numberIndex].execute(model.copyWith(isTouched: false));
      return;
    }
    for (var index = 0; index < numbersTouched.length; index++) {
      final element = numbersTouched[index];
      final NumberModel newElement = element.copyWith(isTouched: false);
      if (success) {
        newElement.numberValue = generateRandom(3);
        newElement.color = generateRandom(3);
        newElement.isRotate = !element.isRotate;
      }
      tileCommands[newElement.numberIndex].execute(newElement);
    }
    if (success) {
      playWinAudio();
      scoreCommand.execute(score + numbersTouched.length * 20);

      timeOut = timeOut + numbersTouched.length;
      timeOutCommand.execute(timeOut);

      targetCommand.execute(success
          ? generateTarget(generateRandom(15), -1, _getTargetIteration())
          : _target);
    }
    outputCommand.execute(0);
    _travelledNumbers = List.empty(growable: true);
  }

  int _getTargetIteration() {
    int targetCount = score ~/ 100;
    targetCount = targetCount < 5 ? targetCount : 4;
    targetCount = targetCount > 0 ? targetCount : 1;
    return targetCount;
  }

  int onScoreChanged(int x) {
    score = x;
    return score = x;
  }
}
