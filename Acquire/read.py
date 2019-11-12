# * Copyright (C) Alain Bindele Kiesse,- All Rights Reserved
# * Unauthorized copying of this file, via any medium is strictly prohibited
# * Proprietary and confidential
# * Written by Alain Bindele Kiesse <alain.bindele@gmail.com>, Feb 2019
# * License to use this software is permitted to personally licensed persons:
# * only for purposes related to GreenSound Project (PC-go Project)
# * Version: 0.1
#
#  Directive:	Reads analog parameter from USB 
#				It uses read.py (in the same dir) to read from USB serial
#  Platform:	Works for UNIX Based systems (MacOS Linux etc.)



#!/usr/bin/python
import serial
import syslog
import time
import re
import sys

#The following line is for serial over GPIO
port = '/dev/ttyUSB0'


ard = serial.Serial(port,115200,timeout=5)


try: sys.argv[1]
except IndexError: nreads = 1000
else: nreads = int( sys.argv[1] )

try: sys.argv[2]
except IndexError: port='/dev/ttyUSB0'
else: port = sys.argv[2]

i = 0


while (i < nreads):
    # Serial read section
	#v = int(re.findall(r'\d+',ard.readline().decode("utf-8"))[0]) 
	v = int(re.findall(r'\d+',ard.readline().decode("ascii"))[0]) 
	if (v < 1024):
		print (v)
	 
	i = i + 1
exit()
