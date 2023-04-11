import 'package:flutter/material.dart';
import 'package:android_package_manager/android_package_manager.dart';

class AppListPage extends StatefulWidget {
  final String permission;

  AppListPage({required this.permission});

  @override
  _AppListPageState createState() => _AppListPageState();
}

class _AppListPageState extends State<AppListPage> {
  List<ApplicationInfo>? _installedApps;
  late final List<ApplicationInfo> _filteredApps = [];

  @override
  void initState() {
    super.initState();
    _getInstalledApps();
  }

  Future<void> _getInstalledApps() async {
    final pm = AndroidPackageManager();
    ApplicationInfoFlags flags = ApplicationInfoFlags({
      PMFlag.getPermissions,
      PMFlag.getMetaData,
    });
    List<ApplicationInfo>? installedApps =
        await pm.getInstalledApplications(flags: flags);
    setState(() {
      _installedApps = installedApps;
    });
    for (int i = 0; i < _installedApps!.length; i++) {
      _hasPermission(_installedApps![i]).then((status) => {
            if (_installedApps![i].enabled &&
                status == CheckPermissionStatus.granted)
              {
                setState(() {
                  _filteredApps.add(_installedApps![i]);
                })
              }
          });
    }
  }

  Future<CheckPermissionStatus?> _hasPermission(ApplicationInfo app) async {
    final pm = AndroidPackageManager();
    CheckPermissionStatus? status = await pm.checkPermission(
        packageName: app.packageName!, permName: widget.permission);
    return status ?? CheckPermissionStatus.denied;
  }

  void _removePermission(ApplicationInfo app) async {
    final pm = AndroidPackageManager();
    CheckPermissionStatus? status =
    await pm.checkPermission(packageName: app.packageName!, permName: widget.permission);
    if (status == CheckPermissionStatus.granted) {
      pm.removePermission(widget.permission);
    }
    _getInstalledApps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.permission.split('.').last} Permissions'),
      ),
      body: _installedApps != null
          ? ListView.builder(
        itemCount: _filteredApps.length,
        itemBuilder: (context, index) {
          ApplicationInfo appInfo = _filteredApps[index];
          return ListTile(
            title: Text(appInfo.name ?? 'No name'),
          );
        },
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
