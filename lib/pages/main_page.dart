// Importaciones necesarias para el funcionamiento del código
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';

// Importación de la clase de servicios de Websockets
import '../services/websockets.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Instancia de la clase WebSocket para manejar la conexión por Websockets
  final WebSocket _socket = WebSocket("ws://192.168.1.37:5000");

  bool _isConnected = false;

  // Método para conectar al servidor a través de Websockets
  void connect(BuildContext context) async {
    _isConnected = await _socket.connect();
    log("Is connected? $_isConnected");

    // Actualizar el estado del widget para reflejar la conexión
    setState(() {
      //_isConnected = _isConnected;
    });
  }

  // Método para desconectar del servidor Websockets
  void disconnect() {
    _socket.disconnect();

    // Actualizar el estado del widget para reflejar la desconexión
    setState(() {
      _isConnected = false;
    });
  }

  // Construcción de la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebSocket DroneStream"),
        backgroundColor: Colors.deepPurple[300],
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: !_isConnected,
                          child: ElevatedButton(
                            onPressed: () => connect(context),
                            child: const Text("Conectar"),
                          ),
                        ),
                        //const SizedBox(width: 10),
                        Visibility(
                          visible: _isConnected,
                          child: ElevatedButton(
                            onPressed: disconnect,
                            child: const Text("Desconectar"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  // StreamBuilder para recibir y mostrar el video del dron
                  _isConnected
                      ? StreamBuilder(
                          stream: _socket.stream,
                          builder: (context, snapshot) {
                            // Si no hay datos, mostrar un indicador de carga
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }

                            // Si la conexión está terminada, mostrar un mensaje
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return const Center(
                                child: Text("Conexión terminada"),
                              );
                            }

                            // Mostrar la imagen recibida a través de Websockets
                            return Image.memory(
                              Uint8List.fromList(
                                base64Decode(
                                  (snapshot.data.toString()),
                                ),
                              ),
                              gaplessPlayback: true,
                              excludeFromSemantics: true,
                            );
                          },
                        )
                      : const Text("Iniciar conexión")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
