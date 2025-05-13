// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:src/widgets/navigation.dart';

class EventPage extends StatelessWidget {
  EventPage({super.key});

  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    String image = args["image"];
    DateTime date = args["date"];
    String location = args["location"];
    String title = args["title"];
    String body = args["body"];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Event Details",
            style: Theme.of(context).typography.white.headlineMedium!),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
          onRefresh: () async {},
          color: Theme.of(context).primaryColorLight,
          backgroundColor: Colors.white,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height -
                              kToolbarHeight -
                              kBottomNavigationBarHeight,
                          minWidth: MediaQuery.of(context).size.width),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                height:
                                    0.3 * MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                color: Theme.of(context).primaryColorDark,
                                child: Image(
                                    image: NetworkImage(image),
                                    fit: BoxFit.contain),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Icon(
                                            Icons.event_available_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "${date.day} ${months[date.month-1]}, ${date.year}",
                                          style: Theme.of(context)
                                              .typography
                                              .white
                                              .labelMedium!.apply(fontWeightDelta: 3),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text("${location}",
                                            style: Theme.of(context)
                                                .typography
                                                .white
                                                .labelMedium!.apply(fontWeightDelta: 3))
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: Theme.of(context)
                                      .typography
                                      .black
                                      .headlineLarge!.apply(fontWeightDelta: 3),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "About the event",
                                  style: Theme.of(context)
                                      .typography
                                      .black
                                      .labelLarge!.apply(fontWeightDelta: 3),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  body,
                                  style: Theme.of(context)
                                      .typography
                                      .black
                                      .bodyLarge,
                                ),
                                SizedBox(height: 50,)
                              ],
                            ),
                          ),
                        ],
                      ))),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "RSVP",
                    style: Theme.of(context).typography.white.labelLarge!.apply(fontSizeDelta: 2, fontWeightDelta: 3),
                  ),
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).primaryColorLight),
                      fixedSize: WidgetStatePropertyAll(
                          Size(0.6 * MediaQuery.of(context).size.width, 50)),
                      elevation: WidgetStatePropertyAll(10)),
                ),
              )
            ],
          )),
      bottomNavigationBar: Navigation(selected: 1),
    );
  }
}
