# Paradox Alarm Interface for Magellan - test docker container

Paradox Alarm Interface for Magellan created by jpbarraca (https://github.com/jpbarraca/pai) seems like it might work for me. I still need to purchase a Paradox IP150 unit to continue with the configuration and test if it will actually work for my usecase.
<br>
I've created the docker image in the meantime to automate installation and running in direct IP connectioni with MQTT enabled. I'n not even sure if this will work in a docker container. The application is started and managed by supervisor.
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
	-v '/tmp/pai/config':'/root' \
	-v '/tmp/pai/cron':'/var/spool/cron/crontab/' \
	pai
```
## Change:
	IP_CONNECTION_HOST - IP Module address
	IP_CONNECTION_PASSWORD - IP Module password
	IP_CONNECTION_SITEID - IF defined, connection will be made through this method (not 100% sure how this is used)
	IP_CONNECTION_EMAIL - Email registered in the site
	MQTT_HOST - MQTT hostname or IP - Hostname or address
	MQTT_USERNAME - MQTT Username
	MQTT_PASSWORD - MQTT Password
	/tmp - preferred location on the host
<p>
Requires a configured MQTT server to run. There are many other options that can be tweaked - check /tmp/pai/config/pai/config/defaults.py for options and add these options to be changed to /tmp/pai/config/pai/config/user.py. Restart pai with:

```
docker exec pai /usr/bin/supervisorctl restart pai
```

This is the first version of this image and loads will probably still change. The aim is to have a working container for my usecase, so YMMV and you will probably need to make some changes. 

This image is created to run on an Unraid server. For the unraid config, see https://github.com/jakezp/unraid-docker-templates/tree/master/jakezp/pai.xml

