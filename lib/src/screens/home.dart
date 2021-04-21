import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_app/src/screens/Add.dart';
import 'package:login_app/src/screens/update.dart';

import 'Setting.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String c = 'hi', b = 'hi', e = 'Welcome';
  DataSnapshot f;
  // ignore: non_constant_identifier_names

  final auth = FirebaseAuth.instance;

  Future<void> _aa() {
    DBref.child("xxxx").once().then((DataSnapshot data) {
      setState(() {
        String d = data.value["Name"].toString();
      });
    });
  }

  // ignore: non_constant_identifier_names
  final DBref = FirebaseDatabase.instance.reference();
  var a = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Home Control"),
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
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                      child: Text(
                        e,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Image(
                      image: NetworkImage(
                          'https://cryptodailycdn.ams3.cdn.digitaloceanspaces.com/doge-meme.jpg'),
                      width: 200,
                      height: 80,
                    ),
                  ]),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Setting'),
                  onTap: () {
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WiFiScan()));
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Add Button'),
                  onTap: () {
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TabsApp()));
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.update),
                  title: Text('Update'),
                  onTap: () {
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddButton()));
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.accessible_sharp),
                  title: Text('Sign out'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: FirebaseAnimatedList(
                        query: DBref.child("xxxx").child("data").child("Ir"),
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index) {
                          return SizeTransition(
                            sizeFactor: animation,
                            child: ListTile(
                              trailing: IconButton(
                                onPressed: () {
                                  DBref.child("xxxx")
                                      .child("Ir")
                                      .child("Status")
                                      .set(
                                    {
                                      "CommandAvailable": "TRUE",
                                      "isReceived": "FALSE",
                                      "isSend": "TRUE",
                                    },
                                  ).asStream();
                                  DBref.child("xxxx")
                                      .child("data")
                                      .child("Ir")
                                      .child(snapshot.key)
                                      .once()
                                      .then((DataSnapshot data) {
                                    setState(() {
                                      DBref.child("xxxx")
                                          .child("Ir")
                                          .child("Send")
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
                                icon: const Icon(Icons.trip_origin),
                              ),
                              title: Text(
                                "Button IR" + ' $index',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: FirebaseAnimatedList(
                        query: DBref.child("xxxx").child("data").child("Rf"),
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index) {
                          return SizeTransition(
                            sizeFactor: animation,
                            child: SwitchListTile(
                                title: Text(
                                  "Button RF" + ' $index',
                                  style: TextStyle(fontStyle: FontStyle.normal),
                                ),
                                onChanged: (bool value) {
                                  setState(() {
                                    a[index] = value;
                                    if (value) {
                                      DBref.child("xxxx")
                                          .child("Ir")
                                          .child("Status")
                                          .set(
                                        {
                                          "CommandAvailable": "FALSE",
                                          "isReceived": "FALSE",
                                          "isSend": "FALSE",
                                        },
                                      ).asStream();
                                      DBref.child("xxxx")
                                          .child("data")
                                          .child("Rf")
                                          .child(snapshot.key)
                                          .once()
                                          .then((DataSnapshot data) {
                                        setState(() {
                                          DBref.child("xxxx").child("RF").set(
                                            {
                                              "Code": data.value["Code"],
                                              "CommandAvailable": data
                                                  .value["CommandAvailable"],
                                              "Send": data.value["Send"]
                                            },
                                          ).asStream();
                                        });
                                      });
                                    } else {
                                      DBref.child("xxxx")
                                          .child("data")
                                          .child("Rf")
                                          .child(snapshot.key)
                                          .once()
                                          .then((DataSnapshot data) {
                                        setState(() {
                                          DBref.child("xxxx").child("RF").set(
                                            {
                                              "Code": (data.value["Code"] + 1)
                                                  as int,
                                              "CommandAvailable": data
                                                  .value["CommandAvailable"],
                                              "Send": data.value["Send"]
                                            },
                                          ).asStream();
                                        });
                                      });
                                    }
                                  });
                                },
                                value: a[index],
                                secondary: Icon(a[index]
                                    ? Icons.lightbulb
                                    : Icons.lightbulb_outline)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            tooltip: 'Increment',
            child: Icon(Icons.voice_chat),
          ),
        ));
  }

  // ignore: non_constant_identifier_names

}
