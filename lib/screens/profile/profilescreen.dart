import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamronblue_frontend/controllers/profile_controller.dart';
import 'dart:math' as math;

import 'package:tamronblue_frontend/utils/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var agent_id = 0;
  var first_name = ' ';
  var last_name = ' ';
  var email = ' ';
  var point = 0;
  var level = 0;
  var monthly_income = 0.0;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  void getProfileData() async {
    await ProfileController().getMyDetailsSaveShared();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      agent_id = prefs.getInt('id') ?? 0;
      first_name = prefs.getString('first_name') ?? ' ';
      last_name = prefs.getString('last_name') ?? ' ';
      email = prefs.getString('email') ?? ' ';
      point = prefs.getInt('point') ?? 0;
      level = prefs.getInt('level') ?? 0;
      monthly_income = prefs.getDouble('monthly_income') ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
          ),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // show popup menu
          IconButton(
            onPressed: () {
              popUpMenu(context);
            },
            icon: const Icon(Iconsax.more),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 130,
                        height: 140,
                        child: CircularPercentIndicator(
                          radius: 60.0,
                          lineWidth: 10.0,
                          animation: true,
                          animationDuration: 1200,
                          percent: point.remainder(100) / 100,
                          center: Text(
                            '$point',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Theme.of(context).primaryColor,
                          backgroundColor: Color.fromARGB(36, 131, 131, 131),
                        ),
                      ),
                      CircleAvatar(
                        radius: 50,
                        child: Text(
                            first_name[0].toUpperCase() +
                                last_name[0].toUpperCase(),
                            style: const TextStyle(fontSize: 30)),
                      ),
                      Positioned(
                        top: 10,
                        right: 0,
                        child: Center(
                          child: SizedBox(
                            height: 30,
                            child: Chip(
                              padding: const EdgeInsets.only(bottom: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(200),
                              ),
                              label: Row(
                                children: [
                                  Text(
                                    '$point',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                  point.remainder(100) / 100 > 0.75
                                      ? const Text('+',
                                          style: TextStyle(fontFeatures: [
                                            FontFeature.superscripts()
                                          ]))
                                      : const Text(''),
                                ],
                              ),
                              backgroundColor: Theme.of(context).canvasColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //show level
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Level ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$level',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    point.remainder(100) / 100 > 0.75
                        ? Transform.rotate(
                            angle: 270 * math.pi / 180,
                            child: const Icon(Icons.double_arrow_rounded,
                                color: Colors.green))
                        : Transform.rotate(
                            angle: 90 * math.pi / 180,
                            child: const Icon(Icons.double_arrow_rounded,
                                color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '$first_name $last_name',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$email',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Rs. $monthly_income',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const Text(
                            'Monthly Income',
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '1250',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const Text(
                            'Number of plants sold',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                //tab bar
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(
                            text: 'Achievement',
                          ),
                          Tab(
                            text: 'My Info',
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        //phone screen height get
                        height: MediaQuery.of(context).size.height - 220,
                        child: TabBarView(
                          children: [
                            ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text('Achievement $index'),
                                  subtitle: Text('Description $index'),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Iconsax.more),
                                  ),
                                );
                              },
                            ),
                            Center(
                              child: Text('My Info'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
