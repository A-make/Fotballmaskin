import sys
import serial
import random


class Arduino:
	def __init__(self,portname='COM8'):
		self.portname=portname
		self.port=serial.Serial(port=portname,baudrate=38400,parity=serial.PARITY_NONE,stopbits=serial.STOPBITS_ONE)

	def set_verticle(self,angle=0):
		if(angle > 80):
			angle = 80
		elif(angle < 0):
			angle = 0
		angle = chr(int(round(angle*3.1875)));
		self.write_arduino('s',angle)

	def set_ball_shooter_speed(self,speed=0):
		if(speed > 100):
			speed = 100
		elif(speed < 0):
			speed = 0
		speed = chr(int(round(speed*2.55)))
		self.write_arduino('l',speed)

	def write_arduino(self, tag, val):
		data = bytearray()
		data.extend(tag) #Start Tag
		data.extend(val) #Send value
		data.extend('\n') #End tag
	    
		check = self.port.write(data)
		if check is -1:
			print "Could not send data"
		elif check is 0:
			print "No data sendt"