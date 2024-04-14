import 'package:flutter/material.dart';
import 'package:map1/Map/classes.dart';
import 'package:map1/Record/components/task_ranking_card.dart';

class TargetRankingRecord extends StatelessWidget {
  const TargetRankingRecord({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      scrollDirection: Axis.vertical,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<List<User>>(
          stream: FirestoreService.userCollectionStream(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (userSnapshot.hasError) {
              return Text('Error: ${userSnapshot.error}');
            } else {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(9),
                itemCount: userSnapshot.data!.length,
                itemBuilder: (context, index) {
                  final userItem = userSnapshot.data![index];

                  return TaskRankingCard(
                    userItem: userItem,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
