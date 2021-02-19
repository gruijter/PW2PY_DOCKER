# Plugwise-2-py as a rpi4 image

For people who want to install a rpi4 from scratch, this image file can be used to create a SD card. It has Raspberry Pi OS 32bit with desktop included (version January 11th 2021).

## Step 1. Burn the img on an SD card
Burn the img on a SD card (16GB or larger). You can use Balena Etcher to do this: https://www.balena.io/etcher/

## Step 2. Insert the SD card, connect Ethernet and Plugwise stick
* Insert the SD card in your rpi4.
* Connect the rpi to your router via Ethernet cable.
* Plug in the Plugwise stick.

IMPORTANT: Do not plug in any other USB device!

## Step 3. Power up the rpi and remotely connect
After power up, check your router to find out the IP address of your rpi. Connect to the rpi from a PC in the same network. The username is `pi`, the password is `plugwise!`. There are two ways to remotely connect:

* Connect via SSH for a command line interface. https://mobaxterm.mobatek.net/
* Connect via VNC viewer for a desktop interface. https://www.realvnc.com/

## Step 4 (optional). Expand the file system
When you have an SD card larger than 16MB, you can make sure that the rpi can access all of the capacity of the SD card:
```
sudo rpi-config
```
6 > advanced options, A1 > Expand file system, Finish, Reboot > yes

## Step 5. Modify two config files
Modify two files so they contain all your circle adresses and the names for each circle.
In pw-conf.json set "loginterval": "60"
In pw-control.json set "monitor": "yes"

For detailed config instructions visit https://github.com/SevenW/Plugwise-2-py

Exit the editor with CTRL-x and save the file using the same name:
```
sudo nano /var/lib/docker/volumes/pw2py/_data/config/pw-conf.json
```
```
sudo nano /var/lib/docker/volumes/pw2py/_data/config/pw-control.json
```

## Step 6. Restart the pw2py container
```
sudo docker restart pw2py
```

Plugwise-2-py is now starting for the first time with your circle configuration. It will start collecting the power history from all your circles. THIS CAN TAKE SEVERAL HOURS!!! How long it takes depends on the number of circles and the quality of the connection between circles. 30 minutes per circle is not uncommon. During that time controlling circles can be very slow, and the actual power usage can show erratic numbers. To follow the progress you can do:
```
sudo docker exec -t pw2py tail -F /home/pi/pw2py_host/pwlog/pw-logger.log
```

# Step 5. Enjoy Plugwise-2-py
Open a webbrowser on a PC within the same network as your rpi.

To control the circles: `http://<ip.of.your.rpi>:8000`

To manage the circles: `http://<ip.of.your.rpi>:8000/cfg-pw2py.html`

To control via a MQTT client within the same network as your rpi `<ip.of.your.rpi>:1883`


