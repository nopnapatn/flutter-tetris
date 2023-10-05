import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/custom_pixel.dart';
import 'package:tetris/piece.dart';
import 'package:tetris/values.dart';

List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  Piece currentPiece = Piece(type: Tetromino.T);

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();
    Duration fps = const Duration(milliseconds: 800);
    gameLoop(fps);
  }

  void gameLoop(Duration fps) {
    Timer.periodic(fps, (timer) {
      setState(() {
        checkLanding();
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  bool checkCollision(Direction direction) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }
    }
    return false;
  }

  void checkLanding() {
    if (checkCollision(Direction.down)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;

        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      createNewPiece();
    }
  }

  void createNewPiece() {
    Random rand = Random();
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GridView.builder(
          itemCount: rowLength * colLength,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: rowLength,
          ),
          itemBuilder: (context, index) {
            int row = (index / rowLength).floor();
            int col = index % rowLength;
            if (currentPiece.position.contains(index)) {
              return CustomPixel(
                color: Colors.black,
                child: index.toString(),
              );
            } else if (gameBoard[row][col] != null) {
              return const CustomPixel(color: Colors.black, child: '');
            } else {
              return CustomPixel(
                color: Colors.white,
                child: index.toString(),
              );
            }
          }),
    );
  }
}
