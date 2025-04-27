import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  LatLng? center;
  Set<Marker> markers = {};

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
  List<Map> events = [{"name": "Keep Calm and Ask A Dad", "location": "CIF Room 3025", "date": DateTime.now(), "image": "https://i.imgur.com/Z3X6IMd.png", "coordinates": LatLng(40.112866138760154, -88.22778400452617)}, {"name": "UIUC vs Purdue Basketball", "location": "State Farm Center", "date": DateTime.now(), "image": "https://i.imgur.com/UGnaS5X.jpeg", "coordinates": LatLng(40.09659366812142, -88.23489569343018)}];

  Widget EventCard(String name, String location, DateTime date, String image, LatLng coordinates) {
    return Container(
      width: 0.8 * MediaQuery.of(context).size.width,
      height: 170,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Card(
          elevation: 5,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: TextButton(
            onPressed: () {
              setState(() {
                markers = {
                  Marker(markerId: MarkerId("My location"), position: center!),
                  Marker(markerId: MarkerId("Event location"), position: coordinates)
                };
              });
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
                    width: 0.4 * MediaQuery.of(context).size.width,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${days[date.weekday-1]}, ${months[date.month-1]} ${date.day} • ${date.hour % 12 == 0 ? 12 : date.hour % 12}:${date.minute} ${(date.hour >= 12) ? "PM" : "AM"}",
                            style: Theme.of(context)
                                .typography
                                .white
                                .labelSmall!
                                .apply(
                                  color: Theme.of(context).primaryColorLight,
                                ),
                          ),
                          Text(
                            name,
                            style: Theme.of(context)
                                .typography
                                .black
                                .labelMedium!
                                .apply(
                                    color: Theme.of(context).primaryColorDark),
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

  void getPosition() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position posit = await Geolocator.getCurrentPosition();
    setState(() {
      center = LatLng(posit.latitude, posit.longitude);
      markers = {Marker(markerId: MarkerId("My location"), position: center!)};
    });
  }

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  @override
  Widget build(BuildContext context) {
    if (center == null) return Scaffold(body: Center(child: LoadingAnimationWidget.inkDrop(color: Theme.of(context).primaryColorLight, size: 100)),);

    Map args = {};
    if (ModalRoute.of(context)!.settings.arguments != null) args = ModalRoute.of(context)!.settings.arguments as Map;

    if (args.isNotEmpty) {
      setState(() {
        markers = {
          Marker(markerId: MarkerId("My location"), position: center!),
          Marker(markerId: MarkerId("Event location"), position: args["coordinates"])
        };
      });
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          GoogleMap(initialCameraPosition: CameraPosition(target: center!, zoom: 14), markers: markers, zoomControlsEnabled: false,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(color: Colors.white, child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios), color: Colors.black,), Expanded(child: TextFormField(decoration: InputDecoration(border: InputBorder.none, hintText: "Search for events", hintStyle: Theme.of(context).typography.black.labelLarge!.apply(color: Color(0xFF9C9A9D))), cursorColor: Colors.black,))],),
            )),
          ),
        ],
      ),
      bottomSheet: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(children: events.map((e) => EventCard(e["name"], e["location"], e["date"], e["image"], e["coordinates"])).toList(),),
      ),),
    );
  }
}