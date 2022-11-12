import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String pass = '';
  bool _switch1 = true;
  bool _switch2 = true;
  double _sliderValue = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.topRight,
            child: const Text(
              'sht06025 님   ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
              height:0.8,
              width:500.0,
              color:Colors.black
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   피드백 설정',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 3,
                    ),
                    Transform.scale(
                      scale: 0.80,
                      child: CupertinoSwitch(
                        value: _switch1,
                        onChanged: (bool value) {
                          setState(() {
                            _switch1 = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              height:0.8,
              width:500.0,
              color:Colors.black
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   피드백 알람 시간',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 3,
                    ),
                    Transform.scale(
                      scale: 0.80,
                      child: CupertinoSwitch(
                        value: _switch2,
                        onChanged: (bool value) {
                          setState(() {
                            _switch2 = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              height:0.8,
              width:500.0,
              color:Colors.black
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   여성복 추천',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 3,
                    ),
                    Transform.scale(
                      scale: 0.80,
                      child: CupertinoSwitch(
                        value: _switch2,
                        onChanged: (bool value) {
                          setState(() {
                            _switch2 = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              height:0.8,
              width:500.0,
              color:Colors.black
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   체질 설정',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 3,
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        thumbColor: Colors.white,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 11.0),
                        overlayColor: Colors.green.withOpacity(0.18),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
                        activeTrackColor: Color(0xFF34C759),
                        inactiveTrackColor: Colors.grey.shade300,
                        trackHeight: 11.0,
                        showValueIndicator: ShowValueIndicator.never,
                      ),
                      child: Slider(
                          min: 0,
                          max: 20,
                          value: _sliderValue,
                          divisions: 4,
                          label: _sliderValue.toString(),
                          onChanged: (double val) {
                            setState(() {
                              _sliderValue = val;
                            });
                          }
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          '추워요',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(
                          width: 45,
                        ),
                        const Text(
                          '보통',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(
                          width: 45,
                        ),
                        const Text(
                          '더워요',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              height:0.8,
              width:500.0,
              color:Colors.black
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   내 옷장',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                TextButton(style: TextButton.styleFrom(foregroundColor: Colors.black),
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, '/closet');
                      });
                    }, child: const Text('    >', style: TextStyle(fontSize: 18),)),
              ],
            ),
          ),
          Container(
              height:0.8,
              width:500.0,
              color:Colors.black
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   로그아웃',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                TextButton(style: TextButton.styleFrom(foregroundColor: Colors.black),
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, '/login');
                      });
                    }, child: const Text('    >', style: TextStyle(fontSize: 18))),
              ],
            ),
          ),
          Container(
              height:0.8,
              width:500.0,
              color:Colors.black
          ),
        ],
      ),
    );
  }
}