import 'package:flutter/material.dart';
import 'package:map1/Map/classes.dart';
import 'package:map1/Record/components/task_complete_card.dart';

class TargetCompletionRecord extends StatelessWidget {
  const TargetCompletionRecord({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          scrollDirection: Axis.vertical,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.55,
            width:  MediaQuery.of(context).size.width,
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
            
                      if (targetLoc.completed) {
                        return TaskCard(
                          targetLoc: targetLoc,
                        );
                      } else {
                        return Container();
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
