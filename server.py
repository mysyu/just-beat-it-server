import mysql.connector as DB
import thread
import socket
import game

class Server:
    def __init__(self):
        self.addr = ('mysyu.ddns.net', 981)
        self.db = DB.connect(host='mysyu.ddns.net', user='jbit', passwd='jbit', db='jbit', charset='utf8')
        self.cursor = self.db.cursor()
        self.games = dict()

    def start(self):
        thread.start_new_thread(self.scan,())
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.bind(self.addr)
        print 'Server Start'
        self.socket.listen(1000)
        while True:
            thread.start_new_thread(self.connect, self.socket.accept())

    def scan(self):
        while True:
            self.cursor.execute('select p1,p2,p3,p4 from room where play=1')
            for record in self.cursor:
                players = [str(item) for item in record if item != None and len(item) != 0]
                if not self.games.has_key(players[0]):
                    self.games[players[0]] = game.Game(self.games, players[0], players)
            self.db.commit()

    def connect(self, client , addr):
        try:
            print addr
            message = client.recv(1024)
            print message, len(message)
            if message.startswith('JOIN:'):
                detail = message[5:].split(":")
                if self.games.has_key(detail[0]):
                    self.games[detail[0]].join(client, detail[1])
                else:
                    client.send('NO')
        except Exception as ex:
            print ex.message
