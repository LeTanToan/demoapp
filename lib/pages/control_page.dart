import 'package:flutter/material.dart';
import 'package:flutter_app_v1/pages/home_page.dart';
import 'package:flutter_app_v1/values/app_assets.dart';
import 'package:flutter_app_v1/values/app_colors.dart';
import 'package:flutter_app_v1/values/app_styles.dart';
import 'package:flutter_app_v1/values/share_keys.dart';
import "package:shared_preferences/shared_preferences.dart";

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  double sliderValue = 5;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initDefaulValue();
  }

  initDefaulValue() async {
    prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(ShareKeys.counter) ?? 5;
    setState(() {
      sliderValue = value.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        title: Text(
          'Your Control',
          style: AppStyles.h3.copyWith(
            color: AppColors.textColor,
            fontSize: 36,
          ),
        ),
        leading: InkWell(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            // ignore: unused_local_variable
            int len = prefs.getInt(ShareKeys.counter) ?? 5;
            await prefs.setInt(ShareKeys.counter, sliderValue.toInt());
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false);
          },
          child: Image.asset(AppAssets.leftArrow),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(children: [
          const Spacer(),
          Text(
            'How much a number word at once',
            style: AppStyles.h4.copyWith(
              color: AppColors.lightGrey,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          Text(
            '${sliderValue.toInt()}',
            style: AppStyles.h4.copyWith(
                color: AppColors.primaryColor,
                fontSize: 150,
                fontWeight: FontWeight.bold),
          ),
          Slider(
              value: sliderValue,
              min: 5,
              max: 100,
              divisions: 95,
              activeColor: AppColors.primaryColor,
              inactiveColor: AppColors.primaryColor,
              onChanged: (value) {
                setState(() {
                  sliderValue = value;
                });
              }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            alignment: Alignment.centerLeft,
            child: Text(
              'Slide to set',
              style: AppStyles.h5.copyWith(
                  color: AppColors.textColor, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          const Spacer(),
        ]),
      ),
    );
  }
}
