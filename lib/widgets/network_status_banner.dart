// lib/widgets/network_status_icon.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatusIcon extends StatefulWidget {
  const NetworkStatusIcon({super.key});

  @override
  State<NetworkStatusIcon> createState() => _NetworkStatusIconState();
}

class _NetworkStatusIconState extends State<NetworkStatusIcon> {
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((status) {
      setState(() {
        _isOffline = status == ConnectivityResult.none;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      _isOffline ? Icons.cloud_off : Icons.cloud_done,
      color: _isOffline ? Colors.red : Colors.green,
      size: 26,
    );
  }
}
