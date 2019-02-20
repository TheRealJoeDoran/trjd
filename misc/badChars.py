#!/usr/bin/python
import sys

sys.stdout.flush()
sys.stdout.write('badChar = ""\r\n')
for i in range(16):
	sys.stdout.write('badChar = "')
	for j in range(16):
		if i==0:
			sys.stdout.write( hex((i*16)+j).replace("0x","\\x0") )
		else:
			sys.stdout.write( hex((i*16)+j).replace("0x","\\x") )
	sys.stdout.write('"\r\n')
sys.stdout.flush()
