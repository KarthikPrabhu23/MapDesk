import 'package:flutter/material.dart';
import 'package:map1/Home/components/circular_banner_image.dart';

class BannerHomeWidget extends StatelessWidget {
  const BannerHomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.27,
      decoration: BoxDecoration(
        color: Colors.black12,
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
              'https://firebasestorage.googleapis.com/v0/b/map1-6175b.appspot.com/o/bg1.png?alt=media&token=f98fb95f-bcd0-45cf-b344-78d82489390a'),
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Color(0x250F1113),
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0x430F1113),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12, 20, 12, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 70, 0),
                child: Text(
                  'Navigate with precision and ease.',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                child: Text(
                  'Active users',
                  style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircularBannerImage(
                      imageUrl:
                          'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                    ),
                    CircularBannerImage(
                      imageUrl:
                          'https://www.google.com/maps/d/u/0/thumbnail?mid=1A4gtHz4iHLjSs1S_fI_f__3baxs&hl=en_US',
                    ),
                    CircularBannerImage(
                      imageUrl:
                          'https://www.google.com/maps/d/u/0/thumbnail?mid=1A4gtHz4iHLjSs1S_fI_f__3baxs&hl=en_US',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

