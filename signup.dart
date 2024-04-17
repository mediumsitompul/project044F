import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signup_failed.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:convert/convert.dart'; //For convert ... hex encode
import 'package:crypto/crypto.dart' as crypto; //For ... crypto.md5
import 'signup_success.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'server.dart';

class Signup extends StatelessWidget {
  const Signup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(250, 50, 50, 250),
          foregroundColor: Colors.white,
          title: const Center(child: Text('         SIGNUP\n( REGISTRATION )')),
        ),
        body: const SearchMyResult(),
      ),
    );
  }
}

class SearchMyResult extends StatefulWidget {
  const SearchMyResult({
    super.key,
  });

  @override
  State<SearchMyResult> createState() => _SearchMyResultState();
}

class _SearchMyResultState extends State<SearchMyResult> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool autovalidate = false;

//zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz

  Future<void> _signup() async {
    final url = Uri.parse(
      //'https://mediumsitompul.com/basicmobile/signup1.php',
      '$server/signup1.php',
    );
    var response123 = await http.post(url, body: {
      "username": usernameController.text,
      "password": generateMd5(generateMd5encode64(passwordController.text)),
      "name": nameController.text,
      "birthday": birthdayController.text,
      "email": emailController.text,
      "flagging": generateMd5(generateMd5encode64(flagging)), //from server
    });

    final result1 = jsonDecode(response123.body);
    print(result1);

    if (result1.toString() == 'success') {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignupSuccess()),
        );
      }); //setState
    } else if (result1.toString() == 'username_exist') {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignupFailed()),
        );
      }); //setState
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Image(
            image: AssetImage('assets/images/register1.png'),
            width: 220,
            height: 220,
          ),

          //...................................................................

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: usernameController,
              keyboardType: TextInputType.number,
              obscureText: false,
              maxLength: 16,
              decoration: const InputDecoration(
                filled: true,
                //fillColor: Colors.blueGrey,
                //border: OutlineInputBorder(),
                labelText: 'Username/Phone',
                //labelStyle: TextStyle(color: Colors.red),
              ),
            ),
          ),

          //.....................................................................

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              //keyboardType: TextInputType.number,
              obscureText: false,
              maxLength: 32,
              decoration: const InputDecoration(
                filled: true,
                //fillColor: Colors.blueGrey,
                //border: OutlineInputBorder(),
                labelText: 'Password',
                //labelStyle: TextStyle(color: Colors.red),
              ),
            ),
          ),
          //.....................................................................

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              //keyboardType: TextInputType.number,
              obscureText: false,
              maxLength: 25,
              decoration: const InputDecoration(
                filled: true,
                //fillColor: Colors.blueGrey,
                //border: OutlineInputBorder(),
                labelText: 'Name',
                //labelStyle: TextStyle(color: Colors.red),
              ),
            ),
          ),

          //.....................................................................

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              //keyboardType: TextInputType.number,
              obscureText: false,
              maxLength: 32,
              decoration: const InputDecoration(
                filled: true,
                //fillColor: Colors.blueGrey,
                //border: OutlineInputBorder(),
                labelText: 'Email',
                //labelStyle: TextStyle(color: Colors.red),
              ),
            ),
          ),

          //.....................................................................
          Container(
              padding: const EdgeInsets.all(5),
              height: MediaQuery.of(context).size.width / 3,
              child: Center(
                  child: TextField(
                controller: birthdayController,
                //editing controller of this TextField
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Birthday" //label text of field
                    ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      birthdayController.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {}
                },
              ))),

          //......................................... VALIDATION INCLUDE ......................
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(100, 2, 100, 2),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white),
                onPressed: () {
                  if (usernameController.value.text.isEmpty) {
                    showToastMessage("Please enter your username/HP.... !!!");
                  } else if (passwordController.value.text.isEmpty) {
                    showToastMessage("Please enter your password....!!!");
                  } else if (nameController.value.text.isEmpty) {
                    showToastMessage("Please enter your name....!!!");
                  } else if (emailController.value.text.isEmpty) {
                    showToastMessage("Please enter your email....!!!");
                  } else if (birthdayController.value.text.isEmpty) {
                    showToastMessage("Please enter your birthday....!!!");
                  } else
                    _signup();
                },
                child: const Text(' E N T E R')),
          )
        ],
      ),
      //  ),

      //................... floatingActionButton >>> IN SCAFFOLD() ................
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          print('Tombol Reffresh di pencettt');

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyApp(),
              ));
        }),
        tooltip: 'Reload data',
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        child: const Icon(Icons.ac_unit),
      ),
      //...........................................................................
    );
  }
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

//No Build Context
//showToastMessage("Show Toast Message on Flutter");
void showToastMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      textColor: Colors.white,
      fontSize: 16.0);
}
