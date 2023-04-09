import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ThingSpeakPage extends StatefulWidget {
  const ThingSpeakPage({Key? key}) : super(key: key);

  @override
  _ThingSpeakPageState createState() => _ThingSpeakPageState();
}

class _ThingSpeakPageState extends State<ThingSpeakPage> {
  late DatabaseReference _databaseReference;
  String moisture = "0.0";
  num _pump1SwitchState = 0;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.reference().child('sensorData').child('moisture');
    _databaseReference.onValue.listen((event) {
      setState(() {
        moisture = event.snapshot.value != null ? event.snapshot.value.toString() : "0.0";
      });
    });
  }

  void _changePump1SwitchState(bool value) {
    setState(() {
      _pump1SwitchState = value ? 1 : 0;
    });
    _databaseReference
        .root
        .child('sensorData')
        .child('pump1')
        .set(_pump1SwitchState)
        .then((_) {
      print('Data sent successfully to /sensorData/pump1');
    }).catchError((error) {
      print('Failed to send data to /sensorData/pump1: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GyroSense'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1542bf),
              Color(0xff5c4b80),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                color: Color(0xffe7f0ff),
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(
                    children: [
                      Text(
                        'Moisture',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${moisture}',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              SwitchListTile(
                title: Text(
                  'Pump 1',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                value: _pump1SwitchState == 1,
                onChanged: _changePump1SwitchState,
                activeColor: Colors.green,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
