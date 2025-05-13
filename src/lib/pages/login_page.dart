import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart";
import 'package:src/services/secure_storage.dart';

class CirclePainter extends CustomPainter {
  Color color;
  Offset location;
  CirclePainter({required this.color, required this.location});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.strokeWidth = 2;
    paint.color = color;
    paint.shader = RadialGradient(
      colors: [color, Colors.white],
    ).createShader(Rect.fromCircle(center: location, radius: size.width / 2));
    canvas.drawCircle(location, size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color grey = Color(0xFF9C9A9D);
  String email = "";
  String password = "";
  String error = "";

  String baseUrl = "https://6907-130-126-255-165.ngrok-free.app/ida-app";

  Future<bool> login() async {
    var response = await post(Uri.parse(baseUrl + "/login/"), body: {"email": email, "password": password});
    Map info = jsonDecode(response.body);
    if (info.containsKey("error")) {
      setState(() {
        error = info["error"];
      });
      return false;
    }
    await SecureStorage.writeMany({"user_id": info["user_id"].toString(), "last_login": DateTime.now().toString(), "email": info["email"].toString(), "admin": info["admin"].toString()});
    Navigator.popAndPushNamed(context, "/home");
    return true;
  }

  Future<void> checkLogin() async {
    Map<String, String> info = await SecureStorage.read();
    if (info["last_login"] != null) {
      DateTime date = DateTime.parse(info["last_login"]!);
      if (DateTime.now().subtract(Duration(days: 30)).compareTo(date) >= 0) {
        await SecureStorage.delete();
        await Navigator.popAndPushNamed(context, "/login");
        return;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(350, 350),
              painter: CirclePainter(
                color: Theme.of(context).primaryColorDark,
                location: Offset(0, MediaQuery.of(context).size.height),
              ),
            ),
            CustomPaint(
              size: Size(350, 350),
              painter: CirclePainter(
                color: Theme.of(context).primaryColorLight,
                location: Offset(MediaQuery.of(context).size.width, 0),
              ),
            ),
            Container(
              color: Color(0x77FFFFFF),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image(
                    image: NetworkImage("https://i.imgur.com/0FHQKN4.png"),
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Log In",
                        style: Theme.of(
                          context,
                        ).typography.black.headlineLarge!.apply(
                          color: Theme.of(context).primaryColorDark,
                          fontWeightDelta: 7,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline, color: grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: grey, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: grey, width: 2),
                            ),
                            hintText: "Email",
                            hintStyle: Theme.of(
                              context,
                            ).typography.black.labelLarge!.apply(color: grey),
                          ),
                          cursorColor: grey,
                          onChanged: (value) => setState(() {
                            email = value;
                          }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_open_outlined,
                              color: grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: grey, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: grey, width: 2),
                            ),
                            hintText: "Password",
                            hintStyle: Theme.of(
                              context,
                            ).typography.black.labelLarge!.apply(color: grey),
                          ),
                          cursorColor: grey,
                          onChanged: (value) => setState(() {
                            password = value;
                          }),
                        ),
                      ),
                      (error.isNotEmpty) ? Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: Text(
                          error,
                          style: Theme.of(context).typography.white.bodyLarge!.apply(color: Colors.red),
                        ),
                      ) : Container()
                    ],
                  ),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (email.isEmpty) {
                            setState(() {
                              error = "Email cannot be empty";
                            });
                            return;
                          }
                          if (password.isEmpty) {
                            setState(() {
                              error = "Password cannot be empty";
                            });
                            return;
                          }

                          await login();                          
                        },
                        child: Text(
                          "LOGIN",
                          style: Theme.of(
                            context,
                          ).typography.white.labelMedium!.apply(fontWeightDelta: 7),
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).primaryColorLight,
                          ),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          fixedSize: WidgetStatePropertyAll(
                            Size(MediaQuery.of(context).size.width * 0.75, 50),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account yet?", style: Theme.of(context).typography.black.bodyLarge!.apply(color: Theme.of(context).primaryColorDark),),
                            TextButton(onPressed: () {Navigator.of(context).popAndPushNamed("/signup");}, child: Text("Sign Up", style: Theme.of(context).typography.black.bodyLarge!.apply(color: Theme.of(context).primaryColorDark, fontWeightDelta: 7, decoration: TextDecoration.underline),))
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
