import 'package:doctor_app/components/custom_appbar.dart';
import 'package:doctor_app/models/auth_model.dart';
import 'package:doctor_app/providers/dio_provider.dart';
import 'package:doctor_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/button.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({super.key, required this.doctor, required this.isFav});

  final Map<String,dynamic> doctor;
  final bool isFav;

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  Map<String,dynamic> doctor = {};
  bool isFav = false;

  @override
  void initState() {
    doctor = widget.doctor;
    isFav = widget.isFav;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Config.init(context);

    ///get arguments passed from doctor card
    // final doctor =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Doctor Details',
        icon: const FaIcon(Icons.arrow_back_ios),
        actions: [
          IconButton(
            onPressed: () async{
              final list = Provider.of<AuthModel>(context, listen: false).getFav;
              if (list.contains(doctor['doc_id'])) {
                list.removeWhere((id) => id == doctor['doc_id']);
              }else{
                list.add(doctor['doc_id']);
              }
              ///update list and notify all widgets
              Provider.of<AuthModel>(context, listen: false).setFavList(list);
              final SharedPreferences prefs =
              await SharedPreferences.getInstance();
              final token = prefs.getString('token') ?? '';

              if(token.isNotEmpty && token != ''){
                ///update database
                final response = await DioProvider().storeFavDoc(token, list);
                ///if insert success change fav
                if(response == 200){
                  setState(() {
                    isFav = !isFav;
                  });
                }
              }
            },
            icon: FaIcon(
              isFav ? Icons.favorite_rounded : Icons.favorite_outline,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              // ListView takes up available space
              flex: 1,
              child: ListView(
                children: [
                  Column(
                    // Wrap content in a Column for scrolling
                    children: [
                      AboutDoctor(doctor: doctor),
                      DetailBody(doctor: doctor),
                      const SizedBox(height: 20), // Add spacing if needed
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              // Button outside ListView, fixed at bottom
              padding: const EdgeInsets.all(20),
              child: Button(
                onPressed: () {
                  ///pass doctor id
                  Navigator.of(context).pushNamed('booking_page',
                      arguments: {"doctor_id": doctor['doc_id']});
                },
                width: double.infinity,
                title: 'Book Appointment',
                disable: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutDoctor extends StatelessWidget {
  const AboutDoctor({super.key, required this.doctor});

  final Map<String, dynamic> doctor;

  @override
  Widget build(BuildContext context) {
    Config.init(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          CircleAvatar(
            radius: 65,
            backgroundImage:
                NetworkImage('http://10.0.2.2:8000${doctor['doctor_profile']}'),
            backgroundColor: Colors.white,
          ),
          Config.spaceMedium(context),
          Text(
            'Dr. ${doctor['doctor_name']}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Config.spaceSmall(context),
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'University of California San Francisco Parnassus Campus',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Config.spaceSmall(context),
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'Hospitals of the University of Pennsylvania-Penn Presbyterian',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({super.key, required this.doctor});

  final Map<String, dynamic> doctor;

  @override
  Widget build(BuildContext context) {
    Config.init(context);
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Config.spaceSmall(context),
          DoctorInfo(
            patients: doctor['patients'],
            exp: doctor['experience'],
          ),
          Config.spaceMedium(context),
          const Text(
            'About Doctor',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          Config.spaceSmall(context),
          Text(
            '${doctor['bio_data']}',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
              fontSize: 15,
            ),
            softWrap: true,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({super.key, required this.patients, required this.exp});

  final int patients;
  final int exp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InfoCard(
          label: "Patient",
          value: '$patients',
        ),
        const SizedBox(width: 15),
        InfoCard(
          label: "Experience",
          value: '$exp years',
        ),
        const SizedBox(width: 15),
        const InfoCard(
          label: "Rating",
          value: '4.6',
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Config.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 30,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
