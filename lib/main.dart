import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simple_animations/simple_animations.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MaterialApp(theme: ThemeData(fontFamily: 'DaysOne'), home: Home(), debugShowCheckedModeBanner: false));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String title = 'Nicigkeit';
  String calculateImageDefault = 'assets/calculate_default.png';
  String calculateImagePressed = 'assets/calculate_pressed.png';
  String calculateImage = 'assets/calculate_default.png';
  double percentage = 0;
  bool boost = false;
  bool invert = false;
  bool show = false;
  bool calculate = false;
  bool muted = false;
  Color primaryPickerColor = Colors.red[300]!;
  Color secondaryPickerColor = Colors.amber[300]!;
  Color primaryColor = Colors.red[300]!;
  Color secondaryColor = Colors.amber[500]!;

  late ui.Image sliderThumb;

  Future<ui.Image> load(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  void initState() {
    load('assets/schieberegler_s_schatten.png').then((image) {
      setState(() {
        sliderThumb = image;
      });
    });
    super.initState();
  }

  // ValueChanged<Color> callback
  void changePrimaryColor(Color color) {
    setState(() => primaryPickerColor = color);
  }

  void changeSecondaryColor(Color color) {
    setState(() => secondaryPickerColor = color);
  }

  void reset(){
    setState(() {
      title = 'Nicigkeit';
      percentage = 0.0;
    });
  }

  Future<void> launchWebsite(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Can not launch ' + url);
    }
  }

  Future<void> showHowToDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('How To'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Die Nicigkeits-App funktioniert ganz einfach.', style: TextStyle(fontSize: 14.0)),
                Text('', style: TextStyle(fontSize: 14.0)),
                Text('1. Egal in welcher Situation du dich befindest, dein Umfeld möchte mit Sicherheit deine Meinung hören, auch ungefragt.', style: TextStyle(fontSize: 14.0)),
                Text('2. Time to Shine: Jetzt kannst du ganz einfach die App rausholen, die gewünschte Nicigkeit über den Regler einstellen und per Knopfdruck auf den Bildschirm katapultieren.', style: TextStyle(fontSize: 14.0)),
                Text('', style: TextStyle(fontSize: 14.0)),
                Text('Pro-Tipp: Du kannst die App auch an deine Situation anpassen, indem du oben auf den Titel klickst und deine Situation eingibst (z.B. ein Film, ein Song oder Essen).', style: TextStyle(fontSize: 14.0)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showInfoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Info'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Die Nicigkeits-App ist ein digitales Kommunikationstool für super präzises Feedback. Wir freuen uns über Feedback und Kritik, gerne per E-Mail an'),
                GestureDetector(child: Text('info@nicigkeit.com', style: TextStyle(color: Colors.blueAccent)), onTap: () => {
                  launchWebsite('mailto:info@nicigkeit.com?subject=Feedback')
                },),
                Text(''),
                GestureDetector(child: Text('www.nicigkeit.com', style: TextStyle(color: Colors.blueAccent)), onTap: () => {
                  launchWebsite('https://nicigkeit.com')
                },),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Gibt die erste primäre Farbe anhand der Nicigkeit-Prozentangabe zurück.
  Color getPrimaryColor(double percentage) {
    if (percentage < 10.0) {
      return Colors.green[400]!;
    }
    if (percentage >= 10.0 && percentage < 20.0) {
      return Colors.green[500]!;
    }
    if (percentage >= 20.0 && percentage < 30.0) {
      return Colors.green[300]!;
    }
    if (percentage >= 30.0 && percentage < 40.0) {
      return Colors.green[500]!;
    }
    if (percentage >= 40.0 && percentage < 50.0) {
      return Colors.green[300]!;
    }
    if (percentage >= 50.0 && percentage < 60.0) {
      return Colors.lime[400]!;
    }
    if (percentage >= 60.0 && percentage < 69.0) {
      return Colors.yellow[300]!;
    }
    if (percentage == 69.0) {
      return Colors.pink[300]!;
    }
    if (percentage >= 70.0 && percentage < 80.0) {
      return Colors.yellow[500]!;
    }
    if (percentage >= 80.0 && percentage < 100.0) {
      return Colors.orange[200]!;
    }
    if (percentage == 100.0) {
      return Colors.orange;
    }

    return Colors.orange;
  }

  Color getSecondaryColor(double percentage) {
    if (percentage < 10.0) {
      return Colors.grey[700]!;
    }
    if (percentage >= 10.0 && percentage < 20.0) {
      return Colors.grey[400]!;
    }
    if (percentage >= 20.0 && percentage < 30.0) {
      return Colors.blueGrey[600]!;
    }
    if (percentage >= 30.0 && percentage < 40.0) {
      return Colors.blue[400]!;
    }
    if (percentage >= 40.0 && percentage < 50.0) {
      return Colors.blue[400]!;
    }
    if (percentage >= 50.0 && percentage < 60.0) {
      return Colors.cyan[400]!;
    }
    if (percentage >= 60.0 && percentage < 69.0) {
      return Colors.lime[900]!;
    }
    if (percentage == 69.0) {
      return Colors.pink[100]!;
    }
    if (percentage >= 70.0 && percentage < 80.0) {
      return Colors.orange[400]!;
    }
    if (percentage >= 80.0 && percentage < 100.0) {
      return Colors.orange[900]!;
    }
    if (percentage == 100.0) {
      return Colors.red[600]!;
    }

    return Colors.orange;
  }

  String getSmiley(double percentage) {
    if (percentage < 10.0) {
      return 'assets/poo.png';
    }
    if (percentage >= 10.0 && percentage < 20.0) {
      return 'assets/vomiting.png';
    }
    if (percentage >= 20.0 && percentage < 30.0) {
      return 'assets/nauseated.png';
    }
    if (percentage >= 30.0 && percentage < 40.0) {
      return 'assets/unamused.png';
    }
    if (percentage >= 40.0 && percentage < 50.0) {
      return 'assets/neutral.png';
    }
    if (percentage >= 50.0 && percentage < 60.0) {
      return 'assets/slightly_smiling.png';
    }
    if (percentage >= 60.0 && percentage < 69.0) {
      return 'assets/smiling.png';
    }
    if (percentage == 69.0) {
      return 'assets/mr_bean.png';
    }
    if (percentage >= 70.0 && percentage < 80.0) {
      return 'assets/halo.png';
    }
    if (percentage >= 80.0 && percentage < 100.0) {
      return 'assets/star_struck.png';
    }
    if (percentage == 100.0) {
      return 'assets/smiling_heart.png';
    }

    return 'assets/smiling_heart.png';
  }

  String getComment(double percentage) {
    if (percentage < 10.0) {
      return 'Unangenehm..';
    }
    if (percentage >= 10.0 && percentage < 20.0) {
      return 'Puhhh..';
    }
    if (percentage >= 20.0 && percentage < 30.0) {
      return 'Alter?';
    }
    if (percentage >= 30.0 && percentage < 40.0) {
      return 'Erzähl mir weniger..';
    }
    if (percentage >= 40.0 && percentage < 50.0) {
      return 'Aha..';
    }
    if (percentage >= 50.0 && percentage < 60.0) {
      return 'Ok ich höre..!';
    }
    if (percentage >= 60.0 && percentage < 69.0) {
      return 'Alter!';
    }
    if (percentage == 69.0) {
      return 'Nice!';
    }
    if (percentage >= 70.0 && percentage < 80.0) {
      return 'Darf ich das klauen?';
    }
    if (percentage >= 80.0 && percentage < 100.0) {
      return 'Meister!';
    }
    if (percentage == 100.0) {
      return 'JUST WOOOOW!';
    }

    return 'WIE NICE DU BIST DENN?!?';
  }

  String getSound(double percentage) {
    if (percentage < 10.0) {
      return 'Step0-10.mp3';
    }
    if (percentage >= 10.0 && percentage < 20.0) {
      return 'Step10-20.mp3';
    }
    if (percentage >= 20.0 && percentage < 30.0) {
      return 'Step20-30.mp3';
    }
    if (percentage >= 30.0 && percentage < 40.0) {
      return 'Step30-40.mp3';
    }
    if (percentage >= 40.0 && percentage < 50.0) {
      return 'Step40-50.mp3';
    }
    if (percentage >= 50.0 && percentage < 60.0) {
      return 'Step50-60.mp3';
    }
    if (percentage >= 60.0 && percentage < 69.0) {
      return 'Step60-70.mp3';
    }
    if (percentage == 69.0) {
      return 'Step60-70.mp3';
    }
    if (percentage >= 70.0 && percentage < 80.0) {
      return 'Step70-80.mp3';
    }
    if (percentage >= 80.0 && percentage < 100.0) {
      return 'Step80-90.mp3';
    }
    if (percentage == 100.0) {
      return 'Step90-100.mp3';
    }

    return 'Step90-100.mp3';
  }

  AudioPlayer player = AudioPlayer();

  Future playSound() async {
    if (!muted) {
      await player.play(AssetSource(getSound(percentage)));
    }
    return player;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(41, 41, 54, 1),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                child: TextField(
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    controller: TextEditingController()..text = title,
                    maxLength: 20,
                    textAlign: TextAlign.center,
                    onSubmitted: (String value) async {
                      setState(() {
                        var trimmed = value.trim();
                        if(trimmed == "") {
                          title = "Nicigkeit";
                        }
                        else if(trimmed.length > 20) {
                          title = trimmed.substring(0, 20);
                        } else {
                          title = trimmed;
                        }
                      });
                    },
                    decoration: InputDecoration(hintText: 'Nicigkeit', hintStyle: TextStyle(color: Colors.white38)),
                    buildCounter: (context, { required currentLength, required isFocused, maxLength }) {
                      return Text(
                        "Edit",
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white38
                          )
                      );
                    },
                    style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70
                    )
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 40.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          getPrimaryColor(percentage),
                                          getSecondaryColor(percentage)
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 6.0,
                                          spreadRadius: 0.5,
                                          color: Colors.grey[900]!),
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      percentage.toInt().toString() + '%',
                                      style: TextStyle(
                                        fontSize: 60,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Image.asset(getSmiley(percentage)),
                                    height: 80.0,
                                  ),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(getComment(percentage),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white70)),
                                    )
                                  ]),
                              SizedBox(height: 10.0),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            muted = !muted;
                                          });
                                        },
                                        child: Icon(
                                          (muted ? Icons.volume_off : Icons.volume_up),
                                          size: 30.0,
                                          color: Colors.white38
                                        ),
                                      ),
                                    )
                                  ]),
                              SizedBox(height: 10.0),
                              GestureDetector(
                                  onTapDown: (details) {
                                    setState(() {
                                      calculateImage = calculateImagePressed;
                                    });
                                  },
                                  onTapUp: (details) {
                                    setState(() {
                                      calculateImage = calculateImageDefault;
                                    });
                                  },
                                  onTap: () {
                                    playSound().then((value) => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) => DisplayScreen(
                                      title,
                                      percentage,
                                      getPrimaryColor(percentage),
                                      getSecondaryColor(percentage),
                                      getSmiley(percentage),
                                      getComment(percentage),
                                      player
                                      )),
                                    )
                                    });

                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: calculateImage ==
                                                      'assets/calculate_default.png'
                                                  ? Color.fromRGBO(221, 88, 36, 1)
                                                  : Color.fromRGBO(78, 226, 235, 1),
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(18)),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 6.0,
                                                spreadRadius: 0.8,
                                                color: Colors.grey[900]!),
                                          ],
                                        ),
                                        child: Image.asset(calculateImage,
                                            width: 130.0),
                                      ),
                                    ],
                                  ))
                            ])),
                    Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset('assets/schieberegler_skala_left.png'),
                            RotatedBox(
                              quarterTurns: 3,
                              child: SliderTheme(
                                data: SliderThemeData(
                                    overlayShape: RoundSliderOverlayShape(
                                        overlayRadius: 22.0),
                                    overlayColor: Colors.transparent,
                                    trackShape: CustomTrackShape(),
                                    thumbShape: SliderThumbImage(sliderThumb)),
                                child: Slider(
                                  value: percentage,
                                  min: 0,
                                  max: 100,
                                  divisions: 100,
                                  activeColor: Color.fromRGBO(221, 88, 31, 1.0),
                                  inactiveColor: Colors.grey[700],
                                  onChanged: (double value) {
                                    setState(() {
                                      percentage = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.grey[900],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(icon: Icon(Icons.help, color: Colors.white30), onPressed: showHowToDialog),
                  IconButton(icon: Icon(Icons.home, color: Colors.white30), onPressed: reset),
                  IconButton(icon: Icon(Icons.info, color: Colors.white30), onPressed: showInfoDialog),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DisplayScreen extends StatelessWidget {
  final String title;
  final double percentage;
  final Color primaryColor;
  final Color secondaryColor;
  final String smiley;
  final String comment;
  final AudioPlayer player;

  const DisplayScreen(this.title, this.percentage, this.primaryColor,
      this.secondaryColor, this.smiley, this.comment, this.player);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => {
          player.stop(),
          Navigator.pop(context)
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(title, style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoopAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.8, end: 1.0),
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: Stack(
                              children: [
                                Text(percentage.toInt().toString() + '%',
                                    style: TextStyle(
                                      fontSize: 120,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 2
                                        ..color = Colors.grey[500]!,
                                    )
                                ),
                                Text(percentage.toInt().toString() + '%',
                                    style: TextStyle(
                                        fontSize: 120,
                                        color: Colors.white
                                    )
                                ),
                              ],
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset(this.smiley),
                          height: 120.0,
                        ),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Text(comment,
                                style: TextStyle(
                                  fontSize: 30,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 2
                                    ..color = Colors.grey[500]!,
                                )
                            ),
                            Text(comment,
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white
                                )
                            ),
                          ],
                        ),
                      )
                    ]),
                  ]),
            ),
            onBottom(AnimatedWave(
              height: 180,
              speed: 1.0,
            )),

            onBottom(AnimatedWave(
              height: 220,
              speed: 1.2,
              offset: pi / 2,
            )),
          ],
        ),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class SliderThumbImage extends SliderComponentShape {
  final ui.Image image;

  SliderThumbImage(this.image);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(0, 0);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required Size sizeWithOverflow,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double textScaleFactor,
      required double value}) {
    final canvas = context.canvas;
    final imageWidth = image.width;
    final imageHeight = image.height;

    Offset imageOffset = Offset(
      center.dx - (imageWidth / 2),
      center.dy - (imageHeight / 2),
    );

    Paint paint = Paint()..filterQuality = FilterQuality.high;

    canvas.drawImage(image, imageOffset, paint);
  }
}

onBottom(Widget child) => Positioned.fill(
  child: Align(
    alignment: Alignment.bottomCenter,
    child: child,
  ),
);

class AnimatedWave extends StatelessWidget {
  final double height;
  final double speed;
  final double offset;

  AnimatedWave({required this.height, required this.speed, this.offset = 0.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: height,
        width: constraints.biggest.width,
        child: LoopAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 2 * pi),
            duration: Duration(milliseconds: (5000 / speed).round()),
            builder: (context, value, child) {
              return CustomPaint(
                foregroundPainter: CurvePainter(value + offset),
              );
            }),
      );
    });
  }
}

class CurvePainter extends CustomPainter {
  final double value;

  CurvePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withAlpha(60);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
