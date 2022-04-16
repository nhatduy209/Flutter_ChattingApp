import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SingleChildScrollView(
          child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                   Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(top: 20.0, bottom: 30.0, left: 24, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.arrow_back, color: Colors.black38, size: 24.0),
                        const Text("Save", style: TextStyle(fontSize: 25.0, color: Colors.amber)),
                      ],
                    )
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: const Text("My Profile", style: TextStyle(fontSize: 25.0, color: Colors.black)),
                  ),
                  Container(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.network(
                            'https://scontent.fsgn5-14.fna.fbcdn.net/v/t39.30808-6/241641645_1039308073570420_4340682428897197454_n.jpg?_nc_cat=101&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=nJLSb_4ICeEAX8ZLJ2Z&_nc_ht=scontent.fsgn5-14.fna&oh=00_AT-PNc2us-m_wYgALpS9Mf5jcFcM0bVwS_5gIb_CIjgrCw&oe=625E5BB3',
                            height: 100.0,
                            width: 100.0,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 80.0, left: 80.0),
                          child: const Icon(Icons.camera, color: Colors.black38, size: 24.0),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                    alignment: Alignment.bottomLeft,
                    child: const Text("Username", style: TextStyle(fontSize: 25.0, color: Colors.black)),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                    padding: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                       borderRadius: BorderRadius.circular(8.0)
                    ),
                    child: const Flexible(
                          child: SizedBox(
                        height: 50,
                        width: 300,
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                        ),
                      )),
                    ),
                    Container(
                    margin: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                    alignment: Alignment.bottomLeft,
                    child: const Text("Email", style: TextStyle(fontSize: 25.0, color: Colors.black)),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                    padding: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                       borderRadius: BorderRadius.circular(8.0)
                    ),
                    child: const Flexible(
                          child: SizedBox(
                        height: 50,
                        width: 300,
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                        ),
                      )),
                    ),
                    Container(
                    margin: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                    alignment: Alignment.bottomLeft,
                    child: const Text("Age", style: TextStyle(fontSize: 25.0, color: Colors.black)),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                    padding: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                       borderRadius: BorderRadius.circular(8.0)
                    ),
                    child: const Flexible(
                          child: SizedBox(
                        height: 50,
                        width: 300,
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                        ),
                      )),
                    ),
                    Container(
                    margin: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                    alignment: Alignment.bottomLeft,
                    child: const Text("Phone Number", style: TextStyle(fontSize: 25.0, color: Colors.black)),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                    padding: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                       borderRadius: BorderRadius.circular(8.0)
                    ),
                    child: const Flexible(
                          child: SizedBox(
                        height: 50,
                        width: 300,
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                        ),
                      )),
                    ),
                ],
              )),
        ));
  }
}
