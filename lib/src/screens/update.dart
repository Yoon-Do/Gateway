import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'Dart:math';
import 'home.dart';

class TabsApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Control demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var rng = new Random();
  final auth = FirebaseAuth.instance;
  String vkl = "hi";
  var _add;
  String a = "hi", b = "hi", c = "hi", d = "hi", e = "hi";

  // ignore: non_constant_identifier_names
  final DDBref = FirebaseDatabase.instance.reference();
  var liststare = [false];
  final spinkit = SpinKitFadingCircle(
    color: Colors.blue,
    size: 50.0,
  );
  bool _is = false;

  void _incrementCounter() {
    setState(() {
      _is = true;
      DDBref.child("xxxx")
          .child("Ir")
          .child("Get")
          .once()
          .then((DataSnapshot data) {
        setState(() {
          if (data.value["bitnum"] != "null" &&
              data.value["code"] != "null" &&
              data.value["rawbuf"] != "null" &&
              data.value["rawlen"] != "null" &&
              data.value["type"] != "null") {
            _is = false;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            child: ListTile(
              leading: Icon(Icons.home),
              title: Text(
                'Add Button',
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
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'IR',
              ),
              Tab(
                text: 'RF',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Text("IR", style: TextStyle(fontSize: 25)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Get Ir", style: TextStyle(fontSize: 25)),
                      Container(

                          // ignore: deprecated_member_use
                          child: Text(vkl)),
                      // ignore: deprecated_member_use
                      RaisedButton(
                          child: _is ? spinkit : Text("Received"),
                          onPressed: () {
                            DDBref.child("xxxx")
                                .child("Ir")
                                .child("Status")
                                .set({
                              "CommandAvailable": "TRUE",
                              "isReceived": "TRUE",
                              "isSend": "FALSE"
                            });
                            _incrementCounter();
                          })
                    ],
                  ),
                  // ignore: deprecated_member_use
                  RaisedButton(
                    child: Text("PUSH"),
                    onPressed: () {
                      DDBref.child("xxxx")
                          .child("Ir")
                          .child("Get")
                          .once()
                          .then((DataSnapshot data) {
                        setState(() {
                          DDBref.child("xxxx")
                              .child("data")
                              .child("Ir")
                              .push()
                              .set(
                            {
                              "bitnum": data.value["bitnum"],
                              "code": data.value["code"],
                              "type": data.value["type"]
                            },
                          ).asStream();
                        });
                      });
                    },

                    // ignore: deprecated_member_use
                  ),
                  Flexible(
                    child: FirebaseAnimatedList(
                      query: DDBref.child("xxxx").child("Ir").child("Get"),
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        return SizeTransition(
                          sizeFactor: animation,
                          child: ListTile(
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  DDBref.child("xxxx")
                                      .child("Ir")
                                      .child("Get")
                                      .set(
                                    {
                                      "bitnum": "null",
                                      "code": "null",
                                      "rawbuf": "null",
                                      "rawlen": "null",
                                      "type": "null"
                                    },
                                  ).asStream();
                                });
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            title: Text('${snapshot.value.toString()}'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Text("RF", style: TextStyle(fontSize: 25)),

                  // ignore: deprecated_member_use
                  RaisedButton(
                    child: Text("Push"),
                    onPressed: () {
                      setState(() {
                        for (var i = 0; i < 1000; i++) {
                          _add = rng.nextInt(10000000);
                        }
                      });

                      DDBref.child("xxxx").child("data").child("Rf").push().set(
                        {
                          "Code": _add as int,
                          "CommandAvailable": "TRUE",
                          "Send": 1
                        },
                      ).asStream();
                    },
                  ),
                  Flexible(
                    child: FirebaseAnimatedList(
                      query: DDBref.child("xxxx").child("data").child("Rf"),
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        return SizeTransition(
                          sizeFactor: animation,
                          child: ListTile(
                            trailing: IconButton(
                              onPressed: () => DDBref.child("xxxx")
                                  .child("data")
                                  .child("Rf")
                                  .child(snapshot.key)
                                  .remove(),
                              icon: const Icon(Icons.delete),
                            ),
                            title: Text('${snapshot.value.toString()}'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
