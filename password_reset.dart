import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto; //For ... crypto.md5
import 'package:convert/convert.dart'; //For convert ... hex encode
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'password_reset_success.dart';
import 'password_reset_failed.dart';
import 'menu_list_after_login.dart';
import 'server.dart';

class PasswordReset extends StatelessWidget {
  const PasswordReset({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'Flutter Demo',
      home: MyHomePage(title: '               PASSWORD RESET'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isObscure = true;

  TextEditingController username_Controller = TextEditingController();
  TextEditingController birthday_Controller = TextEditingController();
  TextEditingController password1_Controller = TextEditingController();

  Future<void> _passwordReset() async {
    final url =
        //Uri.parse('https://mediumsitompul.com/basicmobile/password_reset.php');
        Uri.parse('$server/password_reset.php');

    var response = await http.post(url, body: {
      "username": username_Controller.text,
      "birthday": birthday_Controller.text,
      "password1": generateMd5(generateMd5encode64(password1_Controller.text)),
    });

    print("username_Controller.text ++++++++++++++++++");
    print(username_Controller.text);
    print("birthday_Controller.text ++++++++++++++++++");
    print(birthday_Controller.text);
    print("password1 ++++++++++++++++++");
    print(generateMd5(generateMd5encode64(password1_Controller.text)));

    final result2 = jsonDecode(response.body);
    print(result2);

    if (result2 == "success") {
      //TEST OK
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const passwordResetSuccess(),
      ));
    } else if (result2 == "failed") {
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const passwordResetFailed(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(250, 50, 50, 250),
        foregroundColor: Colors.white,

        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLength: 16,
                keyboardType: TextInputType.number,
                controller: username_Controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),

            // //........................................
            Container(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: TextField(
                  maxLength: 6,
                  controller: password1_Controller,
                  //obscureText: !_isObscure,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'New Password',
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

            Container(
                padding: const EdgeInsets.all(5),
                height: MediaQuery.of(context).size.width / 3,
                child: Center(
                    child: TextField(
                  controller: birthday_Controller,
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
                        birthday_Controller.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {}
                  },
                ))),

            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.white),
              onPressed: () {
                if (username_Controller.value.text.isEmpty) {
                  showToastMessage("Please enter username ....!!!");
                } else if (password1_Controller.value.text.isEmpty) {
                  showToastMessage("Please enter your new password ....!!!");
                } else if (birthday_Controller.value.text.isEmpty) {
                  showToastMessage("Please select birthday ....!!!");
                } else
                  _passwordReset();

                print("RESET PASSWORD...!!!");
              },
              child: const Text(
                " R E S E T",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      //................... floatingActionButton >>> IN SCAFFOLD() ................
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          // print("username0");
          // print(username0);

          print('Tombol Reffresh di pencettt');

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const MenuListAfterLogin(), //What is that?
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
