import serial
import time

# esp8266 outputs this at the beginning for some reason...
# ser = serial.Serial('/dev/ttyUSB0', 76800, timeout=2.5)
ser = serial.Serial('/dev/ttyUSB0', 115200, timeout=2.5)
while True:
    cmd = raw_input("> ");
    ser.write(cmd + "\r\n")
    ret = ser.read(len(cmd)) # eat echo
    time.sleep(0.2)
    while (ser.inWaiting()):
        ret = ser.readline().rstrip()
        print(ret)
