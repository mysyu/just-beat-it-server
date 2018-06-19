# just-beat-it-server

※ Environment:

1. MySQL Ver 14.14 Distrib 5.7.18
   - https://www.mysql.com/downloads/
2. python 2.7.13
   - https://www.python.org/downloads/

※ Python Package Needed:

1. pip
2. mysql-connector-python
   - pip install mysql-connector-python

※ Other needed:

1. mysql connector for python version 2.x (not 3.x)
   - https://dev.mysql.com/downloads/connector/python/
2. git

※ Configuration Setting:

1. Change the correct IP address in server.py line 8
2. Change the correct MySQL server url in server.py line 9
3. Remember to open the firewall on port 981 for socket and port for MySQL

※ Setup:

1. Clone just-beat-it-server from git with url: https://github.com/mysyu/just-beat-it-server
2. Download, install and set up the environment path variable for MySQL
3. Open cmd and change current dir to just-beat-it-server project folder
4. Excute cmd to import db: mysql -u [root] -p < jbit.sql
5. Download, install and set up the environment path variable for python
6. Download and install mysql connector for python version 2.x with specific OS version
7. Install pip, mysql-connector-python
8. Excute server with cmd: python just-beat-it-server.py
