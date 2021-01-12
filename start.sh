service mosquitto start
sleep 3

cp -n config-default/pw-hostconfig.json /home/pi/pw2py_host/config
cp -n config-default/pw-control.json /home/pi/pw2py_host/config
cp -n config-default/pw-conf.json /home/pi/pw2py_host/config

cp /home/pi/pw2py_host/config/pw* config/

nohup python3 Plugwise-2.py >>/home/pi/pw2py_host/pwlog/pwout.log&
nohup python3 Plugwise-2-web.py >>/home/pi/pw2py_host/pwlog/pwwebout.log&

wait

