import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'home.dart';

class AddButton extends StatefulWidget {
  @override
  _WiFiscanstate createState() => _WiFiscanstate();
}

class _WiFiscanstate extends State<AddButton> {
  final auth = FirebaseAuth.instance;
  // ignore: non_constant_identifier_names
  final DBref = FirebaseDatabase.instance.reference();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  // ignore: unused_field
  String a = 'hi', b = 'hi', c = 'null', d = 'null';
  final spinkit = SpinKitFadingCircle(
    color: Colors.blue,
    size: 50.0,
  );
  bool _is = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Container(
        child: ListTile(
          leading: Icon(Icons.home),
          title: Text(
            'Setting',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
            ),
          ),
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
      )),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Check update" + "\n", style: TextStyle(fontSize: 25)),
            // ignore: deprecated_member_use
            Container(
              // ignore: deprecated_member_use
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "LastCheck: " +
                          "$a" +
                          "\n" +
                          "\n" +
                          "Status: " +
                          "$b" +
                          "\n" +
                          "\n" +
                          "WiFi: " +
                          "$c" +
                          "\n" +
                          "\n" +
                          "Version: " +
                          "$d" +
                          "\n" +
                          "\n",
                      style: TextStyle(fontSize: 20)),
                  // ignore: deprecated_member_use
                  RaisedButton(
                      child: _is ? spinkit : Text("check"),
                      onPressed: () {
                        DBref.child("xxxx")
                            .child("CheckUpdate")
                            .once()
                            .then((DataSnapshot data) {
                          setState(() {
                            a = data.value["LastCheck"];
                            b = data.value["Status"];
                          });
                        });
                        DBref.child("xxxx").once().then((DataSnapshot data) {
                          setState(() {
                            d = data.value["Version"];
                            c = data.value["Wifi"];
                          });
                        });
                        _showScaffold("Checked");
                      }),
                ],
              ),
            ),

            // ignore: deprecated_member_use
            RaisedButton(
              child: Text("Update"),
              onPressed: () {
                setState(() {
                  _is = true;
                  _showScaffold("Updating");
                });
              },
            ),
          ],
        ),
      ),
    ));
  }
}
