import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionManager {
  static final ConnectionManager _instance = ConnectionManager._internal();

  factory ConnectionManager() {
    return _instance;
  }

  ConnectionManager._internal();

  bool _hasInternetConnection = false;
  Timer? _timer;

  Future<void> checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    
    print("Resultado de la verificación de conexión: $connectivityResult");
    
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      _hasInternetConnection = true;
    // print("Hay conexión a internet");
    } else {
      _hasInternetConnection = false;
    // print("No hay conexión a internet");
    }
  }

  void startPeriodicCheck() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => checkInternetConnection());
  }

  void stopPeriodicCheck() {
    _timer?.cancel();
  }

  bool get hasInternetConnection => _hasInternetConnection;

  static ConnectionManager getInstance() {
    return ConnectionManager();
  }

  void checkAndShowAlert(BuildContext context) async {
    await checkInternetConnection();
    if (!_hasInternetConnection) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Advertencia'),
            content: const Text('La aplicación requiere conexión a internet.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Entendido'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  exit(0);
                },
              ),
            ],
          );
        },
      ).whenComplete(() => Navigator.of(context).pop());
    }
  }
}

