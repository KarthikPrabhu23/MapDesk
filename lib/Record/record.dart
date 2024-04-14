import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map1/Home/profile_page.dart';
import 'package:map1/Record/target_completion_record.dart';
import 'package:map1/main.dart';

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
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          toolbarHeight: 82,
          title: Text(
            appName,
            style: GoogleFonts.dmSerifDisplay(
              textStyle: const TextStyle(
                fontSize: 31,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
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
                  backgroundColor: Color.fromARGB(222, 21, 30, 132),
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60'),
                    //   backgroundImage: NetworkImage(
                    //       HelperFunctions.getUserDPurlSF()),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: const SizedBox(
          height: 500,
          width: 400,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
                  child: Text(
                    'Task records',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  // child: Container(
                  //   // height: MediaQuery.of(context).size.height * 0.90,
                  //   height: 500,
                  //   width: MediaQuery.of(context).size.width * 1,
                  //   decoration: const BoxDecoration(
                  //     gradient: LinearGradient(
                  //       colors: [
                  //         Color.fromARGB(255, 192, 187, 238),
                  //         Color.fromARGB(255, 221, 219, 224)
                  //       ],
                  //     ),
                  //   ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            TabBar(
                              tabs: [
                                Tab(
                                  icon: Icon(Icons.done),
                                  child: Text(
                                    'Tasks Achieved',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                Tab(
                                  icon: Icon(Icons.schedule),
                                  child: Text(
                                    'Tasks Pending',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                Tab(
                                  icon: Icon(Icons.emoji_events),
                                  child: Text(
                                    'Ranking',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 400,
                              child: TabBarView(
                                children: [
                                  TargetCompletionRecord(),
                                  TargetCompletionRecord(),
                                  TargetCompletionRecord(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // TargetCompletionRecord(),
                    ],
                  ),
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
