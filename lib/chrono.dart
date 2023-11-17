import 'package:flutter/material.dart';

import 'ChronometerBloc.dart';

class Chronometer extends StatefulWidget {
  @override
  _ChronometerState createState() => _ChronometerState();
}

class _ChronometerState extends State<Chronometer> {
  late ChronometerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ChronometerBloc();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chronometer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<double>(
              stream: _bloc.timeStream,
              builder: (context, snapshot) {
                final seconds = snapshot.data ?? 0.0;
                return Text(
                  seconds.toStringAsFixed(1),
                  style: TextStyle(fontSize: 80),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _bloc.start();
                  },
                  child: Text('Start'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _bloc.stop();
                  },
                  child: Text('Stop'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _bloc.reset();
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
