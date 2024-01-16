# Websockets DroneStream

## Descripción
Esta aplicación utiliza Websockets para recibir en tiempo real contenido multimedia desde un cliente externo, simulado en el archivo _DummyServer.py_.

## Instalación

**Paso 1:**

Descarga o clona este repositorio usando el siguiente enlace:
```
https://github.com/IbrahimRuben/dronestream.git
```

**Paso 2:**

Ve a la carpeta raíz del proyecto y ejecuta el siguiente comando en la consola para obtener las dependencias necesarias:

```
flutter pub get
```

**Paso 3:**

Ejecuta la aplicación con el siguiente comando en la consola:

```
flutter run lib/main.dart
```

> [!IMPORTANT]
> Recuerda seleccionar el dispositivo en el que desees ejecutar la aplicación.


# Guía de uso

- El primer paso consiste en ejecutar el archivo _DummyServer.py_ para inicializar el WebSocket y esperar a una conexión.
- Una vez completado este paso, en nuestra aplicación pulsaremos el botón "Conectar" para establecer una conversación entre nuestra aplicación y nuestro _DummyServer.py_. Una vez conectado, después de un breve periodo de tiempo, comenzaremos a recibir imágenes desde el WebSocket.
- Para desconectarnos, haremos clic en el botón "Desconectar". También podemos presionar _CTRL+C_ en la terminal en la que se está ejecutando el _DummyServer.py_ para cerrar esta conexión. Hacer esto no cerrará el WebSocket; para ello, tendremos que volver a presionar _CTRL+C_.
