import sys
sys.path.append("..")
import pypibot
from pypibot import log

import serial
import threading
import struct
import time
from dataholder import MessageID, BoardDataDict
FIX_HEAD = 0x5a

class Recstate():
    WAITING_HD = 0
    WAITING_MSG_ID = 1
    RECEIVE_LEN = 2
    RECEIVE_PACKAGE = 3
    RECEIVE_CHECK = 4

def checksum(d):
    sum = 0
    for i in d:
        sum += ord(i)
        sum = sum&0xff
    return sum


class Transport:
    def __init__(self, port, baudrate=921600):
        self._Port = port
        self._Baudrate = baudrate
        self._KeepRunning = False
        self.receive_state = Recstate.WAITING_HD
        self.rev_msg = []
        self.rev_data = []
        self.wait_event = threading.Event()

    def getDataHolder(self):
        return BoardDataDict

    def start(self):
        try:
            self._Serial = serial.Serial(port=self._Port, baudrate=self._Baudrate, timeout=0.2)
            self._KeepRunning = True
            self._ReceiverThread = threading.Thread(target=self._Listen)
            self._ReceiverThread.setDaemon(True)
            self._ReceiverThread.start()
            return True
        except:
            return False

    def Stop(self):
        self._KeepRunning = False
        time.sleep(0.1)
        self._Serial.close()

    def _Listen(self):
        while self._KeepRunning:
            if self.receiveFiniteStates(self._Serial.read()):
                self.packageAnalysis()

    def receiveFiniteStates(self, s):
        if len(s) == 0:
            return  False
        val = s[0]
        if self.receive_state == Recstate.WAITING_HD:
            if ord(val) == FIX_HEAD:
                
                log.debug('got head')
                self.rev_msg = []
                self.rev_data =[]
                self.rev_msg.append(val)
                self.receive_state = Recstate.WAITING_MSG_ID
        elif self.receive_state == Recstate.WAITING_MSG_ID:
            log.debug('got msg id')
            self.rev_msg.append(val)
            self.receive_state = Recstate.RECEIVE_LEN
        elif self.receive_state == Recstate.RECEIVE_LEN:
            log.debug('got len:%d', ord(val))
            self.rev_msg.append(val)
            if ord(val) == 0:
                self.receive_state = Recstate.RECEIVE_CHECK
            else:
                self.receive_state = Recstate.RECEIVE_PACKAGE
        elif self.receive_state == Recstate.RECEIVE_PACKAGE:
            self.rev_data.append(val)
            if len(self.rev_data) == ord(self.rev_msg[-1]):
                self.rev_msg.extend(self.rev_data)
                self.receive_state = Recstate.RECEIVE_CHECK
        elif self.receive_state == Recstate.RECEIVE_CHECK:
            log.debug('got check')
            self.receive_state = Recstate.WAITING_HD
            if ord(val) == checksum(self.rev_msg):
                log.debug('got a complete message')
                return True
        else:
            self.receive_state = Recstate.WAITING_HD

        # continue receiving
        return False

    def packageAnalysis(self):
        in_msg_id = ord(self.rev_msg[1])
        log.debug(bytes(self.rev_data))
        if BoardDataDict[in_msg_id].unpack(''.join(self.rev_data)):
            self.res_id = in_msg_id
            if in_msg_id<100:
                self.set_response()
            else:#notify
                log.debug('msg %d'%self.rev_msg[4],'data incoming')
                pass
        else:
            log.debug ('error unpacking pkg')

    def request(self, id, timeout=0.5):
        if not self.write(id):
            log.debug ('Serial send error!')
            return False
        if self.wait_for_response(timeout):
            if id == self.res_id:
                log.debug ('OK')
            else:
                log.error ('Got unmatched response!')
        else:
            log.error ('Request got no response!')
            return False
        # clear response
        self.res_id = None
        return True

    def write(self, id):
        self._Serial.write(self.make_command(id))
        return True

    def wait_for_response(self, timeout):
        self.wait_event.clear()
        return self.wait_event.wait(timeout)

    def set_response(self):
        self.wait_event.set()

    def make_command(self, id):
        #print(DataDict[id])
        data = BoardDataDict[id].pack()
        l = [FIX_HEAD, id, len(data)]
        head = struct.pack("3B", *l)
        body = head + data
        return body + chr(checksum(body))


if __name__ == '__main__':

    mboard = Transport('com10')
    if not mboard.start():
        import sys
        sys.exit()

    p = mboard.request(MessageID.ID_GET_VERSION)
    log.i("result=%s"%p)
    print('Version =[',mboard.getDataHolder()[MessageID.ID_GET_VERSION].version.decode(), mboard.getDataHolder()[MessageID.ID_GET_VERSION].build_time.decode(),"]\r\n")


