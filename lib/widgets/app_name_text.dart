import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopsmart_users_en/widgets/title_text.dart';
import 'package:google_fonts/google_fonts.dart';

class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget({super.key, this.fontSize = 30});
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 22),
      baseColor: Colors.purple,
      highlightColor: Colors.red,
      child: TitlesTextWidget(
        label: "UniShop",
        fontSize: fontSize, // เพิ่มฟอนต์ Roboto
      ),
    );
  }
}
