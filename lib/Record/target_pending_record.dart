import 'package:flutter/material.dart';
import 'package:map1/Map/classes.dart';
import 'package:map1/Record/components/task_pending_card.dart';

class TargetPendingRecord extends StatelessWidget {
  const TargetPendingRecord({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      scrollDirection: Axis.vertical,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        // height: 200,
        width: 300,
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
                    return Container();
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
