FROM ubuntu:16.04

LABEL maintainer="Jakezp <jakezp@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

# Update and install packages
RUN apt-get update \
    && apt-get install -y software-properties-common curl supervisor cron git\
    && add-apt-repository ppa:jonathonf/python-3.6 \
    && apt-get remove -y software-properties-common \
    && apt autoremove -y \
    && apt-get update \
    && apt-get install -y python3.6 python3-gi\
    && curl -o /tmp/get-pip.py "https://bootstrap.pypa.io/get-pip.py" \
    && python3.6 /tmp/get-pip.py \
    && apt-get remove -y curl \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Add config files
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD crontab /crontab
ADD run.sh /run.sh

# Set permissions
RUN chmod +x /run.sh

# Expose volumes & ports
VOLUME ["/var/spool/cron/crontabs", "/opt/paradox"]
# EXPOSE 80 443

WORKDIR /root/
CMD ["/run.sh"]
