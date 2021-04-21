import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';
import 'package:url_launcher/url_launcher.dart';

class WiFiScan extends StatefulWidget {
  @override
  _WiFiscanstate createState() => _WiFiscanstate();
}

class _WiFiscanstate extends State<WiFiScan> {
  void openURL() async {
    if (await canLaunch("http://192.168.4.1")) {
      await launch("http://192.168.4.1");
    } else
      throw "Could not launch WiFi Config";
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Setting'),
          ),
          body: Container(
            child: Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 200,
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Text("Config WiFi",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.blue)),
                              ),
                              Icon(Icons.settings)
                            ]),
                        onPressed: openURL,
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 200,
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Text("WiFi Scan",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.blue)),
                              ),
                              Icon(Icons.network_wifi)
                            ]),
                        onPressed: () {
                          OpenSettings.openWIFISetting();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.sentiment_satisfied_sharp),
              onPressed: () async {
                OpenSettings.openWIFISetting();
              })),
    );
  }
}
