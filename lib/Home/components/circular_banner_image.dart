import 'package:flutter/material.dart';

class CircularBannerImage extends StatelessWidget {
  final  String imageUrl;

  const CircularBannerImage({
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          imageUrl,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
