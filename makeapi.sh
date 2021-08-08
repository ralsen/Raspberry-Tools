#!/bin/bash

echo ---------------------------------------------------------------------------
echo ich versuche jetzt '('fast')' vollautomatisch einen schicken Raspberry-Pi
echo zu basteln. Es werden ein paar Dateien vom Family-Server geholt dafür
echo muss dann das Password eingetippt werden.
echo los gehts ...
echo ---------------------------------------------------------------------------

echo --- erstmal wird das System auf den neuesten Stand gebracht
read -p "kann es losgehen? dann drücke ENTER"
sudo apt-get update && sudo apt-get upgrade -y 

echo --- erstmal ein paar Tools
read -p "bist du bereit, dann drücke ENTER"
sudo apt-get install mc --assume-yes
sudo apt-get install iftop --assume-yes
sudo apt-get install screen --assume-yes
sudo apt-get install lsof --assume-yes
sudo apt-get install tcpdump --assume-yes
sudo apt-get install cpufrequtils --assume-yes
sudo apt-get install librrd-dev libpython3-dev --assume-yes
sudo apt-get install avahi-utils --assume-yes
sudo apt install php-xml --assume-yes
sudo apt-get install sendemail libio-socket-ssl-perl libnet-ssleay-perl --assume-yes
sudo apt-get install python3-pip  --assume-yes
sudo apt-get install rrdtool --assume-yes
pip3 install rrdtool
pip3 install python-crontab
sudo apt-get install apache2 --assume-yes
sudo apt-get install php --assume-yes

echo
echo --- so das hätten wir
echo
echo --- jetzt werden ein paar Dateien vom Server geholt
echo --- dazu bitte ein paar Mal das Password eingeben
read -p "kann es weitergehen? dann drücke ENTER"
scp -p pi@192.168.1.28:/home/pi/*crontab* /home/pi
scp -p pi@192.168.1.28:/home/pi/installSambaServer.sh /home/pi
scp -p pi@192.168.1.28:/home/pi/bksdx.sh /home/pi
scp -p pi@192.168.1.28:/home/pi/smb.conf /home/pi
scp -p pi@192.168.1.28:/home/pi/bitu.sh /home/pi
sudo scp -p pi@192.168.1.28:/usr/local/bin/i.sh /usr/local/bin
echo
echo --- auch das haben wir hinter uns
echo
echo --- jetzt wird noch versucht Samba und Dropbox zu installieren
read -p "letzten Schritt starten? dann drücke ENTER"
sudo ./installSambaServer.sh
sudo apt install curl git
git clone https://github.com/andreafabrizi/Dropbox-Uploader.git
echo 
echo ---------------------------------------------------------------------------
echo folgende Restarbeiten sind zu machen:
echo -	In .bashrc ein paar aliases einkommentieren z.B. ll usw.
echo -	Wenn I²C, SPI, oder 1-Wire benötigt werden müssen die aktiviert werden
echo - 	die kopierte scmb.conf anpassen und nach /etc/samba kopieren
echo -	es leigen ein paar crontabs bereit, die richtige ist noch auszuwählen
echo	und anzupassen
echo -	 im .bashrc History ggf. auf 10000 und 20000 setzen
echo -  es liegen ein paar bksd*.sh-Dateien bereit, welche ist richtig?
echo -	funktionsspezifische Dateien für diesen Rechner sind evtl. 
echo	noch zu kopieren. z.B.:
echo		wird minidlna benötigt?
echo		all.sh
echo		clean.sh
echo		arch.sh
echo		gettouttemp.*
echo		rrd, Grafik und sonstwas erzeugen?
echo -	Berechtigungen anpassen z.B.:
echo		/var/www/html
echo		pi@TestServ:~/samba/Daten/Projekte/Raspberry/ServESP/Scenes
echo		 $ sudo chmod 0777 *.sh
echo		im /home/pi/ alle .sh ausführbar machen
echo		und vielleicht noch ein paar !?!?
echo - 	Dropbox ist noch zu configurieren siehe:
echo	https://pimylifeup.com/raspberry-pi-dropbox/
echo
echo jetzt einmal herunterfahren und neu starten sudo reboot
echo jetzt wäre auch der Zeitpunkt dieses Image auf eine 2. Sd-Karte 
echo mit bksd*.sh zu packen
echo 
echo ---------------------------------------------------------------------------
