import 'package:flutter/material.dart';
import 'package:tictactoe/controllers/game_controller.dart';
import 'package:tictactoe/core/constants.dart';
import 'package:tictactoe/enums/player_type.dart';
import 'package:tictactoe/enums/winner_type.dart';
import 'package:tictactoe/widgets/custom_dialog.dart';
import 'package:share/share.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _controller = GameController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text(GAME_TITLE),
      centerTitle: true,
      actions: [_buildShareButton()],
    );
  }

  _buildBody() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCurrentPlayer(),
          _buildBoard(),
          _buildScore(),
          _buildPlayerMode(),
          _buildResetButton(),
        ],
      ),
    );
  }

  _buildShareButton() {
    return RaisedButton(
      padding: const EdgeInsets.all(20),
      child: Text(SHARE_BUTTON_LABEL),
      onPressed: _onShare,
    );
  }

  _onShare() {
    Share.share('Check out Rick and Morty Tic Tac Toe');
  }

  _buildCurrentPlayer() {
    return Center(
        child: Text(
      _controller.currentPlayer == PlayerType.player1
          ? PLAYER1_TURN
          : PLAYER2_TURN,
      style: TextStyle(
        fontSize: 40.0,
        color: Colors.black,
      ),
    ));
  }

  _buildScore() {
    return Center(
        child: Text(
      PLAYER1_WINS +
          _controller.playerOneWins.toString() +
          "\n" +
          PLAYER2_WINS +
          _controller.playerTwoWins.toString(),
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.black,
      ),
    ));
  }

  _buildResetButton() {
    return RaisedButton(
      padding: const EdgeInsets.all(20),
      child: Text(RESET_BUTTON_LABEL),
      onPressed: _onResetGame,
    );
  }

  _buildBoard() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: BOARD_SIZE,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: _buildTile,
      ),
    );
  }

  Widget _buildTile(context, index) {
    return GestureDetector(
      onTap: () => _onMarkTile(index),
      child: Container(
        color: _controller.tiles[index].color,
        child: Center(
          child: Text(
            _controller.tiles[index].symbol,
            style: TextStyle(
              fontSize: 72.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _onResetGame() {
    setState(() {
      _controller.reset();
    });
  }

  _onMarkTile(index) {
    if (!_controller.tiles[index].enable) return;

    setState(() {
      _controller.markBoardTileByIndex(index);
    });

    _checkWinner();
  }

  _checkWinner() {
    var winner = _controller.checkWinner();
    if (winner == WinnerType.none) {
      if (!_controller.hasMoves) {
        _showTiedDialog();
      } else if (_controller.isSinglePlayer &&
          _controller.currentPlayer == PlayerType.player2) {
        final index = _controller.automaticMove();
        _onMarkTile(index);
      }
    } else {
      String player;
      String image;
      if (winner == WinnerType.player1) {
        player = PLAYER1;
        image = "assets/image_rick.jpg";
        _controller.playerOneWins++;
      } else {
        player = PLAYER2;
        image = "assets/image_morty.png";
        _controller.playerTwoWins++;
      }
      _showWinnerDialog(player, image);
    }
  }

  _showWinnerDialog(String player, String image) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          title: WIN_TITLE.replaceAll('[Player]', player),
          message: DIALOG_MESSAGE,
          image: image,
          onPressed: _onResetGame,
        );
      },
    );
  }

  _showTiedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          title: TIED_TITLE,
          message: DIALOG_MESSAGE,
          onPressed: _onResetGame,
        );
      },
    );
  }

  _buildPlayerMode() {
    return SwitchListTile(
      title: Text(_controller.isSinglePlayer
          ? SINGLE_PLAYER_MODE_LABEL
          : MULTIPLAYER_MODE_LABEL),
      secondary: Icon(_controller.isSinglePlayer ? Icons.person : Icons.group),
      value: _controller.isSinglePlayer,
      onChanged: (value) {
        setState(() {
          _controller.isSinglePlayer = value;
        });
      },
    );
  }
}
