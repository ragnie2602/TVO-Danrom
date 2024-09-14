import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';

class AppTextTheme {
  static const bodyMedium = TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500);

  static const cardMedium = TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w500);

  static const descriptionBoldSmall =
      TextStyle(color: AppColor.black, fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 12);
  static const descriptionBoldRegular =
      TextStyle(color: AppColor.black, fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14);
  static const descriptionBoldSemiLarge =
      TextStyle(color: AppColor.black, fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 16);
  static const descriptionRegularSemiLarge =
      TextStyle(color: AppColor.black, fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 16);
  static const descriptionSemiBoldSmall =
      TextStyle(color: AppColor.black, fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 12);
  static const descriptionSmall =
      TextStyle(color: AppColor.black, fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 12);
  static const descriptionSemiBoldRegular =
      TextStyle(color: AppColor.black, fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14);

  static const logoBoldLarge = TextStyle(fontFamily: 'Spartan', fontWeight: FontWeight.w700, fontSize: 30);

  static const interBold20 = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 20);
  static const interMedium11 = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 11);
  static const interMedium16 = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 16);
  static const interSemiBold14 = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14);
  static const interRegular20 =
      TextStyle(color: AppColor.black, fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 20);
  static const interRegular30 =
      TextStyle(color: AppColor.black, fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 30);

  static const notosansBold12 = TextStyle(
      color: AppColor.black, fontFamily: 'NotoSans', fontSize: 12, fontVariations: [FontVariation.weight(700)]);
  static const notosansRegular16 = TextStyle(
      color: AppColor.white, fontFamily: 'NotoSans', fontSize: 16, fontVariations: [FontVariation.weight(400)]);
  static const notosansMedium16 = TextStyle(
      color: AppColor.black, fontFamily: 'NotoSans', fontSize: 16, fontVariations: [FontVariation.weight(500)]);
  static const notosansSemiBold18 = TextStyle(
      color: AppColor.black, fontFamily: 'NotoSans', fontSize: 18, fontVariations: [FontVariation.weight(600)]);
  static const notosansBold18 = TextStyle(
      color: AppColor.white, fontFamily: 'NotoSans', fontSize: 18, fontVariations: [FontVariation.weight(700)]);

  static const optionBodyRegular = TextStyle(
      color: AppColor.gray03, fontFamily: 'Montserrat', fontSize: 11, fontVariations: [FontVariation.weight(500)]);
  static const optionBodyMedium = TextStyle(
      color: AppColor.black, fontFamily: 'Montserrat', fontSize: 14, fontVariations: [FontVariation.weight(500)]);
  static const optionTitleMedium = TextStyle(
      color: AppColor.black, fontFamily: 'Montserrat', fontSize: 16, fontVariations: [FontVariation.weight(500)]);

  static const poppinsRegular12 =
      TextStyle(color: AppColor.gray12, fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 12);
  static const poppinsMedium14 =
      TextStyle(color: AppColor.black, fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14);
  static const poppinsMedium16 = TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16);
  static const poppinsMedium20 = TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 20);
  static const poppinsSemiBold24 = TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 24);
  static const poppinsMedium32 = TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 32);
  static const poppinsRegular10 = TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 10);
  static const poppinsRegular96 = TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 96);

  static final gradientTextStyle = TextStyle(
      fontFamily: 'Spartan',
      fontWeight: FontWeight.w700,
      foreground: Paint()
        ..shader = const LinearGradient(
                colors: [AppColor.primaryColor1, AppColor.primaryColor2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)
            .createShader(const Rect.fromLTWH(0.0, 0.0, 16 * 10, 16 * 5)));

  static const robotoFlexBoldMedium =
      TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w700, fontSize: 24, letterSpacing: 0.1);
}
