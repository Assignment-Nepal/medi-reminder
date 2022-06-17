import 'package:flutter/material.dart';

class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({@required this.title, this.image, this.desc});
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Schedule Reminders.",
    image: "assets/images/image1.png",
    desc:
        "Never forget to take your medications on time and miss your medical appointment again.",
  ),
  OnboardingContents(
    title: "Remote Monitoring.",
    image: "assets/images/image2.png",
    desc:
        "Self-care is sometimes practically impossible; add your virtual caregiver today to help you stay healthy.",
  ),
  OnboardingContents(
    title: "Health Tracker.",
    image: "assets/images/image3.png",
    desc:
        "Keep track of your health. Share detailed reports with your loved ones.",
  ),
];
