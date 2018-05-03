import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterdemoapp/listview/my_listView_with_api.dart';
import 'package:flutterdemoapp/widget/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutterdemoapp/listview/my_listView.dart';
import 'package:async_loader/async_loader.dart';

// https://github.com/brianegan/flutter_architecture_samples/tree/master/example/vanilla
// https://github.com/Solido/awesome-flutter


// app will start from main
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new SplashScreen(),
    );
  }
}

// https://stackoverflow.com/questions/45936084/what-difference-between-stateless-and-stateful-widgets
/**
 * above url for stateless and state ful widget
 */
class SplashScreen extends StatefulWidget{

  @override
  _SplashScreenState createState() => new _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  CurvedAnimation _iconAnimation;

  void handleTimeout() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new MyHomePage(title: 'Flutter Demo')));
  }

  startTimeout() async {
    var duration = const Duration(seconds: 4);
    return new Timer(duration, handleTimeout);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 4000));
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeIn);
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();

    startTimeout();
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: new Scaffold(
        body: new Center(
            child: new Image(
              image: new AssetImage("images/new_logo.png"),
              width: _iconAnimation.value * 300,
              height: _iconAnimation.value * 300,
            )
        ),
      ),
    );
  }
}

/**
 *  username password field screen
 */
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  TextEditingController _controlleremail=new TextEditingController();
  TextEditingController _controllerpassword=new TextEditingController();
  CircularProgressIndicator circularProgressIndicator;
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
  new GlobalKey<AsyncLoaderState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      /*appBar: new AppBar(
        title: new Text(widget.title),
      ),*/

      body: new Builder(
        builder: (BuildContext context) {
          return new Center(
            child: new Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Form(
                key: formKey,

                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    new Padding(
                      padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
                      child:  new Image(
                        image: new AssetImage("images/new_logo.png"),
                        width: 100.0,
                        height: 100.0,
                      ),
                    ),
                    new TextFormField(
                      maxLengthEnforced: false,
                      maxLines: 1,
                      controller: _controlleremail,
                      decoration: new InputDecoration(
                        //  hintText: 'User name',
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        _email=value;
                        if (value.isEmpty) {
                          return 'Please enter email';
                        }
                        if(!isEmailInvalid(value)){
                          return 'Please enter valid email';
                        }
                      },

                    ),

                    new TextFormField(
                      maxLengthEnforced: false,
                      maxLines: 1,
                      obscureText: true,   // it's like input type password
                      controller: _controllerpassword,
                      decoration: new InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        _password=value;
                        if (value.isEmpty) {
                          return 'Please enter password';
                        }
                      },
                    ),

                    /**
                     *  submit button press
                     */
                    new Padding(
                      padding: new EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),
                      child: new RaisedButton(
                        color:Colors.red,
                        elevation: 5.0,
                        shape:  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        onPressed: (){
                          _submit(context);
                        },
                        child: new Text('Submit / Call Login Api'),
                        textColor: Colors.white,
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),
                      child: new RaisedButton(
                        color:Colors.red,
                        elevation: 5.0,
                        shape:  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        onPressed: () {
                          fun_listview_with_api_screen(context);
                        },
                        child: new ListViewButton(), // can create common class for button property
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /**
   *  submit click
   */
  void _submit(BuildContext context) {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _performLogin(context);
    }
  }

  /**
   *  if all filed are validate then api call
   */
  void _performLogin(BuildContext context) {

    /* String dataURL = "https://api.github.com/orgs/raywenderlich/members";
    http.Response response = await http.get(dataURL);
    setState(() {
      _members = JSON.decode(response.body);
    });
    */

    var url = 'https://reqres.in/api/login';
    http.post(url, body: {'username': _email,'password':_password})
        .then((response) {
      var statusCode = response.statusCode;

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if(statusCode < 200 || statusCode >= 300 || response.body == null) {
        fun_snackbar(context,"Error while login");
      }else{
        _controlleremail.clear();
        _controllerpassword.clear();
        fun_listview_screen(context);
      }

    });
    // http.read("http://example.com/foobar.txt").then(print);
  }

  /**
   * validates email using regex
   */
  bool isEmailInvalid(String email) {
    RegExp exp = new RegExp(r"^[_A-Za-z0-9-+]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,})$");
    return exp.hasMatch(email);
  }

}


/**
 *  function for click on next screen (listview with api call)
 */
void fun_listview_with_api_screen(BuildContext context){
  Navigator.push(
    context,
    new MaterialPageRoute(builder: (context) => new MyLisViewWithApi()),
  );
}

/**
 *  function for static listview screen
 */
void fun_listview_screen(BuildContext context){
  Navigator.push(
    context,
    new MaterialPageRoute(builder: (context) => new MyListView()),
  );
}

/**
 *  for show message
 */
void fun_snackbar(BuildContext context,String message){
  final snackBar = new SnackBar(
      content: new Text(message)
  );
  Scaffold.of(context).showSnackBar(snackBar);

  // OR

  /*Scaffold.of(context).showSnackBar(new SnackBar(
    content: new Text('Hello!'),
  ));*/
}




