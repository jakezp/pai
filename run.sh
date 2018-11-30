#!/bin/bash
# Install pai

if [[ -f /opt/paradox/config/user.py ]]; then
  cp /opt/paradox/config/user.py /root/user.py
  rm -rf /opt/paradox
  git clone https://github.com/jpbarraca/pai.git /opt/paradox
  pip3 install -r /opt/paradox/requirements.txt
  mv /root/user.py /opt/paradox/config/user.py
  mkdir -p /opt/paradox/logs/
else
  rm -rf /opt/paradox
  git clone https://github.com/jpbarraca/pai.git /opt/paradox
  pip3 install -r /opt/paradox/requirements.txt
  sleep 30
  cp /opt/paradox/config/user.py.sample /opt/paradox/config/user.py
  echo -e "CONNECTION_TYPE = 'IP'" >> /opt/paradox/config/user.py
  if [[ -n $IP_CONNECTION_HOST ]]; then
    echo -e "IP_CONNECTION_HOST = '$IP_CONNECTION_HOST'" >> /opt/paradox/config/user.py
  fi
  if [[ -n $IP_CONNECTION_PASSWORD ]]; then
    echo -e "IP_CONNECTION_PASSWORD = b'$IP_CONNECTION_PASSWORD'" >> /opt/paradox/config/user.py
  fi
  if [[ -n $IP_CONNECTION_SITEID ]]; then
    echo -e "IP_CONNECTION_SITEID = '$IP_CONNECTION_SITEID'" >> /opt/paradox/config/user.py
  fi
  if [[ -n $IP_CONNECTION_EMAIL ]]; then
    echo -e "IP_CONNECTION_EMAIL = '$IP_CONNECTION_EMAIL'" >> /opt/paradox/config/user.py
  fi
  if [[ -n $MQTT_ENABLE ]]; then
    echo -e "MQTT_ENABLE = $MQTT_ENABLE" >> /opt/paradox/config/user.py
  fi
  if [[ -n $MQTT_HOST ]]; then
    echo -e "MQTT_HOST = '$MQTT_HOST'" >> /opt/paradox/config/user.py
  fi
  if [[ -n $MQTT_PORT ]]; then
     echo -e "MQTT_PORT = $MQTT_PORT" >> /opt/paradox/config/user.py
  fi
  if [[ -n $MQTT_USERNAME ]]; then
    echo -e "MQTT_USERNAME = '$MQTT_USERNAME'" >> /opt/paradox/config/user.py
  fi
  if [[ -n $MQTT_PASSWORD ]]; then
    echo -e "MQTT_PASSWORD = '$MQTT_PASSWORD'" >> /opt/paradox/config/user.py
  fi
  if [[ -n $PASSWORD ]]; then
    echo -e "PASSWORD = '$PASSWORD'" >> /opt/paradox/config/user.py
  else
    echo -e "PASSWORD = None" >> /opt/paradox/config/user.py
  fi
  if [[ -n $LOGGING_FILE ]]; then
    mkdir -p /opt/paradox/logs/
    echo -e "LOGGING_FILE = '/opt/paradox/logs/$LOGGING_FILE'" >> /opt/paradox/config/user.py
  fi
fi

# Configure cron
if [[ ! -f /var/spool/cron/crontabs/root ]]; then
  mv /crontab /var/spool/cron/crontabs/root
fi
touch /etc/crontab /etc/cron.d/* /var/spool/cron/crontabs/* /var/log/cron.log
chmod 0600 /var/spool/cron/crontabs/root

# Temp fix to enable support for home-assistant
sed -i 's/DISARMED/disarmed/g' /opt/paradox/paradox/interfaces/intmqtt_interface.py; 
sed -i 's/DISARM/disarmed/g' /opt/paradox/paradox/interfaces/intmqtt_interface.py; 
sed -i 's/NIGHT_ARM/armed_sleep/g' /opt/paradox/paradox/interfaces/intmqtt_interface.py; 
sed -i 's/AWAY_ARM/armed_away/g' /opt/paradox/paradox/interfaces/intmqtt_interface.py; 
sed -i 's/STAY_ARM/armed_home/g' /opt/paradox/paradox/interfaces/intmqtt_interface.py; 
sed -i 's/ALARM_TRIGGERED/triggered/g' /opt/paradox/paradox/interfaces/intmqtt_interface.py

# Use supervisord to start all processes
echo -e "Starting supervisord"
supervisord -c /etc/supervisor/conf.d/supervisord.conf
