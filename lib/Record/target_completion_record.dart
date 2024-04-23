import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map1/Map/classes.dart';
import 'package:map1/Record/components/task_complete_card.dart';

class TargetCompletionRecord extends StatelessWidget {
  const TargetCompletionRecord({super.key});

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
          padding: EdgeInsets.all(10.r), // Use ScreenUtil to adapt padding
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: 0.54.sh, 
            width: 1.sw, 
            child: StreamBuilder<List<Target>>(
              stream: FirestoreService.targetLocCollectionStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 14.sp)); // Use ScreenUtil to adapt font size
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(child: Text("No targets found",
                    style: TextStyle(fontSize: 16.sp))); // Use ScreenUtil to adapt font size
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(9.r), // Use ScreenUtil to adapt padding
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final targetLoc = snapshot.data![index];
                      if (targetLoc.completed) {
                        return TaskCard(
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
