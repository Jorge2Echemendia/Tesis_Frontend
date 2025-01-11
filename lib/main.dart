import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/connection_manager.dart';
import 'package:flutter_application_3/firebase_options.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/provider/push_notifications_provider.dart';
import 'package:flutter_application_3/src/provider/users_provider.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';
import 'package:flutter_application_3/src/view/pages/configuracion/configuracion_page.dart';
import 'package:flutter_application_3/src/view/pages/historial/historial_page.dart';
import 'package:flutter_application_3/src/view/pages/home/home_page.dart';
import 'package:flutter_application_3/src/view/pages/notas/notas_paciente.dart';
import 'package:flutter_application_3/src/view/pages/patient/paciente_page.dart';
import 'package:flutter_application_3/src/view/pages/tratamiento/tratamiento_page.dart';
import 'package:flutter_application_3/src/view/pages/user/confirmar/confimar_page.dart';
import 'package:flutter_application_3/src/view/pages/user/editar_usuario/editar_user_pade.dart';
import 'package:flutter_application_3/src/view/pages/user/login/login_page.dart';
import 'package:flutter_application_3/src/view/pages/user/olvidecontrase%C3%B1a/olvide_password_page.dart';
import 'package:flutter_application_3/src/view/pages/user/registro/register_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

PushNotificationsProvider pushNotificationsProvider =
    PushNotificationsProvider();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  pushNotificationsProvider.initNotification();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
  await pushNotificationsProvider.handleBackgroundMessag(message);
}

Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
  PushNotificationsProvider().handleBackgroundMessages();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ConnectionManager connectionManager;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pushNotificationsProvider.onMessageListener();
    pushNotificationsProvider.initNotification();
    pushNotificationsProvider.handleBackgroundMessages();
    connectionManager = ConnectionManager();
    connectionManager.startPeriodicCheck();
  }
  

  @override
  void dispose() {
    connectionManager.stopPeriodicCheck();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UsersProvider(),
      child: MaterialApp(
          title: 'Bienvenido a su oftalmólogo virtual',
          debugShowCheckedModeBanner: false,
          color: const Color.fromARGB(255, 16, 117, 167),
          initialRoute: 'home',
          routes: {
            'home': (BuildContext context) => const HomePage(),
            'login': (BuildContext context) => const LoginPage(),
            'olvidepassword': (BuildContext context) => const OlvidePasswordPage(),
            'register': (BuildContext context) => const RegisterPage(),
            'editaruser': (BuildContext context) => const EditarUserPade(),
            'paciente': (BuildContext context) => const PacientePage(),
            'tratamiento': (BuildContext context) => const TratamientoPage(),
            'confirmar': (BuildContext context) => const ConfimarPage(),
            'configuracion': (BuildContext context) => const ConfiguracionPage(),
            'historial': (BuildContext context) => const HistorialPage(
                  historial: [],historialNotas: [],),
            'notas':(BuildContext context) => NotasPaciente(notas: const [],paciente:Paciente(nombre: '', apellido: '', apellidoSegundo: '', fechaNacimiento: DateTime.now(), afeccion: '', etapaDeTratamiento: '', lente: false, parche: false, tipoLente: '', tipoParche: '', horasParche: '', observacionesParche: '', fechaParche:  DateTime.now(), graduacionLente: '', fechaLente:  DateTime.now(), fechaDiagnostico:  DateTime.now(), gradoMiopia: '', examenes: '', recomendaciones: '', correccionOptica: '', ejerciciosVisuales: '', cambioOptico: '', consejosHigiene: '', cirujia: '', cirujiaFecha:  DateTime.now(), cirujiaResultados: '', progreso: '')),
                
          },
          theme: ThemeData(
            //fontFamily: 'NimbusSans',
            primaryColor: MyColor.primaryColor,
          )),
    ); 
  }
}
