import 'package:flutter/material.dart';
import 'package:map1/Map/classes.dart';
import 'package:map1/Record/components/task_pending_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TargetPendingRecord extends StatelessWidget {
  const TargetPendingRecord({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Column(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(10.r),
          scrollDirection: Axis.vertical,
          child: SizedBox(
            // height: MediaQuery.of(context).size.height * 0.55,
            // width:  MediaQuery.of(context).size.width,
            height: 0.54.sh,
            width: 1.sw,
            child: StreamBuilder<List<Target>>(
              stream: FirestoreService.targetLocCollectionStream(),
              builder: (context, targetSnapshot) {
                if (targetSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (targetSnapshot.hasError) {
                  return Text('Error: ${targetSnapshot.error}');
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(9),
                    itemCount: targetSnapshot.data!.length,
                    itemBuilder: (context, index) {
                      final targetLoc = targetSnapshot.data![index];

                      if (!targetLoc.completed) {
                        return TaskPendingCard(
                          targetLoc: targetLoc,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
