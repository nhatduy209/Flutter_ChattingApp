import 'package:flutter/material.dart';

class SettingsApp extends StatelessWidget {
  const SettingsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(leading: Container(), actions: [
          Align(
              child: TextButton(
                  onPressed: () {},
                  child: const Text('Save',
                      style: TextStyle(fontSize: 20, color: Colors.black))))
        ]),
        body: Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: Align(
              alignment: Alignment.topCenter,
              child: Column(
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
                    margin:
                        const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFE8EAF6),
                      border: Border.all(width: 0.5, color: Color(0xFFE8EAF6)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Column(children: [
                      TextButton(
                        onPressed: () {},
                        child: const ListTile(
                          leading: Icon(Icons.person, size: 35),
                          title: Text('Profile'),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ),
                      const Divider(),
                      TextButton(
                        onPressed: () {},
                        child: const ListTile(
                          leading: Icon(Icons.public, size: 35),
                          title: Text('Language'),
                          subtitle:
                              Text('English', style: TextStyle(fontSize: 13)),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ),
                    ]),
                  )
                ],
              )),
        ));
  }
}
