# Plugwise-2-py in a container

Install Plugwise-2-py including a MQTT server on a raspberry pi within a few minutes!
Plugwise-2-py is a tool to monitor and control Plugwise circles via a webinterface and/or via MQTT. For a full description visit https://github.com/SevenW/Plugwise-2-py

## What you need:
* An ARM based device with 64bit OS. (The docker image was created and tested on a Rapberry Pi with Raspbian OS 64 bit).
* A list of all your plugwise circle mac-addresses
* The plugwise USB stick in one of the USB ports (Important: NO OTHER USB DEVICES PLUGGED IN)
* Port 8000 (PW2Py webserver) is free to use on the Rpi
* Port 1883 (MQTT broker) is free to use on the Rpi, when you don't have an existing MQTT broker
* Able to start the console (terminal) and copy-paste the instructions below

## Installation steps:

## Step 0. Install Docker
For Raspbian OS see instructions here: https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script


## Step 1 (optional). Run an MQTT broker in docker
If you already have an MQTT broker, you can skip this step.

Create a config file:
```
mkdir -p $HOME/mosquitto/config && sudo chmod 775 -R $HOME/mosquitto && sudo nano $HOME/mosquitto/config/mosquitto.conf
```

Put this in the mosquitto.conf file:
```
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log
listener 1883 0.0.0.0

## Authentication ##
allow_anonymous true
```
Exit the editor with CTRL-x and save the file.

Now run the container:
```
sudo docker run --name mosquitto -dt --restart=unless-stopped -p 1883:1883 -p 9001:9001 -v $HOME/mosquitto/:/mosquitto/ eclipse-mosquitto
```

## Step 2. Run Plugwise-2-py in docker
Make sure you have the Plugwise stick in one of the USB ports, and no other USB devices plugged in!
```
sudo docker run -d --name pw2py --restart=always \
  --device=/dev/ttyUSB0 \
  -p 8000:8000 \
  -v $HOME/pw2py:/home/pw2py/ \
  gruijter/pw2py
```

## Step 3 (optional). Configure Plugwise-2-py MQTT settings
If you used the MQTT broker setup as described in step 1, you can skip this step. Otherwise you need to configure the mqtt connection settings.

```
sudo nano $HOME/pw2py/config/pw-hostconfig.json
```
Change the corresponding info to match that of your MQTT broker:
```
  "mqtt_ip":"127.0.0.1",
  "mqtt_port":"1883",
  "mqtt_user": "",
  "mqtt_password": "",
```
Exit the editor with CTRL-x and save the file.


## Step 4. Configure Plugwise-2-py circle settings

Modify two files so they contain all your circle adresses and the names for each circle.
For detailed config instructions visit https://github.com/SevenW/Plugwise-2-py

Modify circle addresses and names. Modify "loginterval": "5"
```
sudo nano $HOME/pw2py/config/pw-conf.json
```
Exit the editor with CTRL-x and save the file


Modify circle addresses and names. Modify "monitor": "yes"
```
sudo nano $HOME/pw2py/config/pw-control.json
```
Exit the editor with CTRL-x and save the file.


## Step 5. Restart the pw2py container
```
sudo docker restart pw2py
```

Plugwise-2-py is now starting for the first time with your circle configuration. It will start collecting the power history from all your circles. THIS CAN TAKE SEVERAL HOURS!!! How long it takes depends on the number of circles and the quality of the connection between circles. 30 minutes per circle is not uncommon. During that time controlling circles can be very slow, and the actual power usage can show erratic numbers. To follow the progress you can do:
```
sudo docker exec -t pw2py tail -F /home/pw2py/pwlog/pw-logger.log
```

# Step 6. Enjoy Plugwise-2-py
Open a webbrowser on a PC within the same network as your rpi.

To control the circles: `http://<ip.of.your.rpi>:8000`

To manage the circles: `http://<ip.of.your.rpi>:8000/cfg-pw2py.html`

To control via an MQTT client `<ip.of.your.broker>:1883`



