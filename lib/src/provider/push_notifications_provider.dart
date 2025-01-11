import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/src/config/config.dart';
import 'package:flutter_application_3/src/model/user.dart';
import 'package:flutter_application_3/src/provider/users_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;


class PushNotificationsProvider {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static const Duration _tokenRefreshInterval = Duration(days: 30);
  late User currentUser;
  

  void initNotification() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ));

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void onMessageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'ojo',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Mensaje abierto: ${message.data}');
      // Maneja el evento según sea necesario
    });
  }

  void saveToken(BuildContext context, User user) async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("Device Token: $token");
    UsersProvider usersProvider = UsersProvider();
    await usersProvider.init(context, useroriginal: user);
    await usersProvider.updateNotificacionToken(user.id!, token!);
  }



  Future<String?> refreshToken() async {
    final now = DateTime.now();
    final expiration =
        now.subtract(const Duration(hours: 1)); // 1 hora antes de expirar

    if (now.isBefore(expiration)) {
      return null; // No necesita ser renovado
    }

    final credentials = await getServerAccessToken();

    final newToken = await FirebaseMessaging.instance.getToken();
    UsersProvider usersProvider = UsersProvider();
    if (newToken != null) {
      await usersProvider.updateNotificacionToken(currentUser.id!, newToken);
    }

    return credentials;
  }

  static Future<String> getServerAccessToken() async {
    final serviceAccountJson = {
      "type": Config.firebaseType,
      "project_id": Config.projectId,
      "private_key_id": Config.privateKeyId,
      "private_key": Config.privateKey.replaceAll(r'\n', '\n'), // Reemplazar \n por saltos de línea
      "client_email": Config.clientEmail,
      "client_id": Config.clientId,
      "auth_uri": Config.authUri,
      "token_uri": Config.tokenUri,
      "auth_provider_x509_cert_url": Config.authProviderCertUrl,
      "client_x509_cert_url": Config.clientCertUrl,
      "universe_domain": Config.universeDomain
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.messaging",
      "https://www.googleapis.com/auth/firebase.database",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);
    client.close();
    return credentials.accessToken.data;
  }

  Future<void> sendMessage(
      String to, Map<String, dynamic> data, String title, String body) async {
    try {
      const projectID = 'tesis-f0a5e';

      // Obtener el token de acceso
      final accessToken = await getServerAccessToken();

      Uri uri = Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectID/messages:send');

      final jsonPayload = json.encode({
        "message": {
          "token": to,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": data,
        }
      });

      print('Intentando enviar mensaje a $to');
      print('Payload: $jsonPayload');
      print('Token: $accessToken');

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonPayload,
      );

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw Exception(
            'Error al enviar mensaje: ${responseData['error']['message']}');
      }

      print('Mensaje enviado exitosamente');

      logEvent('SendMessage',
          details: {'recipient': to, 'message': '$response'});
    } on SocketException catch (_) {
      print('Error de conexión');
    } on FormatException catch (_) {
      print('Error de formato');
    } catch (e) {
      print('Error desconocido: $e');
    }
    // Aquí puedes implementar lógica adicional para manejar errores persistentes
  }

  static void logEvent(String eventName, {Map<String, dynamic>? details}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final logEntry = {
      'timestamp': timestamp,
      'event': eventName,
      'details': details ?? {}
    };

    print(jsonEncode(logEntry));
  }

  void periodicTokenRefresh() {
    Timer.periodic(_tokenRefreshInterval, (timer) async {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await UsersProvider().updateNotificacionToken(currentUser.id!, token);
      }
    });
  }

      Future<void> _showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'ojo',
          ),
        ),
      );
    }
  }




  void handleBackgroundMessages() {
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessag);
  }
  

  Future<void> handleBackgroundMessag(RemoteMessage message) async {
    await _showNotification(message);
  }
  
}
