#!/usr/bin/env python

import sys
import socket

argc = len(sys.argv)
if argc < 2 or sys.argv[1] == 'help' or sys.argv[1] == '--help':
    print 'usage:   mao <command>\n'
    print 'lock    lock screen'
    print 'exit    exit remote server'
    sys.exit(0)

serverIp = '10.60.113.131'
serverPort = 5263
cmd = sys.argv[1]

MAO_HEAD = [0x23, 0x4d, 0x41, 0x4f]
MAO_HEAD_LEN = len(MAO_HEAD)


def create_head(msg_len):
    head = bytearray(8)
    for i in range(MAO_HEAD_LEN):
        head[i] = MAO_HEAD[i]
    for i in range(4):
        head[i + MAO_HEAD_LEN] = (msg_len >> (i * 8) & 0xff)
    return head


address = (serverIp, serverPort)
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.settimeout(1)
try:
    s.connect(address)
    s.send(create_head(len(cmd)))
    s.send(cmd)
    data = s.recv(512)
    print data
except socket.timeout:
    print 'exec command "{}" timeout, maybe the server({}:{}) is not running.'.format(cmd, serverIp, serverPort)

s.close()
