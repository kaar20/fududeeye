import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterTts ft = FlutterTts();
  static const _hover = const MethodChannel('kikoba.co.tz/hover');
  String _ActionResponse = 'Waiting for Response...';
  // String _ActionRe
  // String _ActionResponse = 'sucess';
  Future<dynamic> sendMoney(var number, money) async {
    var sendMap = <String, dynamic>{
      'number': number,
      'money': money,
    };
// response waits for result from java code
    String? response = "";
    String me = "";
    try {
      final String? result = await _hover.invokeMethod('sendMoney', sendMap);
      response = result;
      me = "You have correctly sent $money\$ to the number ${phone.text}. ";
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
      me = "Failed Transaction";
    }
    _ActionResponse = me;
    setState(() {
      // _ActionResponse = me!;
      // _ActionResponse = me;
      // // print(me)
      // _ActionResponse = response!;

      // if(response!)
    });
  }

  final phone = TextEditingController();
  final money = TextEditingController();
  _MyAppState() {
    /// Init Alan Button with project key from Alan AI Studio
    AlanVoice.addButton(
        "2b172d1f7ceac790e81370f42a1fd1cb2e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    /// Handle commands from Alan AI Studio
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }
  void _handleCommand(Map<String, dynamic> command) {
    switch (command["command"]) {
      case "getphone":
        phone.text = command["text"].toString().replaceAll("-", "");
        break;
      case "getmoney":
        money.text = command["text"];
        break;
      case "forward":
        sendMoney("${phone.text}", "${money.text}");
        break;
      case "lastaction":
        speak(_ActionResponse);
        break;
      default:
        debugPrint("Unknown command");
    }
  }

  speak(String text) async {
    await ft.setLanguage("en-US");
    await ft.setPitch(1);
    await ft.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   title: const Text('Fududeeye'),
        // ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10),
                  // child: Image(image: AssetImage('images/img.png')),
                  child: Image.asset(
                    // "images/img.png",
                    "images/logo.jpeg",
                    // width: 200,
                    // height: 210,

                    // fit: BoxFit.fitHeight,
                    // fit: BoxFit.fitWidth,

                    scale: 2,
                  ),
                ),
                Form(
                    child: Container(
                  // padding: EdgeInsets.only(),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            bottom: 20, left: 20, right: 20, top: 10),
                        child: TextFormField(
                          controller: phone,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0)),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 21),
                              filled: true,
                              fillColor: Color(0xffEBEBEB),
                              // fillColor: Color(0xffD9D9D9),
                              hintText: 'Number Loo Diraha ',
                              hintStyle: TextStyle(
                                  // color: Color(0xff3F3C3C),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      // SizedBox(
                      //   height: 3,
                      // ),
                      Container(
                        // padding: EdgeInsets.all(20),
                        padding: EdgeInsets.only(
                            bottom: 20, left: 20, right: 20, top: 10),
                        child: TextFormField(
                          controller: money,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0)),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 21),
                              filled: true,
                              fillColor: Color(0xffEBEBEB),
                              // fillColor: Color(0xffD9D9D9),
                              hintText: 'Cadad-ka lacagta',
                              hintStyle: TextStyle(
                                  // color: Color(0xff3F3C3C),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600)),
                          // decoration: InputDecoration(
                          //     border: OutlineInputBorder(),
                          //     labelText: 'amount of money'),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.infinity,
                          // width: 10,
                          height: 55,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff5717E2),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(52), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                sendMoney("${phone.text}", "${money.text}");
                              },
                              child: Text(
                                'Send',
                                style:
                                    TextStyle(fontSize: 23, letterSpacing: 2),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            _ActionResponse,
                            style: TextStyle(fontSize: 16, letterSpacing: 1),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
