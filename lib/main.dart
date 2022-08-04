import 'package:fingerprint_app/correct_note_side.dart';
import 'package:fingerprint_app/login_page.dart';
import 'package:fingerprint_app/note.dart';
import 'package:fingerprint_app/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
//https://pub.dev/packages/flutter_secure_storage
//https://www.youtube.com/watch?v=2uResVLUCNI
//https://stackoverflow.com/questions/60840704/what-is-flutter-secure-storage-exactly-and-how-it-works
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter LocalAuth'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SecureStorage secureStorage = SecureStorage();
  @override
  // ignore: must_call_super
  void initState(){
    secureStorage.readSecureData('password');
  }
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<void> _authorizeNow() async{
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(localizedReason: "Please authenticate yourself",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e){
      print(e);
    }

    if (!mounted) return;

    setState((){
      if(isAuthorized){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("WELCOME"),
              duration: const Duration(milliseconds: 1000),
            ));
        Navigator.push(context, MaterialPageRoute(builder: (context) => Note2()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("INCORRECT FINGER"),
          duration: const Duration(milliseconds: 1000),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("WELCOME",
              style: TextStyle(height: 5, fontSize: 30),),
            Container(height: 10,),
            Text("Authorized yourself"),
            Container(height: 15.0,),
            RaisedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()))
              , icon: Icon(Icons.lock_open, size: 20, color: Colors.white),
              label: Text("    LOG IN     "), color: Colors.greenAccent,
              colorBrightness: Brightness.dark,
            ),
            Container(height: 15.0,),
            RaisedButton.icon(onPressed: _authorizeNow, icon: Icon(Icons.fingerprint_rounded, size: 20, color: Colors.white),
              label: Text("AUTHORIZE"), color: Colors.greenAccent,
              colorBrightness: Brightness.dark,
              )
          ],
        ),
      ),
    );
  }
}

