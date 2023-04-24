import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alan_voice/alan_voice.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _hover = const MethodChannel('kikoba.co.tz/hover');
  String _ActionResponse = 'Waiting for Response...';
  Future<dynamic> sendMoney(var number, money) async {
    var sendMap = <String, dynamic>{
      'number': number,
      'money': money,
    };
// response waits for result from java code
    String? response = "";
    try {
      final String? result = await _hover.invokeMethod('sendMoney', sendMap);
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
    _ActionResponse = response!;
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
        // var str="185-51-671";
// var newStr = str.replace(/-/g, "");
        break;
      case "getmoney":
        money.text = command["text"];
        break;
      default:
        debugPrint("Unknown command");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fududeeye'),
        ),
        body: Center(
          child: Center(
              child: Form(
                  child: Container(
            child: Column(
              children: [
                Container(
                  // padding: EdgeInsets.all(10),
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                      "................................................... "),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: phone,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "reciever phone"),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: money,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'amount of money'),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        children: [
                          SizedBox(
                            child: ElevatedButton(
                                onPressed: () {
                                  sendMoney("${phone.text}", "${money.text}");
                                },
                                child: Text(
                                  'Send',
                                  style: TextStyle(fontSize: 20),
                                )),
                          ),
                          // Center(
                          //   child: Text(_ActionResponse),
                          // )
                          // Text(_ActionResponse)
                        ],
                      )),
                ),
                Center(
                  child: Text(_ActionResponse),
                )
              ],
            ),
          ))),
        ),
      ),
    );
  }
}
