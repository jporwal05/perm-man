import 'dart:ffi';
import 'dart:typed_data';

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
  late List<ApplicationInfo> _filteredApps = [];

  @override
  void initState() {
    super.initState();
    _getInstalledApps();
  }

  Future<void> _getInstalledApps() async {
    final pm = AndroidPackageManager();

    final installedApps = await pm.getInstalledApplications();

    final futures = installedApps!.map((app) => _hasPermission(app));
    final results = await Future.wait(futures);

    final filteredApps = <ApplicationInfo>[];
    for (int i = 0; i < installedApps!.length; i++) {
      if (installedApps![i].enabled && results[i] == CheckPermissionStatus.granted) {
        filteredApps.add(installedApps[i]);
      }
    }

    setState(() {
      _installedApps = installedApps;
      _filteredApps = filteredApps;
    });
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
                return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                    ),
                    child: ListTile(
                      leading: SizedBox.square(
                        dimension: 48.0,
                        child: FutureBuilder<Uint8List?>(
                          future: appInfo.getAppIcon(),
                          builder: (context, snapshot,) {
                            if (snapshot.hasData) {
                              final iconBytes = snapshot.data!;
                              return Image.memory(
                                iconBytes,
                                fit: BoxFit.fill,
                              );
                            }
                            if (snapshot.hasError) {
                              return const Icon(Icons.error, color: Colors.red,);
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      title: Text(
                          appInfo.name ?? appInfo.packageName ?? 'No name'),
                    ));
              },
            )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
