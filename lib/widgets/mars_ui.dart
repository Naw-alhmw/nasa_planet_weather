import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as nawal;

class PlanetMars extends StatefulWidget {
  @override
  _PlanetMarsState createState() => _PlanetMarsState();
}

class _PlanetMarsState extends State<PlanetMars> {
  Widget listItem(String sol, int min, int max) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "Sol $sol",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "GoogleSansRegular",
                    fontSize: 15.0),
              ),
            ),
            SizedBox(width: 120.0),
            Expanded(
              child: Text(
                "High $max C",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "GoogleSansRegular",
                  fontSize: 15.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: Text(
                "Today ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontFamily: "GoogleSansRegular",
                    fontWeight: FontWeight.w100),
              ),
            ),
            SizedBox(width: 120.0),
            Expanded(
              child: Text(
                "Low: $min C",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontFamily: "GoogleSansRegular",
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Container(
          height: 3.0,
          width: double.infinity,
          color: Colors.white,
        ),
      ],
    );
  }

  /*from the official website you can generate your 
  own API key or in case you want to publish it 
  publicly then take the presented demo key
  which I did here
  */
  String url =
      "https://api.nasa.gov/insight_weather/?api_key=DEMO_KEY&feedtype=json&ver=1.0";

  var sol_key;
  var data;
  List weatherData = [];

  Future<String> getData() async {
    nawal.Response response = await nawal
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      data = json.decode(response.body);
      print(data);
      sol_key = data["sol_keys"];
      sol_key = sol_key.reversed.toList();
      for (int i = 0; i < sol_key.length; i++) {
        weatherData.add(data[sol_key[i]]["AT"]);
      }
      print(weatherData);
    });
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/astro.jpg"),
            fit: BoxFit.fitHeight,
            alignment: Alignment.center,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 30, bottom: 15, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Latest Weather\nat Elysium Planitia",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'GoogleSansRegular',
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "InSight is taking daily weather measurements (temperature, wind, pressure) on the surface of Mars at Elysiom Planitia, a flat, smooth plain near Mars' equator.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'GoogleSansMedium',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Sol ${sol_key[0]}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GoogleSansRegular',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "High: ${(weatherData[0]["mx"]).ceil()}C",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'GoogleSansRegular',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Today",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GoogleSansRegular',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Low: ${(weatherData[0]["mn"]).ceil()}C",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'GoogleSansRegular',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60.0,
              ),
              Text(
                "Previous Days",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontFamily: "GoogleSansRegular",
                  fontSize: 18.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sol_key.length,
                  itemBuilder: (BuildContext, int index) {
                    return listItem(
                        sol_key[index],
                        (weatherData[index]["mn"]).ceil(),
                        (weatherData[index]["mx"]).ceil());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
