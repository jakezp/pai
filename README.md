# Paradox Alarm Interface for Magellan - created by jpbarraca (https://github.com/jpbarraca/pai)

Paradox Alarm Interface for Magellan created by jpbarraca (https://github.com/jpbarraca/pai).<br> Middleware that aims to connect to a Paradox Alarm panel, exposing the interface for monitoring and control via several technologies. With this interface it is possible to integrate Paradox panels with HomeAssistant, OpenHAB, Homebridge or other domotics system that supports MQTT, as well as several IM methods.
<br>
I've created the docker image to automate installation and running in direct IP connection with MQTT enabled. The application is started and managed by supervisor.
<br>
Requires a configured MQTT server to run. There are many other options...

Additionally, I've configured cron, in case required.

# Run with:
```
docker run -d --name='pai' --net='bridge' --privileged \
	-e 'IP_CONNECTION_HOST'='1.1.1.1' \
	-e 'IP_CONNECTION_PASSWORD'='1234' \
	-e 'IP_CONNECTION_SITEID'='optional_if_required' \
	-e 'IP_CONNECTION_EMAIL'='email@example.com' \
	-e 'MQTT_ENABLE'='True' \
	-e 'MQTT_HOST'='2.2.2.2' \
	-e 'MQTT_PORT'='1833' \
	-e 'MQTT_USERNAME'='username' \
	-e 'MQTT_PASSWORD'='password' \
	-e 'PASSWORD'=None \
	-e 'LOGGING_FILE'='paradox.log' \
	-v '/tmp/pai/config':'/opt/pai' \
	-v '/tmp/pai/cron':'/var/spool/cron/crontab/' \
	pai
```
## Change:
              IP_CONNECTION_HOST - IP Module address. Firmware < 4.0
              IP_CONNECTION_PASSWORD - IP Module password. Firmware < 4.0
              IP_CONNECTION_SITEID - If defined, connection will be made through this method. Firmware > 4.0
              IP_CONNECTION_EMAIL - If defined, email registered in the site. Firmware > 4.0
              MQTT_HOST - MQTT hostname or IP - Hostname or address
              MQTT_USERNAME - MQTT Username
              MQTT_PASSWORD - MQTT Password
              PASSWORD - Panel Password. If no panel password, enter None
              /tmp - preferred location on the host
<p>
Requires a configured MQTT server to run. There are many other options that can be tweaked - check /tmp/pai/config/pai/config/defaults.py for options and add these options to be changed to /tmp/pai/config/pai/config/user.py. Restart pai with:

```
docker exec pai /usr/bin/supervisorctl restart pai
```
This image is created to run on an Unraid server. For the unraid config, see https://github.com/jakezp/unraid-docker-templates/tree/master/jakezp/pai.xml

