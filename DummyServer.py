import time
import websockets
import asyncio

import cv2, base64

# Dirección y puerto en el que el servidor escuchará las conexiones
address = '192.168.1.37'
port = 5000
print("Started server on : ", address, "; Port :", port)

# Función asincrónica para transmitir video a través de Websockets
async def transmit(websocket, path):
    print("Client Connected !")
    try :
        # Inicializamos la captura de video desde la cámara (0 indica la cámara predeterminada)
        cap = cv2.VideoCapture(0)

        width = 1280
        height = 960
        fps = 60
        quality = 90
        
        # Declaramos resolucion de la cámara
        cap.set(3, width) # 3 -> Ancho de la imagen (Default: 640)
        cap.set(4, height) # 4 -> Altura de la imagen (Default: 480)
        cap.set(5, fps)  # 5 -> Frames por segundo (min 5fps, intervalos de 5, Default: 30 fps)
        
        # Consultamos la resolucion de la cámara y los FPS
        print(cap.get(3))
        print(cap.get(4))
        print(cap.get(5))
        
        # Empezamos un contador
        #st = time.time()
        
        #while time.time() - st < 1:
        while cap.isOpened():
            
            # Leemos un fotograma de la cámara
            _, frame = cap.read()
            
            # Codificamos el fotograma en formato JPG y definimos la calidad de compresión entre 0-100 (Default: 95)
            encoded = cv2.imencode('.jpg', frame, [int(cv2.IMWRITE_JPEG_QUALITY), quality])[1]

            # Convertimos la imagen codificada a base64
            data = str(base64.b64encode(encoded))
            data = data[2:len(data)-1]
            
            # Enviamos los datos al cliente a través del socket
            await websocket.send(data)
            print("Tamaño mensaje: ", len(data))
            
            # Descomenta las líneas siguientes si deseas mostrar la transmisión en el servidor
            #cv2.imshow("Transimission", frame)
            #if cv2.waitKey(1) & 0xFF == ord('q'):
            #    break
        
        # Liberamos la captura de video cuando se cierra la conexión    
        cap.release()

    # Manejo de excepciones para manejar desconexiones y otros errores
    except websockets.exceptions.ConnectionClosedError as e:
        print("Error! Client Disconnected !")
        cap.release()
    except websockets.exceptions.ConnectionClosed as e:
        print("Client Disconnected !")
        cap.release()
    except:
        print("Someting went Wrong !")

# Iniciamos el servidor de Websockets en la dirección IP y el puerto especificados
start_server = websockets.serve(transmit, host=address, port=port)

# Ejecutamos el bucle de eventos de asyncio para mantener el servidor en ejecución
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()