import 'package:android_package_manager/android_package_manager.dart';
import 'package:flutter/material.dart';
import 'package:perm_man/app_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Permission Manager Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<ApplicationInfo>? _applicationInfoList = [];
  final List<PermissionData> _permissionData = [
  PermissionData(name: 'Camera', permission: 'android.permission.CAMERA'),
  PermissionData(name: 'Microphone', permission: 'android.permission.RECORD_AUDIO'),
  PermissionData(name: 'Read Phone State', permission: 'android.permission.READ_PHONE_STATE'),
  PermissionData(name: 'Read Contacts', permission: 'android.permission.READ_CONTACTS'),
  PermissionData(name: 'Location', permission: 'android.permission.ACCESS_FINE_LOCATION'),
  PermissionData(name: 'Read SMS', permission: 'android.permission.READ_SMS'),
  PermissionData(name: 'Write SMS', permission: 'android.permission.SEND_SMS'),
  PermissionData(name: 'Calendar', permission: 'android.permission.READ_CALENDAR'),
  PermissionData(name: 'Storage', permission: 'android.permission.WRITE_EXTERNAL_STORAGE'),
  PermissionData(name: 'Internet', permission: 'android.permission.INTERNET'),
  PermissionData(name: 'Call Log', permission: 'android.permission.READ_CALL_LOG'),
  PermissionData(name: 'Call Phone', permission: 'android.permission.CALL_PHONE'),
  PermissionData(name: 'Body Sensors', permission: 'android.permission.BODY_SENSORS'),
  PermissionData(name: 'Background Location', permission: 'android.permission.ACCESS_BACKGROUND_LOCATION'),
  PermissionData(name: 'Contacts & SMS', permission: 'android.permission.READ_CONTACTS,android.permission.READ_SMS'),
  PermissionData(name: 'Accounts', permission: 'android.permission.GET_ACCOUNTS'),
  PermissionData(name: 'Bluetooth', permission: 'android.permission.BLUETOOTH'),
  PermissionData(name: 'Read External Storage', permission: 'android.permission.READ_EXTERNAL_STORAGE'),
  PermissionData(name: 'NFC', permission: 'android.permission.NFC'),
  PermissionData(name: 'Modify Audio Settings', permission: 'android.permission.MODIFY_AUDIO_SETTINGS'),
  PermissionData(name: 'System Alert Window', permission: 'android.permission.SYSTEM_ALERT_WINDOW'),
  PermissionData(name: 'Write Call Log', permission: 'android.permission.WRITE_CALL_LOG'),
  PermissionData(name: 'Read Browser History', permission: 'com.android.browser.permission.READ_HISTORY_BOOKMARKS'),
  PermissionData(name: 'Vibrate', permission: 'android.permission.VIBRATE'),
  PermissionData(name: 'Get Tasks', permission: 'android.permission.GET_TASKS'),
  PermissionData(name: 'Read User Dictionary', permission: 'android.permission.READ_USER_DICTIONARY'),
  PermissionData(name: 'Access Coarse Location', permission: 'android.permission.ACCESS_COARSE_LOCATION'),
  PermissionData(name: 'Write Secure Settings', permission: 'android.permission.WRITE_SECURE_SETTINGS'),
  PermissionData(name: 'Read Sync Settings', permission: 'android.permission.READ_SYNC_SETTINGS'),
  PermissionData(name: 'Write Sync Settings', permission: 'android.permission.WRITE_SYNC_SETTINGS'),
  PermissionData(name: 'Read Social Stream', permission: 'android.permission.READ_SOCIAL_STREAM'),
  PermissionData(name: 'Read Sync Statistics', permission: 'android.permission.READ_SYNC_STATS'),
  PermissionData(name: 'Write Social Stream', permission: 'android.permission.WRITE_SOCIAL_STREAM'),
  ];

  final pm = AndroidPackageManager();

  @override
  void initState() {
    super.initState();
    pm.getInstalledApplications().then(
          (value) => setState(
            () => _applicationInfoList = value,
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text('PermMan'),
      ),
      body: ListView(
        children: _permissionData.map((data) {
          return ListTile(
            title: Text(data.name),
            onTap: () {
              _navigateToAppListPage(context, data.permission);
            },
          );
        }).toList(),
      )
    );
  }

  void _navigateToAppListPage(BuildContext context, String permission) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppListPage(permission: permission),
      ),
    );
  }
}

class PermissionData {
  final String name;
  final String permission;

  PermissionData({
    required this.name,
    required this.permission,
  });
}
