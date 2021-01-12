FROM ubuntu:18.04

# update apt
RUN apt update

# Install mosquitto
RUN apt install --no-install-recommends -y mosquitto

# Install Python3
RUN apt install -y --no-install-recommends python3  && apt install -y python3-pip

# Install Plugwise-2-py
RUN apt install --no-install-recommends -y git && git clone https://github.com/SevenW/Plugwise-2-py.git

WORKDIR /Plugwise-2-py
RUN pip3 install .

# Prepare volume for config files and logs
RUN mkdir -p /home/pi/pw2py_host/config && mkdir /home/pi/pw2py_host/datalog && mkdir /home/pi/pw2py_host/pwlog
# VOLUME /home/pi/pw2py_host

# copy default config and startup script
COPY pw-hostconfig.json /Plugwise-2-py/config-default
COPY start.sh /Plugwise-2-py
RUN chmod +x /Plugwise-2-py/start.sh

# remove pip and git python3-pip
RUN apt remove -y git && apt remove -y python3-pip && apt autoremove -y

# expose default ports
EXPOSE 8000 1883

ENTRYPOINT [ "/bin/bash" ]
CMD [ "/Plugwise-2-py/start.sh" ]
