import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctor_app/components/doctor_card.dart';
import 'package:doctor_app/providers/dio_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/appointment_card.dart';
import '../models/auth_model.dart';
import '../utils/config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};
  Map<String, dynamic> doctor = {};
  List<dynamic> favList = [];
  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.userDoctor,
      "category": "General",
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
      "category": "Cardiology",
    },
    {
      "icon": FontAwesomeIcons.lungs,
      "category": "Respirations",
    },
    {
      "icon": FontAwesomeIcons.hand,
      "category": "Dermatology",
    },
    {
      "icon": FontAwesomeIcons.personPregnant,
      "category": "Gynecology",
    },
    {
      "icon": FontAwesomeIcons.teeth,
      "category": "Dental",
    },
  ];

  // Future<void> getData() async {
  //   ///get token from share preferences
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token') ?? '';
  //
  //   if (token.isNotEmpty && token != '') {
  //     final response = await DioProvider().getUser(token);
  //     if (response != null) {
  //       setState(() {
  //         user = json.decode(response);
  //
  //         ///check if any appointment today
  //         for (var doctorData in user['doctor']) {
  //           if (doctorData['appointments'] != null) {
  //             doctor = doctorData;
  //           }
  //         }
  //       });
  //     }
  //   }
  // }

  // @override
  // void initState() {
  //   getData();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    Config.init(context);
    user = Provider.of<AuthModel>(context, listen: false).getUser;
    doctor = Provider.of<AuthModel>(context, listen: false).getAppointment;
    favList = Provider.of<AuthModel>(context, listen: false).getFav;

    return Scaffold(
      body: user.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            user['name'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                'assets/bia.jpg',
                              ),
                            ),
                          )
                        ],
                      ),
                      Config.spaceMedium(context),

                      ///category listing
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall(context),

                      ///build categories
                      SizedBox(
                        height: Config.heightSize * 0.05,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List<Widget>.generate(
                            medCat.length,
                            (index) {
                              return Card(
                                margin: const EdgeInsets.only(right: 20),
                                color: Config.primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      FaIcon(
                                        medCat[index]['icon'],
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        medCat[index]['category'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Config.spaceSmall(context),
                      const Text(
                        'Appointment Today',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall(context),

                      ///display appointment card
                      doctor.isNotEmpty
                          ? AppointmentCard(
                              doctor: doctor,
                              color: Config.primaryColor,
                            )
                          : Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    'No Appointment for today.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      Config.spaceSmall(context),
                      const Text(
                        'Top Doctors',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      ///list of top doctors
                      Config.spaceSmall(context),
                      Column(
                        children: List.generate(user['doctor'].length, (index) {
                          return DoctorCard(
                            // route: 'doctor_details',
                            doctor: user['doctor'][index],
                            isFav: favList
                                    .contains(user['doctor'][index]['doc_id'])
                                ? true
                                : false,
                          );
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
