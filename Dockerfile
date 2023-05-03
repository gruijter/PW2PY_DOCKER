FROM python:3

WORKDIR /usr/src

# Install Plugwise-2-py
# RUN git clone https://github.com/SevenW/Plugwise-2-py.git
RUN git clone https://github.com/gruijter/Plugwise-2-py.git

WORKDIR /usr/src/Plugwise-2-py
RUN chmod -R 777 /usr/src/Plugwise-2-py
RUN pip install .
RUN chmod -R 777 /usr/src/Plugwise-2-py

# copy default config and startup script
COPY pw-hostconfig.json /usr/src/Plugwise-2-py/config-default
COPY start.sh /usr/src/Plugwise-2-py
RUN chmod +x /usr/src/Plugwise-2-py/start.sh

# expose default ports
EXPOSE 8000

ENTRYPOINT [ "/bin/bash" ]
CMD [ "/usr/src/Plugwise-2-py/start.sh" ]
