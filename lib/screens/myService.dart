import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_web/flutter_native_web.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  Map<dynamic, dynamic> iotmap;
  int fanInt;
  String fanString = 'Stop Fan';
  String temp_inside = 'https://thingspeak.com/channels/1150911/widgets/218038';
  WebController webController;
  String nameLogin = "", uidString;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void onWebCreateTempInside(webController) {
    this.webController = webController;
    this.webController.loadUrl(temp_inside);
    this.webController.onPageStarted.listen((url) => print('Loading $url'));
    this
        .webController
        .onPageFinished
        .listen((url) => print('Finished Loading $url'));
  }

  @override
  void initState() {
    super.initState();
  }

  void getValueFromFirebase() async {
    DatabaseReference databaseReference =
        await firebaseDatabase.reference().once().then((objValue) {
      iotmap = objValue.value;
      setState(() {
        fanInt = iotmap['Fan'];
        print('fan = $fanInt');
      });
    });
  }

  void editFirebase(String nodeString, int value) async {
    print('node ==> $nodeString');
    iotmap['$nodeString'] = value;
    await firebaseDatabase.reference().set(iotmap).then((objValue) {
      print('$nodeString Success');
      getValueFromFirebase();
    }).catchError((objValue) {
      String error = objValue.message;
      print('error ==> $error');
    });
  }

  Widget button() {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      alignment: Alignment.center,
      child: RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text(fanString),
          onPressed: () {
            if (fanInt == 1) {
              fanString = 'Stop fan';
              editFirebase('Fan', 0);
            } else {
              fanString = 'Open fan';
              editFirebase('Fan', 1);
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeWeb flutterNativeWebTempInside = new FlutterNativeWeb(
      onWebCreated: onWebCreateTempInside,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        Factory<OneSequenceGestureRecognizer>(
          () => TapGestureRecognizer(),
        ),
      ].toSet(),
    );
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
                center: Alignment(0, -1),
                colors: [
                  Colors.blue,
                  Colors.blue[300],
                ],
                radius: 1.5),
          ),
          child: ListView(
            children: [
              Column(
                children: [
                  button(),
                  Container(
                    padding: EdgeInsets.only(
                      top: 30.0,
                      right: 10.0,
                      left: 10.0,
                    ),
                    child: flutterNativeWebTempInside,
                    height: 300.0,
                    width: 500.0,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
