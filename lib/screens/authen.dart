import 'package:Project/screens/myService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  // Explcit
  double amount = 150.0;
  double size = 250.0;
  String emailString, passwordString;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool checkSpace(String value) {
    // check space input from email and password
    bool result = false;
    if (value.length == 0) {
      result = true;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: Container(
        alignment: Alignment(0, -1),
        padding: EdgeInsets.only(top: 80.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              showLogo(),
              showName(),
              emailTextFormFeild(),
              passwordText(),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                alignment: Alignment.center,
                width: size,
                child: Row(
                  children: <Widget>[
                    signInButton(context),
                    signUpButton(context),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: amount,
      height: amount,
      child: Image.asset(
        'images/logoicon.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget showName() {
    return Container(
      child: Text(
        'Bright Brain',
        style: TextStyle(
          fontSize: 40.0,
          color: Colors.orange[800],
          fontWeight: FontWeight.bold,
          fontFamily: 'Baloo',
        ),
      ),
    );
  }

  Widget emailTextFormFeild() {
    return Container(
      width: size,
      child: TextFormField(
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'Baloo',
        ),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(
            Icons.email,
            size: 40.0,
            color: Colors.yellow[800],
          ),
          labelText: 'User :',
          labelStyle: TextStyle(
            fontSize: 18.0,
            color: Colors.yellow[800],
          ),
          hintText: 'logicoip@mail.com',
          hintStyle: TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
        validator: (String value) {
          if (checkSpace(value)) {
            return 'Please Type Email';
          }
        },
        onSaved: (String value) {
          emailString = value;
        },
      ),
    );
  }

  Widget passwordText() {
    return Container(
      width: size,
      child: TextFormField(
        obscureText: true,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'Baloo',
        ),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            size: 40.0,
            color: Colors.yellow[800],
          ),
          labelText: 'Password :',
          labelStyle: TextStyle(
            fontSize: 18.0,
            color: Colors.yellow[800],
          ),
          hintText: 'More than 8 Charactor',
          hintStyle: TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
        validator: (String value) {
          if (checkSpace(value)) {
            return 'Password Empty';
          }
        },
        onSaved: (String value) {
          passwordString = value;
        },
      ),
    );
  }

  void checkAuthen(BuildContext context) async {
    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailString,
      password: passwordString,
    )
        .then((objValue) {
      moveToMyService(context);
    }).catchError((objValue) {
      String error = objValue.message;
      print('error => $error');
    });
  }

  void moveToMyService(BuildContext context) {
    var myServiceRoute =
        MaterialPageRoute(builder: (BuildContext context) => MyService());
    Navigator.of(context)
        .pushAndRemoveUntil(myServiceRoute, (Route<dynamic> route) => false);
  }

  Widget signInButton(BuildContext context) {
    return Expanded(
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.yellow[800],
        child: Text(
          'Sign In',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Baloo',
          ),
        ),
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            checkAuthen(context);
          }
        },
      ),
    );
  }

  Widget signUpButton(BuildContext context) {
    return Expanded(
      child: OutlineButton(
        borderSide: BorderSide(color: Colors.yellow[800]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.yellow[800],
            fontWeight: FontWeight.bold,
            fontFamily: 'Baloo',
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}
