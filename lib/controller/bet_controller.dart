import 'dart:core';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:bet/global/notification.dart';
import 'package:bet/model/chat_model.dart';
import 'package:bet/model/players_model.dart';
import 'package:bet/services/socket.dart';
import 'package:bet/view/dialog/dialog_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../config/enum.dart';
import '../global/counter_down/counter_down_controller.dart';
import '../global/gif_widget.dart';
import '../global/storage.dart';
import '../view/dialog/dialog_leader_board.dart';

class BetController extends GetxController with GetTickerProviderStateMixin {
  final ScrollController scrollC = ScrollController();
  final ScrollController scrollControllerOnlinePlayers = ScrollController();
  TextEditingController amountController = TextEditingController();
  TextEditingController autoCashOutController = TextEditingController();
  TextEditingController chatController = TextEditingController();
  RxInt onlineUsers = 0.obs;
  RxInt players = 0.obs;
  var chatItems = List<ChatModel>.empty().obs;
  var gameHistory = [].obs;
  late Socket socket;
  RxBool loadingPage = true.obs;
  RxInt startAtTime = 0.obs;
  Rx<GameState> gameState = GameState.started.obs;
  dynamic endedData = {}.obs;
  RxInt gameTick = 0.obs;
  RxInt gameTotalBet = 0.obs;
  RxBool firstGif = false.obs;
  var playersItems = List<PlayersModel>.empty().obs;

  // RxBool enableButtonBet = true.obs;
  // RxBool enableButtonCashOut = true.obs;
  RxDouble availableMoney = 0.0.obs;
  bool isPlayed = false;
  late CountdownController controller;
  FocusNode focusNode = FocusNode();

  // RxInt timeSec = 0.obs;

  FlutterGifController? gifController, gifEndController;
  final audioPlayer = AudioPlayer();
  RxBool mute = false.obs;
  RxDouble maxCashOut = 0.0.obs;

  void startTimer() {
    controller.restart();
  }

  void startTimerChangeGif() {
    gifController?.reset();
    gifController?.animateTo(59, duration: const Duration(milliseconds: 2400));
    Future.delayed(const Duration(milliseconds: 2400), () {
      firstGif.value = false;
    });
  }

  @override
  void onInit() {
    super.onInit();
    setupSocket();
    controller = CountdownController(autoStart: true);
    gifController = FlutterGifController(vsync: this);
    gifEndController = FlutterGifController(vsync: this);
  }

  @override
  void onClose() {
    disConnectSocket();
    controller.pause();
    gifController?.dispose();
    gifEndController?.dispose();
    audioPlayer.dispose();
    super.onClose();
  }

