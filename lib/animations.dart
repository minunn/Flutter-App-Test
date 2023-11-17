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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        // Ensure the widget rebuilds when the animation value changes
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  void _resetAnimation() {
    _animationController.reset();
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
              child: LinearProgressIndicator(
                value: _animation.value,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
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
