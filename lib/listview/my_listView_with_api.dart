import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyLisViewWithApi extends StatefulWidget {

  @override
  MyLisViewWithApiSample createState() => new MyLisViewWithApiSample();
}

class MyLisViewWithApiSample extends State<MyLisViewWithApi> {
  final String url="https://jsonplaceholder.typicode.com/users";
  List data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getJsonData();
  }

  /**
   * get data by calling api
   */
  Future<String> getJsonData() async{
    var response=await http.get(
      Uri.encodeFull(url),
      headers: {"Accept":"application/json"}
    );

    print(response.body);
    setState(() {
      var convertDataToJSon=JSON.decode(response.body);
      data=convertDataToJSon;
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ListView Example"),
      ),
      /**
       * here checking -> if data is null than loader will show
       */
      body: data !=null ? new ListView.builder(
       itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context,int index){
         return new Container(
           child: new Center(
             child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch ,
               children: <Widget>[
                new Card(
                    child: new ListTile(
                    title: new Text(data[index]['name']),
                    subtitle: new Text(data[index]['email']),
                  )
                )
               ],
             ),
           ),
         );
        },
      ) : new Center(child:new CircularProgressIndicator(
        strokeWidth: 3.0,
      )),
    );
  }
}


