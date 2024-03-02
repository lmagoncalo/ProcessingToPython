from PIL import Image
import numpy as np

import socket


class MySocket:
    def __init__(self, host, port):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        self.sock.bind((host, port))
        self.sock.listen(5)
        print('SERVER STARTED RUNNING')

    def close(self):
        self.sock.close()
        print('END CONNECTION')


    def mysend(self, msg):
        msg = msg.encode("utf-8")
        self.client.send(msg)

    def myreceive(self):
        self.client, address = self.sock.accept()

        print(address)

        result = self.client.recv(1024)
        result = result.decode("utf-8")

        size = int(result)

        print("———————————————————————")
        print("size: " + str(size))

        msg = b''

        while len(msg) < size:
            msg_current = self.client.recv(size // 4)
            msg += msg_current

        image = np.frombuffer(msg, dtype=np.uint8)
        image = image.reshape((224, 224, 4))[:, :, 1:] #from (224, 224, 4) to (224, 224, 3)
        im = Image.fromarray(image)
        # Save the image received
        im.save("temp.png")

        respose = "Message obtained sucessefully"
        self.mysend(respose)
        

HOST = "localhost"
PORT = 9999

s = MySocket(HOST, PORT)

while True:
    try:
        s.myreceive()
    except KeyboardInterrupt:
        s.close()
        break




