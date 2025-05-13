import 'package:flutter/material.dart';
import 'package:src/services/secure_storage.dart';
import 'package:src/widgets/navigation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email = "N/A";

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
    if (info["user_id"] == null) {
      await Navigator.popAndPushNamed(context, "/login");
      return;
    }
    setState(() {
      email = info["email"]!;
    });
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
      body: RefreshIndicator(
        onRefresh: () async {},
        color: Theme.of(context).primaryColorLight,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height -
                        kToolbarHeight -
                        kBottomNavigationBarHeight
            ),
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).primaryColorDark,
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text(
                    "Profile",
                    style: Theme.of(context).typography.black.headlineLarge!.apply(fontWeightDelta: 3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Text(
                    email,
                    style: Theme.of(context).typography.black.labelMedium,
                  ),
                ),
                TextButton(onPressed: () {Navigator.pushNamed(context, "/settings");}, child: Text(
                      "Notifications",
                      style: Theme.of(context).typography.black.labelMedium!.apply(),
                    ),),
                TextButton(
                    onPressed: () async {
                      await SecureStorage.delete();
                      await Navigator.popAndPushNamed(context, "/login");
                    },
                    child: Text(
                      "LOG OUT",
                      style: Theme.of(context).typography.white.labelLarge!.apply(fontSizeDelta: 2, fontWeightDelta: 3),
                    ),
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).primaryColor),
                        fixedSize: WidgetStatePropertyAll(
                            Size(0.6 * MediaQuery.of(context).size.width, 50)),
                        elevation: WidgetStatePropertyAll(10)),
                  )
              ],
            )
          ),
        ),
      ),
      bottomNavigationBar: Navigation(selected: 4),
    );
  }
}