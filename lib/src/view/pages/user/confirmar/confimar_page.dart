import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/src/controller/confirmar_controllerdart.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';

class ConfimarPage extends StatefulWidget {
  const ConfimarPage({super.key});

  @override
  State<ConfimarPage> createState() => _ConfimarPageState();
}

class _ConfimarPageState extends State<ConfimarPage> {
  final ConfirmarController _con = ConfirmarController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primaryOpacityColor,
        title: const Text(
          'Corfirme su cuenta',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _bottomConfirmar(),
        ],
      ),
    );
  }

  Widget _bottomConfirmar() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50),
      padding:const EdgeInsets.only(top: 10),
      child: ElevatedButton(
          onPressed: _con.confirmar,
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColor.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text('Confirme', style: TextStyle(color: Colors.white))),
    );
  }
}
