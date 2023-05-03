# set working directory
cd /usr/src/Plugwise-2-py

# Create folders on host if needed
mkdir -p /home/pw2py/config
mkdir /home/pw2py/datalog
mkdir /home/pw2py/pwlog
chmod -R 777 /home/pw2py

# copy config files to host if needed
cp -n config-default/pw-hostconfig.json /home/pw2py/config
cp -n config-default/pw-control.json /home/pw2py/config
cp -n config-default/pw-conf.json /home/pw2py/config

# copy config files from host to pw2py config
cp /home/pw2py/config/pw* config/

# start pw2py
nohup python Plugwise-2.py >>/home/pw2py/pwlog/pwout.log&
nohup python Plugwise-2-web.py >>/home/pw2py/pwlog/pwwebout.log&

# keep container running
wait

