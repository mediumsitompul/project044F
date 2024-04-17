import 'package:flutter/material.dart';
import 'signup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:convert/convert.dart';
import 'dart:async';
import 'package:crypto/crypto.dart' as crypto;
import 'menu_list_after_login.dart';
import 'login_failed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'password_reset.dart';
import 'server.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  TextEditingController username_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  bool _isObscure = true;

  Future<void> _login() async {
    //var url = Uri.parse("http://mediumsitompul.com/basicmobile/login1.php");
    var url = Uri.parse("$server/login1.php");

    var response = await http.post(url, body: {
      "username": username_controller.text,
      "password": generateMd5(generateMd5encode64(password_controller.text)),
      "flagging": generateMd5(generateMd5encode64(flagging)), //from server
    });

    var returnResult = jsonDecode(response.body);
    //....................................................
    if (returnResult != 'failed') {
      print(flagging);

      print(generateMd5(generateMd5encode64(flagging)));

      print("returnResult ++++++ ");
      print(returnResult);

      late SharedPreferences pref;
      pref = await SharedPreferences.getInstance();

      //............................................
      //GET data for name_pref, username_pref to pref
      var name_pref = (returnResult[0]["name"]);
      var username_pref = (returnResult[0]["username"]);

      //...........................................
      //WRITE data name_pref, username_pref to pref
      await pref.setString('name_pref_', name_pref);
      await pref.setString('username_pref_', username_pref);

      //.............................................
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const MenuListAfterLogin(),
      ));

      //....................................................
    } else if (returnResult == 'failed') {
      print("go to failed page");
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginFailed(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(250, 50, 50, 250),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'LOGIN',
        ),
      ),

      drawer: Drawer(
        child: ListView(
          //padding: EdgeInsets.zero,
          children: [
            //.......................................
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                '\nMenu before login',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            //.......................................
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text('Home'),
              onTap: () {
                //Navigator.pop(context);
                print("Home pressed...");
                if (!mounted) return;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyApp(),
                ));
              },
            ),
            //.......................................
            ListTile(
              leading: const Icon(
                Icons.app_registration,
              ),
              title: const Text('Signup'),
              onTap: () {
                print("Signup pressed...");

                print("Home pressed...");
                if (!mounted) return;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Signup(),
                ));
              },
            ),

            //.......................................
            ListTile(
              leading: const Icon(
                Icons.reset_tv,
              ),
              title: const Text('Password Reset'),
              onTap: () {
                print("Password Reset Pressed...");

                //Navigator.pop(context);
                print("Password Reset pressed...");
                if (!mounted) return;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PasswordReset(),
                ));
              },
            ),
            //.......................................
          ],
        ),
      ),
      //.............................................

      body: Center(
        child: Column(
          children: [
            const Expanded(
              child: Image(
                image: AssetImage('assets/images/medium.jpg'),
                width: 180,
                height: 180,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: username_controller,
                keyboardType: TextInputType.number,
                obscureText: false,
                maxLength: 16,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Username'),
              ),
            ),

            // //........................................
            Container(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: TextField(
                  maxLength: 32,
                  controller: password_controller,
                  //obscureText: !_isObscure,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                          icon: Icon(
                              //_isObscure ? Icons.visibility : Icons.visibility_off),
                              !_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          })),
                ),
              ),
            ),
            // //........................................

            const SizedBox(
              height: 5,
            ),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white),
                onPressed: () {
                  _login();
                  //print("tombol dipencet++++");
                },
                child: Text("L O G I N")),

            const Text("version.f001.1.0", style: TextStyle(color: Colors.blue), )
          ],
        ),
      ),
    );
  }

  //.......................................
}

generateMd5(String data) {
  var content = const Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}

generateMd5encode64(String data) {
  var content = const Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);
  var _digest = hex.encode(digest.bytes);
  var encode64 = base64.encode(utf8.encode(_digest));
  return encode64;
}
