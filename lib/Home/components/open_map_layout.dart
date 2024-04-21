import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map1/Home/components/big_button.dart';
import 'package:map1/Map/map_screen.dart';
import 'package:map1/my_colors.dart';

class OpenMap extends StatelessWidget {
  const OpenMap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MapBoard',
            style: GoogleFonts.robotoSlab(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: BigButton(
              color: MyColors.ButtonBlue2,
              icon: Icons.map,
              text: 'Open Map',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
