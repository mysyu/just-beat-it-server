import mysql.connector as DB
import threading

class Game:
    def __init__(self,games,room,players):
        self.games = games
        self.room = room
        self.players = dict()
        self.score = {0:dict()}
        self.counting = threading.Lock()
        for id in players:
            self.players[id] = [False,0,dict()]
            self.score[0][id] = 0
    def join(self,client,id):
        if self.players.has_key(id):
            client.send('OK')
            self.communicate(client,id)
        else:
            client.send('NO')

    def communicate(self,client,id):
        while True:
            message = client.recv(1024)
            print message , len(message)
            if message == 'READY':
                self.players[id][0] = True
                for player in self.players.keys():
                    while not self.players[player][0]:
                        pass
                client.send('OK')
            elif message.startswith('BEAT:'):
                detail = message[5:].split(':')
                time , beat = int(detail[0]) , detail[1].split(',')
                if beat[0] == '':
                    beat = []
                self.players[id][2][time] = beat
                self.counting.acquire()
                if not self.score.has_key(time):
                    self.score[time] = dict()
                    bonus = [2, 1.5, 1, 1]
                    for player in self.players.keys():
                        while not self.players[player][2].has_key(time):
                            pass
                        self.score[time][player] = len(self.players[player][2][time]) // 2
                    sortKey = sorted(self.score[time], key=self.score[time].get, reverse=True)
                    for player in sortKey:
                        if player != sortKey[-1] and self.score[time][player] != self.score[time][
                            sortKey[sortKey.index(player) + 1]]:
                            self.score[time][player] = self.score[time - 5000][player] + int(
                                self.score[time][player] * bonus[0])
                            del bonus[0]
                        else:
                            self.score[time][player] = self.score[time - 5000][player] + int(
                                self.score[time][player] * bonus[0])
                self.counting.release()
                client.send(','.join([player + ',' + str(self.score[time][player]) for player in sorted(self.score[time], key=self.score[time].get, reverse=True)]))
            elif message.startswith('FINISH'):
                for player in self.players.keys():
                    for beat in self.players[player][2].values():
                        if len(beat) > 0:
                            client.send(player+','+','.join(beat))
                            client.recv(1024)
                client.send('FINISH')
            elif message == "CLOSE":
                client.close()
                if self.room == id:
                    self.games.pop(self.room)
                    db = DB.connect(host='mysyu.ddns.net', user='jbit', passwd='jbit', db='jbit', charset='utf8')
                    cursor = db.cursor()
                    cursor.execute("delete from room  where p1='%s' " % (id) )
                    db.commit()
                    cursor.close()
                    db.close()
                break
