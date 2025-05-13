import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:src/services/secure_storage.dart';
import 'package:src/widgets/navigation.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late int user_id;
  List<bool> loaded = [false, false];

  int selected = 0;
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  Map<String, List> upcoming = {"all": [], "essential": []};
  List<Map> past = [];
  List notifs = [];

  String baseUrl = "https://6907-130-126-255-165.ngrok-free.app/ida-app";

  Widget SwitchOption(int index, String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextButton(
        onPressed: () {
          setState(() {
            selected = index;
          });
        },
        child: Text(
          text,
          style: Theme.of(context).typography.black.labelMedium!.apply(fontWeightDelta: 3,
              color: (selected == index)
                  ? Theme.of(context).primaryColorLight
                  : Color(0xFF707372)),
        ),
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
                (selected == index) ? Colors.white : Colors.transparent),
            foregroundColor: WidgetStatePropertyAll((selected == index)
                ? Theme.of(context).primaryColorLight
                : Color(0xFF707372)),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*0.3, 40))
            ),
      ),
    );
  }

  Widget EventCard(int index, int event_id, String name, String location, DateTime date, String image, String body, LatLng coordinates) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 170,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 20, 10),
        child: Card(
          elevation: 5,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, "/event", arguments: {"image": image, "date": date, "location": location, "title": name, "body": body});
            },
            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero), tapTargetSize: MaterialTapTargetSize.shrinkWrap, shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    width: MediaQuery.of(context).size.width / 5,
                    height: 170,
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    width: 0.6 * MediaQuery.of(context).size.width,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      "${days[date.weekday-1]}, ${months[date.month-1]} ${(date.day < 10) ? 0 : ""}${date.day} • ${(date.hour % 12 < 10 && date.hour % 12 != 0) ? 0 : ""}${(date.hour % 12 == 0) ? 12 : date.hour % 12}:${(date.minute < 10) ? 0 : ""}${date.minute} ${(date.hour >= 12) ? "PM" : "AM"}",
                                      style: Theme.of(context)
                                          .typography
                                          .white
                                          .labelSmall!
                                          .apply(
                                            color: Theme.of(context).primaryColorLight,
                                          ),
                                    ),
                                  ),
                                  IconButton(onPressed: () async {
                                    setState(() {
                                      if (notifs.contains(event_id)) notifs.remove(event_id);
                                      else notifs.add(event_id);
                                    });

                                    await post(Uri.parse(baseUrl + "/toggle-notification/"), body: {"user_id": user_id.toString(), "event_id": event_id.toString()});
                                    await getNotifications();
                                  }, icon: Icon((notifs.contains(event_id)) ? Icons.notifications_active : Icons.notification_add), color: (notifs.contains(event_id)) ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight, iconSize: 30,)
                                ],
                              ),
                              Text(
                                name,
                                style: Theme.of(context)
                                    .typography
                                    .black
                                    .labelLarge!
                                    .apply(
                                        color: Theme.of(context).primaryColorDark,),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 0.3 *
                                            MediaQuery.of(context).size.width),
                                    child: Text(
                                      location,
                                      style: Theme.of(context)
                                          .typography
                                          .black
                                          .labelSmall!
                                          .apply(
                                              color:
                                                  Theme.of(context).primaryColor),
                                    ),
                                  )
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/map", arguments: {"coordinates": coordinates});
                                },
                                child: Text(
                                  "View on map",
                                  style: Theme.of(context)
                                      .typography
                                      .white
                                      .labelSmall,
                                ),
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        Theme.of(context).primaryColorDark),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)))),
                              )
                            ],
                          )
                        ]),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getEvents() async {
    var response = await get(Uri.parse(baseUrl + "/get-events"));
    Map info = jsonDecode(response.body);
    List all_events = info["data"];

    List<Map> all_past = [];
    List<Map> all_new = [];
    List<Map> essential = [];
    for (int i = 0; i < all_events.length; i++) {
      all_events[i]["coordinates"] = LatLng(all_events[i]["latitude"], all_events[i]["longitude"]);
      all_events[i]["date"] = DateTime.parse(all_events[i]["date"]);

      if (all_events[i]["completed"]) all_past.add(all_events[i]);
      else {
        all_new.add(all_events[i]);
        if (all_events[i]["essential"]) essential.add(all_events[i]);
      }
    }

    setState(() {
      past = all_past;
      upcoming = {"all": all_new, "essential": essential};
      loaded[0] = true;
    });
  }

  Future<void> getNotifications() async {
    var response = await get(Uri.parse(baseUrl + "/get-notifications?user_id=${user_id}"));
    Map info = jsonDecode(response.body);
    setState(() {
      notifs = info["data"];
      loaded[1] = true;
    });
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
    if (info["user_id"] == null) {
      await Navigator.popAndPushNamed(context, "/login");
      return;
    }

    setState(() {
      user_id = int.parse(info["user_id"]!);
    });
    await getNotifications();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
    getEvents();
  }

  @override
  Widget build(BuildContext context) {
    if (loaded.contains(false)) return Scaffold(body: Center(child: LoadingAnimationWidget.inkDrop(color: Theme.of(context).primaryColorLight, size: 100)),);

    return Scaffold(
        appBar: AppBar(
          title: Text("Events",
              style: Theme.of(context)
                  .typography
                  .black
                  .headlineMedium!
                  .apply(color: Theme.of(context).primaryColorDark)),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
        ),
        body: RefreshIndicator(
            onRefresh: () async {},
            color: Theme.of(context).primaryColorLight,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        kToolbarHeight -
                        kBottomNavigationBarHeight,
                    minWidth: MediaQuery.of(context).size.width),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFC8C6C7),
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SwitchOption(0, "UPCOMING"),
                            SwitchOption(1, "PAST")
                          ],
                        ),
                      ),
                    ),
                    (selected == 0) ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Align(alignment: Alignment.centerLeft, child: Text("Registered", style: Theme.of(context).typography.black.labelLarge!.apply(color: Theme.of(context).primaryColorDark, fontWeightDelta: 3),)),
                    ) : Container(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: (selected == 0) ? ((upcoming["all"]!.isEmpty) ? [Center(child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text("No upcoming events", style: Theme.of(context).typography.black.headlineLarge,),
                      ))] : upcoming["all"]!.map((e) => EventCard(upcoming["all"]!.indexOf(e), e["event_id"], e["name"], e["location"], e["date"], e["image"], e["body"], e["coordinates"])).toList()) : ((past.isEmpty) ? [Center(child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text("No past events", style: Theme.of(context).typography.black.headlineLarge,),
                      ))] : past.map((e) => EventCard(past.indexOf(e), e["event_id"], e["name"], e["location"], e["date"], e["image"], e["body"], e["coordinates"])).toList()),
                    ),
                    (selected == 0) ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Align(alignment: Alignment.centerLeft, child: Text("Don't Miss These", style: Theme.of(context).typography.black.labelLarge!.apply(color: Theme.of(context).primaryColorDark, fontWeightDelta: 3),)),
                    ) : Container(),
                    (selected == 0) ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: (selected == 0) ? ((upcoming["essential"]!.isEmpty) ? [Center(child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text("No upcoming events", style: Theme.of(context).typography.black.headlineLarge,),
                      ))] : upcoming["essential"]!.map((e) => EventCard(upcoming["essential"]!.indexOf(e), e["event_id"], e["name"], e["location"], e["date"], e["image"], e["body"], e["coordinates"])).toList()) : ((past.isEmpty) ? [Center(child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text("No past events", style: Theme.of(context).typography.black.headlineLarge,),
                      ))] : past.map((e) => EventCard(past.indexOf(e), e["event_id"], e["name"], e["location"], e["date"], e["image"], e["body"], e["coordinates"])).toList()),
                    ) : Container(),
                  ],
                ),
              ),
            )
          ),
          bottomNavigationBar: Navigation(selected: 1),
        );
  }
}
