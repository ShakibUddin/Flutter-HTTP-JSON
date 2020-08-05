import 'package:flutter/material.dart';
import 'package:flutter_http_json/PODO.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(MaterialApp(
      title: 'Json Parsing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<User>> _getUsers() async {
    var data = await http.get("https://jsonplaceholder.typicode.com/users");
    var jsonData = convert.json.decode(data.body);
    List<User> users = [];
    for (var item in jsonData) {
      Map<String, dynamic> address = item['address'];
      Map<String, dynamic> geo = address['geo'];
      User user = User(
          id: item['id'],
          name: item['name'],
          username: item['username'],
          email: item['email'],
          phone: item['phone'],
          street: address['street'],
          lat: geo['lat'],
          lng: geo['lng']);
      users.add(user);
    }
    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('User'),
        ),
        body: Center(
          child: Container(
            child: FutureBuilder(
              future: _getUsers(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: Container(
                      child: Text("Loading..."),
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('ID: ' + snapshot.data[index].id.toString()),
                              Text('Name: ' + snapshot.data[index].name),
                              Text('User Name: ' +
                                  snapshot.data[index].username),
                              Text('Email: ' + snapshot.data[index].email),
                              Text('Phone: ' + snapshot.data[index].phone),
                              Text('Street: ' + snapshot.data[index].street),
                              Text('Latitude: ' + snapshot.data[index].lat),
                              Text('Longitude: ' + snapshot.data[index].lng),
                            ],
                          ),
                        );
                      });
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
