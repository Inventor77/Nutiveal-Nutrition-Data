import time
import zmq

context = zmq.Context()
socket = context.socket(zmq.REP)
socket.bind("tcp://127.0.0.1:5555")

def read_file(filename):
    with open(f"{filename}") as f:
        data = f.read()
    return data

while True:
    message = socket.recv().decode('UTF-8')
    print("Received request: ", message)
    data = read_file(message)
    socket.send_string(data)