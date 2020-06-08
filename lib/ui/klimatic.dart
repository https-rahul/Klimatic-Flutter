import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../util/utils.dart' as util;
import 'dart:async';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => new _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _cityEntered;
  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new changeCity();
    }));

    if (results != null && results.containsKey('enter')) {
      _cityEntered = results['enter'];
//      print(results['enter'].toString());
    }
  }

  void showStuff() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Weather app'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {
                    _goToNextScreen(context);
              })
        ],
      ),
      body: new ListView(children: <Widget>[
//        new Center(
//            child: new Image.asset(
////              'images/umbrella.png',
//              '',
//          width: 490.0,
//          height: 1200.0,
//          fit: BoxFit.fill,
//        )),

        //city name display container
        new Container(
          alignment: Alignment.center,
//          margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: new Text(
            '${_cityEntered == null ? util.defaultCity : _cityEntered}',
            style: cityStyle(),
          ),
        ),

//light rain icon

//        new Container(
//            alignment: Alignment.center,
//            child: new Image.asset('images/light_rain.png')),

        //container data display
//        new Container(
//          alignment: Alignment.center,)
//          margin: const EdgeInsets.fromLTRB(160.0, 200.0, 0.0, 0.0),
          updateTempWidget(_cityEntered)

      ],),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=metric';

    http.Response response = await http.get(apiUrl);
    return jsonDecode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future: getWeather(util.appId, city == null ? util.defaultCity : city),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
//              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(150.0, 0.0, 0.0, 0.0),
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(
                      content['main']['temp'].toString() +" °C",
                      style: tempStyle(),
                    ),
                    subtitle: new ListTile(
                      title: new Text(
                          "Humidity: ${content['main']['humidity'].toString() }\n"
                              "Min: ${content['main']['temp_min'].toString() +" °C"}\n"
                              "Max: ${content['main']['temp_max'].toString() +" °C"}"

                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return new Container();
          }
        });
  }
}

class changeCity extends StatelessWidget {

  var _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.red,
          title: new Text('Change City'),
          centerTitle: true,
        ),
        body: new Stack(children: <Widget>[
          new Center(
            child: new Image.asset(
              '',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter city',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'enter': _cityFieldController.text
                      });
                    },
                    textColor: Colors.white,
                    color: Colors.red,
                    child: new Text('Get')),
              )
            ],
          ),

        ]));
  }
}

//style object for city name header
TextStyle cityStyle() {
  return new TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
}

//style object for temperature
TextStyle tempStyle() {
  return new TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
}