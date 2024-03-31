import 'package:flutter/material.dart';
import 'package:map1/Home/profile_page.dart';
import 'package:map1/Map/classes.dart';
import 'package:map1/Record/components/task_complete_card.dart';

class RecordLog extends StatefulWidget {
  const RecordLog({super.key});

  @override
  State<RecordLog> createState() => _RecordLogState();
}

class _RecordLogState extends State<RecordLog> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'TrackNow',
            style: TextStyle(
              fontSize: 31,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 28.0),
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.amber,
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YmVhY2hlc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60'),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
                child: Text(
                  'Task completion records',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.90,
                  // height: 600,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 192, 187, 238),
                        Color.fromARGB(255, 221, 219, 224)
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(10),
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          // height: 500,
                          child: StreamBuilder<List<Target>>(
                            stream:
                                FirestoreService.targetLocCollectionStream(),
                            builder: (context, targetSnapshot) {
                              if (targetSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (targetSnapshot.hasError) {
                                return Text('Error: ${targetSnapshot.error}');
                              } else {
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  padding: const EdgeInsets.all(9),
                                  itemCount: targetSnapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final targetLoc =
                                        targetSnapshot.data![index];

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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
