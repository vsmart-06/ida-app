import 'package:flutter/material.dart';
import 'package:src/widgets/navigation.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, bool> notifs = {
    "General Announcements": true,
    "Ticket Updates": true,
    "New Merchandise": true,
    "Order Status": true,
  };

  String alert = "Off";
  List<String> alerts = ["Off", "30 minutes before", "2 hours before", "6 hours before"];

  Widget NotificationOption(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: Theme.of(context).typography.black.labelLarge),
        Switch(
          thumbColor: WidgetStatePropertyAll(Colors.white),
          activeTrackColor: Colors.green,
          inactiveTrackColor: Theme.of(context).primaryColor,
          value: notifs[name]!,
          onChanged:
              (value) => setState(() {
                notifs[name] = value;
              }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Notifications",
          style: Theme.of(context).typography.black.headlineMedium!.apply(
            color: Theme.of(context).primaryColorDark,
          ),
        ),
      ),
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                children: [
                      Divider(),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: notifs.keys.map((e) => NotificationOption(e)).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Event Reminders", style: Theme.of(context).typography.black.labelLarge),
                          DropdownButton(
                            value: alert,
                            icon: const Icon(Icons.swap_vert),
                            elevation: 16,
                            style: Theme.of(context).typography.black.labelMedium,
                            dropdownColor: Colors.white,
                            onChanged: (String? value) {
                              setState(() {
                                alert = value!;
                              });
                            },
                            items:
                                alerts.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(value: value, child: Text(value));
                                }).toList(),
                          )
                        ],
                      )
                    ]
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Navigation(selected: 4),
    );
  }
}
