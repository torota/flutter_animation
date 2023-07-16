// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:flutter/material.dart';

class SwapingCardsScreen extends StatefulWidget {
  const SwapingCardsScreen({super.key});

  @override
  State<SwapingCardsScreen> createState() => _SwapingCardsScreenState();
}

class _SwapingCardsScreenState extends State<SwapingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
    value: 0.0,
    lowerBound: (size.width + 100) * -1,
    upperBound: size.width + 100,
  );

  late final Tween<double> _rotation = Tween(
    begin: -15.0,
    end: 15.0,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1.0,
  );

  double posX = 0;
  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _onHorizontalDragUpdate(DragUpdateDetails details) {
      _position.value += details.delta.dx;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swaping Cards'),
      ),
      body: AnimatedBuilder(
          animation: _position,
          builder: (context, child) {
            final angle = _rotation.transform(
                    (_position.value + size.width / 2) / size.width) *
                pi /
                180;

            final scale = _scale.transform(
                (_position.value.abs() + size.width / 2) / size.width);
            print(angle);
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 100,
                  child: Transform.scale(
                    scale: scale,
                    child: Material(
                      elevation: 10,
                      color: Colors.blue.shade100,
                      child: SizedBox(
                        width: size.width * 0.8,
                        height: size.height * 0.5,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  child: GestureDetector(
                    onHorizontalDragUpdate: _onHorizontalDragUpdate,
                    onHorizontalDragEnd: _onHorizontalDragEnd,
                    child: Transform.translate(
                      offset: Offset(_position.value, 0),
                      child: Transform.rotate(
                        angle: angle,
                        child: Material(
                          elevation: 10,
                          color: Colors.red.shade100,
                          child: SizedBox(
                            width: size.width * 0.8,
                            height: size.height * 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200;
    final dropZone = size.width + 100;
    if (_position.value.abs() >= bound) {
      if (_position.value.isNegative) {
        _position.animateTo(
          (dropZone) * -1,
          curve: Curves.easeOut,
        );
      } else {
        _position.animateTo(
          dropZone,
          curve: Curves.easeOut,
        );
      }
    } else {
      _position.animateTo(
        0,
        curve: Curves.easeOut,
      );
    }
  }
}

class Card extends StatelessWidget {
  const Card({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
