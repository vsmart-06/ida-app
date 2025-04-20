import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:src/widgets/navigation.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
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
  List<List<Map>> upcoming = [[{"name": "Keep Calm and Ask A Dad", "location": "CIF Room 3025", "date": DateTime.now(), "image": "https://i.imgur.com/Z3X6IMd.png", "body": "Calling all University of Illinois students! Join us for the Illini Dads Association's \"Ask A Dad\" Q&A session—a unique opportunity to connect with experienced Illini dads and gain valuable insights into life after campus/jump starting your careers. Don't miss this chance to ask questions and build!", "coordinates": LatLng(40.112866138760154, -88.22778400452617), "notify": true}], [{"name": "Keep Calm and Ask A Dad", "location": "CIF Room 3025", "date": DateTime.now(), "image": "https://i.imgur.com/Z3X6IMd.png", "body": "Calling all University of Illinois students! Join us for the Illini Dads Association's \"Ask A Dad\" Q&A session—a unique opportunity to connect with experienced Illini dads and gain valuable insights into life after campus/jump starting your careers. Don't miss this chance to ask questions and build!", "coordinates": LatLng(40.112866138760154, -88.22778400452617), "notify": false}]];
  List<Map> past = [{"name": "UIUC vs Purdue Basketball", "location": "State Farm Center", "date": DateTime.now(), "image": "https://i.imgur.com/UGnaS5X.jpeg", "body": "Calling all University of Illinois students! Join us for the Illini Dads Association's \"Ask A Dad\" Q&A session—a unique opportunity to connect with experienced Illini dads and gain valuable insights into life after campus/jump starting your careers. Don't miss this chance to ask questions and build! Calling all University of Illinois students! Join us for the Illini Dads Association's \"Ask A Dad\" Q&A session—a unique opportunity to connect with experienced Illini dads and gain valuable insights into life after campus/jump starting your careers. Don't miss this chance to ask questions and build! Calling all University of Illinois students! Join us for the Illini Dads Association's \"Ask A Dad\" Q&A session—a unique opportunity to connect with experienced Illini dads and gain valuable insights into life after campus/jump starting your careers. Don't miss this chance to ask questions and build!!", "coordinates": LatLng(40.09659366812142, -88.23489569343018), "notify": true}];

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

  Widget EventCard(int index, String name, String location, DateTime date, String image, String body, LatLng coordinates, bool notify) {
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
                                      "${days[date.weekday-1]}, ${months[date.month-1]} ${date.day} • ${date.hour % 12 == 0 ? 12 : date.hour % 12}:${date.minute} ${(date.hour >= 12) ? "PM" : "AM"}",
                                      style: Theme.of(context)
                                          .typography
                                          .white
                                          .labelSmall!
                                          .apply(
                                            color: Theme.of(context).primaryColorLight,
                                          ),
                                    ),
                                  ),
                                  IconButton(onPressed: () {
                                    setState(() {
                                      if (upcoming[0][index]["name"] == name) upcoming[0][index]["notify"] = !notify;
                                      if (upcoming[1][index]["name"] == name) upcoming[1][index]["notify"] = !notify;
                                      if (past[index]["name"] == name) past[index]["notify"] = !notify;
                                    });
                                  }, icon: Icon((notify) ? Icons.notifications_active : Icons.notification_add), color: (notify) ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight, iconSize: 30,)
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

  @override
  Widget build(BuildContext context) {
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
                      children: (selected == 0) ? ((upcoming[0].isEmpty) ? [Center(child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text("No upcoming events", style: Theme.of(context).typography.black.headlineLarge,),
                      ))] : upcoming[0].map((e) => EventCard(upcoming[0].indexOf(e), e["name"], e["location"], e["date"], e["image"], e["body"], e["coordinates"], e["notify"])).toList()) : ((past.isEmpty) ? [Center(child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text("No past events", style: Theme.of(context).typography.black.headlineLarge,),
                      ))] : past.map((e) => EventCard(past.indexOf(e), e["name"], e["location"], e["date"], e["image"], e["body"], e["coordinates"], e["notify"])).toList()),
                    ),
                    (selected == 0) ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Align(alignment: Alignment.centerLeft, child: Text("Don't Miss These", style: Theme.of(context).typography.black.labelLarge!.apply(color: Theme.of(context).primaryColorDark, fontWeightDelta: 3),)),
                    ) : Container(),
                    (selected == 0) ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: (selected == 0) ? ((upcoming[1].isEmpty) ? [Center(child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text("No upcoming events", style: Theme.of(context).typography.black.headlineLarge,),
                      ))] : upcoming[1].map((e) => EventCard(upcoming[1].indexOf(e), e["name"], e["location"], e["date"], e["image"], e["body"], e["coordinates"], e["notify"])).toList()) : ((past.isEmpty) ? [Center(child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text("No past events", style: Theme.of(context).typography.black.headlineLarge,),
                      ))] : past.map((e) => EventCard(past.indexOf(e), e["name"], e["location"], e["date"], e["image"], e["body"], e["coordinates"], e["notify"])).toList()),
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
