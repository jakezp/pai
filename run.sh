#!/bin/bash
# Install pai
cd /root/
git clone https://github.com/jpbarraca/pai.git
cp pai/config/user.py.sample pai/config/user.py
sed -i 's/^gi.*$//g' pai/requirements.txt
pip3 install -r pai/requirements.txt

# Configure pai
grep 'IP' pai/config/user.py
if [[ ! $? == 0 ]]; then 
  echo -e "CONNECTION_TYPE = 'IP'" >> pai/config/user.py
  if [[ -n $IP_CONNECTION_HOST ]]; then
    echo -e "IP_CONNECTION_HOST = '$IP_CONNECTION_HOST'" >> pai/config/user.py
  fi
  if [[ -n $IP_CONNECTION_PASSWORD ]]; then
    echo -e "IP_CONNECTION_PASSWORD = b'$IP_CONNECTION_PASSWORD'" >> pai/config/user.py
  fi
  if [[ -n $IP_CONNECTION_SITEID ]]; then
    echo -e "IP_CONNECTION_SITEID = '$IP_CONNECTION_SITEID'" >> pai/config/user.py
  fi
  if [[ -n $IP_CONNECTION_EMAIL ]]; then
    echo -e "IP_CONNECTION_EMAIL = '$IP_CONNECTION_EMAIL'" >> pai/config/user.py
  fi
  if [[ -n $MQTT_ENABLE ]]; then
    echo -e "MQTT_ENABLE = $MQTT_ENABLE" >> pai/config/user.py
  fi
  if [[ -n $MQTT_HOST ]]; then
    echo -e "MQTT_HOST = '$MQTT_HOST'" >> pai/config/user.py
  fi
  if [[ -n $MQTT_PORT ]]; then
     echo -e "MQTT_PORT = $MQTT_PORT" >> pai/config/user.py
  fi
  if [[ -n $MQTT_USERNAME ]]; then
    echo -e "MQTT_USERNAME = '$MQTT_USERNAME'" >> pai/config/user.py
  fi
  if [[ -n $MQTT_PASSWORD ]]; then
    echo -e "MQTT_PASSWORD = '$MQTT_PASSWORD'" >> pai/config/user.py
  fi
fi

# Configure cron
if [[ ! -f /var/spool/cron/crontabs/root ]]; then
  mv /crontab /var/spool/cron/crontabs/root
fi
touch /etc/crontab /etc/cron.d/* /var/spool/cron/crontabs/* /var/log/cron.log
chmod 0600 /var/spool/cron/crontabs/root

# Use supervisord to start all processes
echo -e "Starting supervisord"
supervisord -c /etc/supervisor/conf.d/supervisord.conf
