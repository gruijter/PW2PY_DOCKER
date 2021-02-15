# Plugwise-2-py in a container

Install Plugwise-2-py including a MQTT server on a raspberry pi within a few minutes!
Plugwise-2-py is a tool to monitor and control Plugwise circles via a webinterface and/or via MQTT. For a full description visit https://github.com/SevenW/Plugwise-2-py

## What you need:
* A Rapberry Pi (the docker image is tested on a Rpi4 with Raspbian OS 32 bit)
* A list of all your plugwise circle mac-addresses
* The plugwise USB stick in one of the USB ports (Important: NO OTHER USB DEVICES PLUGGED IN)
* Port 8000 (PW2Py webserver) and port 1883 (MQTT server) are free to use on the Rpi
* Able to start the console (terminal) and copy-paste the instructions below


## Installation steps:

## Step 1. Install Docker and create a persistent volume
```sudo apt update && sudo apt install docker```

```sudo docker volume create pw2py```

This will create a folder on your raspberry pi where data is stored and kept even when the docker container is stopped. After creation this folder can be found at `/var/lib/docker/volumes/pw2py`. If you ever want to redo an installation from scratch, you can clear all your data by using `sudo docker volume rm pw2py`.


## Step 2. Start the container with console output
Make sure you have the Plugwise stick in one of the USB ports, and no other USB devices plugged in.
```
sudo docker run --name pw2py --restart=always -it \
  --device=/dev/ttyUSB0 \
  -p 1883:1883 -p 8000:8000 \
  -v pw2py:/home/pi/pw2py_host/ \
  gruijter/plugwise-2-py
```

All is good if you eventually get this result:
```
* Starting network daemon: mosquitto        [ OK ]
nohup: redirecting stderr to stdout
nohup: redirecting stderr to stdout
```

## Step 3. Open a new console and modify two config files
Modify the two files so they contain all your circle adresses and the names for each circle.
In pw-conf.json set "loginterval": "60"
In pw-control.json set "monitor": "yes"

For detailed config instructions visit https://github.com/SevenW/Plugwise-2-py

Exit the editor with CTRL-x and save the file using the same name.
```
sudo nano /var/lib/docker/volumes/pw2py/_data/config/pw-conf.json
```
```
sudo nano /var/lib/docker/volumes/pw2py/_data/config/pw-control.json
```

## Step 4. Restart the pw2py container
```
sudo docker restart pw2py
```

# Step 5. Enjoy Plugwise-2-py
Open a webbrowser on a PC within the same network as your rpi.

To control the circles: `http://<ip.of.your.rpi>:8000`

To manage the circles: `http://<ip.of.your.rpi>:8000/cfg-pw2py.html`

To control via a MQTT client within the same network as your rpi `<ip.of.your.rpi>:1883`


