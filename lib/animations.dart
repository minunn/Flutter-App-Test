import 'package:flutter/material.dart';

class AnimationsWidget extends StatefulWidget {
  const AnimationsWidget({Key? key}) : super(key: key);

  @override
  _AnimationsWidgetState createState() => _AnimationsWidgetState();
}

class _AnimationsWidgetState extends State<AnimationsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late ValueNotifier<double> _toAnimateNotifier;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _toAnimateNotifier = ValueNotifier<double>(0);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        _toAnimateNotifier.value = _animation.value;
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _toAnimateNotifier.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _animationController.value = _toAnimateNotifier.value;
    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  void _resetAnimation() {
    _animationController.reset();
    _toAnimateNotifier.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Progress bar
            Container(
              width: 200, // Adjust the width as needed
              child: ValueListenableBuilder<double>(
                valueListenable: _toAnimateNotifier,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
            // Start button
            ElevatedButton(
              onPressed: _startAnimation,
              child: Text('Start Animation'),
            ),
            const SizedBox(height: 20.0),
            // Reset button
            ElevatedButton(
              onPressed: _resetAnimation,
              child: Text('Reset Animation'),
            ),
          ],
        ),
      ),
    );
  }
}
