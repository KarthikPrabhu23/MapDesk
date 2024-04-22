import 'package:flutter/material.dart';
import 'package:map1/Map/map_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomElementWidget extends StatelessWidget {
  const RoomElementWidget({
    super.key,
    required this.context,
    required this.room,
  });

  final BuildContext context;
  final Map room;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812)); // Standard size is iPhone XS
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MapScreen()),
            );
          },
          child: Container(
            width: 0.5.sw,  // 90% of screen width
            height: 0.3.sh, // 35% of screen height
            decoration: BoxDecoration(
              color: const Color.fromARGB(222, 21, 30, 132),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4,
                  color: Color(0x430F1113),
                  offset: Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: room['roomName'],
                    transitionOnUserGestures: true,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        'https://www.google.com/maps/d/u/0/thumbnail?mid=1A4gtHz4iHLjSs1S_fI_f__3baxs&hl=en_US',
                        width: double.infinity,
                        height: 0.15.sh, // 40% of container height
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Text(
                      room['roomName'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      room['roomLocation'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'More info',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                        ),
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