  void playSoundAsFirst() async {
    if (Get.currentRoute != "/bet") return;
    if (mute.value) return;
    await audioPlayer.play(UrlSource(
        "https://bustabit.kayak-studio.com/assets/assets/sound/sound.mp3"));
    audioPlayer.printError();
    await AudioPlayer.global.changeLogLevel(LogLevel.error);
    audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  void handleMute() {
    mute.value = !mute.value;
  }

  handleIconButtonLogin() {
    Storage.isTokenSaved.value
        ? Get.toNamed('/profile')
        : Get.toNamed('/login-signup');
  }

  handleSwap() {
    Storage.isTokenSaved.value
        ? Get.toNamed("/swap",
            arguments: Get.toNamed("/swap", arguments: getUserBalance))
        : showSnackbar(
            "Error", "Please Login First", LineIcons.exclamationTriangle);
  }

  handleCashier() {
    Storage.isTokenSaved.value
        ? Get.toNamed("/cashier")
        : showSnackbar(
            "Error", "Please Login First", LineIcons.exclamationTriangle);
  }

  double roundDown(double value, int precision) {
    final isNegative = value.isNegative;
    final mod = pow(10.0, precision);
    final roundDown = (((value.abs() * mod).floor()) / mod);
    return isNegative ? -roundDown : roundDown;
  }

  //================= sockets
  void setupSocket() async {
    // socket = io(
    //     'https://ws.bullbets.io',
    //     OptionBuilder()
    //         .setTransports(['websocket'])
    //         // .enableForceNew()
    //         .disableAutoConnect()
    //         .disableMultiplex()
    //         .disableForceNew()
    //         // .enableReconnection()
    //         // .setReconnectionAttempts(5)
    //         .build());
    socket = SocketSingleton().getSocketInstance();

    socket.io.options['query'] = {'authorization': await getValue("token")};
    socket.disconnect().connect();

    socket.onConnectError((data) {
      showSnackbar("Error", "Connection Error", LineIcons.exclamationTriangle);
      backButtonHandle();
    });

    socket.onConnect((_) {
      loadingPage.value = false;
      socketON();
      // print('socket connect');
    });
    socket.onDisconnect((_) {
      // if (Get.currentRoute == "/bet") {
      //   setupSocket();
      // }
      socket.clearListeners();
    });
  }

  void socketON() {
    socketOnlineUsers();
    socketPlayerJoinedCount();
    socketGameStarting();
    socketGamePending();
    socketGameStarted();
    socketGameTick();
    socketGameEnded();
    socketChat();
    socketMessage();
    socketChatCommand();
    socketPlayerJoinedGame();
    socketPlayerCashedOut();
    socketGameTotalBet();
    getUserBalance();
    socketLastGame();
    socketGetActiveGamePlayers();
    // socketGetTime();
  }

  void socketLastGame() {
    socket.emitWithAck("get_latest_games", 1, ack: (json) {
      gameHistory.value = [];
      json["games"].forEach((item) {
        if (gameHistory.length < 6) {
          gameHistory.add(item['crashPoint']);
        }
      });
    });
  }

  void socketGetActiveGamePlayers() {
    socket.emitWithAck("get_active_game_players", 1, ack: (json) {
      if (json.isNotEmpty) {
        json['game']['players']['players'].forEach((key, value) {
          var player = PlayersModel(
              userId: value['userId'],
              username: value['username'],
              amount: value['amount'],
              color: Colors.transparent);
          if (!playersItems.contains(player)) playersItems.add(player);
        });
        // playersItems.add(PlayersModel.fromJson(value));
      }
    });
  }

  void disConnectSocket() {
    socket.dispose();
  }

  void socketOnlineUsers() {
    if (!socket.hasListeners("online_users")) {
      socket.on("online_users", (data) => onlineUsers.value = data);
    }
  }

  void socketGameTotalBet() {
    if (!socket.hasListeners("game_total_bet")) {
      socket.on("game_total_bet", (data) => gameTotalBet.value = data['count']);
    }
  }

  void socketPlayerJoinedCount() {
    if (!socket.hasListeners("player_joined_count")) {
      socket.on("player_joined_count", (data) => players.value = data['count']);
    }
  }

  void socketGamePending() {
    if (!socket.hasListeners("pending_to_load_game")) {
      socket.on("pending_to_load_game", (data) {
        gameState.value = GameState.pending;
      });
    }
  }

  void socketGameStarting() {
    if (!socket.hasListeners("game_starting")) {
      socket.on("game_starting", (data) {
        playersItems.clear();
        gameState.value = GameState.starting;
        audioPlayer.seek(Duration.zero);
        playSoundAsFirst();
        startAtTime.value = data['startAt'] / 1000;
        startTimer();
      });
    }
  }

  void socketGameStarted() {
    if (!socket.hasListeners("game_started")) {
      socket.on("game_started", (data) {
        firstGif.value = true;
        startTimerChangeGif();
        gameState.value = GameState.started;
        socketLastGame();
      });
    }
  }

  void socketGameTick() {
    if (!socket.hasListeners("game_tick")) {
      socket.on("game_tick", (data) {
        gameTick.value = data;
      });
    }
  }

  void socketGameEnded() {
    if (!socket.hasListeners("game_ended")) {
      socket.on("game_ended", (data) {
        getUserBalance();
        endedData.value = data;
        playersItems.clear();
        isPlayed = false;
        if (data['players'].isNotEmpty) {
          data['players'].forEach((key, value) {
            var player = PlayersModel.fromJson(value);
            if (!playersItems.contains(player)) {
              playersItems.add(PlayersModel.fromJson(value));
            }
          });
        }
        gameState.value = GameState.ended;
        gifEndController?.reset();
        gifEndController?.animateTo(66,
            duration: const Duration(milliseconds: 2010));
      });
    }
  }

  void socketChat() {
    if (!socket.hasListeners("chat")) {
      socket.on("chat", (data) async {
        chatItems.insert(0, ChatModel.fromJson(data));
      });
    }
  }

  void socketChatCommand() {
    socket.emitWithAck("chat_command", {"command": "global_latest_messages"},
        ack: (json) async {
      chatItems.clear();
      json.forEach((item) {
        chatItems.add(ChatModel.fromJson(item));
      });
      await Future.delayed(const Duration(seconds: 1));
    });
  }

  void socketMessage() {
    if (!socket.hasListeners("message")) {
      socket.on("message", (data) async {
        isPlayed = true;
        showSnackbar("Success", "You enter to game", LineIcons.check);
      });
    }
  }

  void socketPlayerJoinedGame() {
    if (!socket.hasListeners("player_joined_game")) {
      socket.on("player_joined_game", (data) async {
        var player = PlayersModel(
            userId: data['userId'],
            username: data['username'],
            amount: data['amount'],
            cashedOutAt: data['cashedOutAt'],
            profit: data['profit'],
            color: Colors.transparent);
        playersItems.add(player);
      });
    }
  }

  void socketPlayerCashedOut() {
    if (!socket.hasListeners("player_cashed_out")) {
      socket.on("player_cashed_out", (data) async {
        for (var player in playersItems) {
          if (player.username == data['username']) {
            var model = PlayersModel(
                userId: data['userId'],
                username: data['username'],
                amount: data['amount'],
                cashedOutAt: data['cashedOutAt'],
                profit: data['profit'],
                color: Colors.green);
            playersItems.remove(player);
            if (!playersItems.contains(model)) playersItems.add(model);
            return;
          }
        }
      });
    }
  }

  void getUserBalance() {
    if (!Storage.isTokenSaved.value) return;
    socket.emitWithAck("user_balance", "get", ack: (json) async {
      availableMoney.value = json['user']['balance']['bux'];
    });
  }

  handleSendMessage(String message) {
    socket.emitWithAck('chat', {"channel": "global", "message": message},
        ack: (data) {
      if (data["status"] == "success") chatController.clear();
      focusNode.requestFocus();
    });
  }

  handleBet() {
    if (amountController.text.isNotEmpty &&
        int.parse(amountController.text) > 200) {
      return;
    }
    if (autoCashOutController.text.isNotEmpty &&
        (double.parse(autoCashOutController.text) <= 1 ||
            double.parse(autoCashOutController.text) > maxCashOut.value)) {
      return;
    }
    if (gameState.value == GameState.started) {
      showSnackbar(
          "Next round",
          "If you have enough bux, you will join to next round",
          LineIcons.gamepad);
    }
    var data = {
      "amount": int.parse(amountController.text),
      "autoCashOut": autoCashOutController.text.isEmpty
          ? 0
          : double.parse(autoCashOutController.text)
    };
    amountController.clear();
    autoCashOutController.clear();
    maxCashOut.value = 0;
    socket.emitWithAck('bet', data, ack: (data) {
      if (data["status"] == "success") {
        isPlayed = true;
        // isBet.value = false;
      } else {
        showSnackbar("Warning", data["message"], LineIcons.exclamationTriangle);
      }
    });
    getUserBalance();
  }

  handleCashOut() {
    socket.emitWithAck('game_cash_out', 1, ack: (data) {
      if (data["status"] == "success") {
        // enableButtonCashOut.value = false;
      } else {
        showSnackbar("Warning", data["message"], LineIcons.exclamationTriangle);
      }
    });
  }

  showLeaderBoard() {
    Get.dialog(Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: DialogLeaderBoard(),
    ));
  }

  showState(String userID, String username) {
    Get.dialog(Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: DialogState(
        userID: userID,
        username: username,
      ),
    ));
  }

  void backButtonHandle() {
    if (Get.previousRoute.isNotEmpty) {
      Get.back();
    } else {
      Get.offAndToNamed('/home');
    }
  }
}
