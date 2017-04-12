FROM debian:stable-slim

ENV MARATHON_HOST marathon.mesos
ENV MARATHON_PORT 8080
ENV VARNISH_APP_ID /varnish
ENV VARNISH_PORT_PROTOCOL http
ENV VARNISH_PORT 6081
ENV VARNISH_AGENT_USERNAME varnish
ENV VARNISH_AGENT_PASSWORD password

#Nginx Port
EXPOSE 80 
#Goji Port
EXPOSE 8000 

RUN echo "Europe/Rome" > /etc/timezone && \
  dpkg-reconfigure -f noninteractive tzdata
 
RUN apt-get update && \
	apt-get install -y ufw golang nginx git 
	
RUN service nginx start

# Install Goji
RUN mkdir -p /goji && \
  export GOPATH=/goji && \
  go get github.com/byxorna/goji

# Install dashboard
RUN rm -rf /var/www/html/* && \
  git clone https://github.com/brandonwamboldt/varnish-dashboard.git /var/www/html/

# Configure Goji
COPY ./assets/goji.conf ./assets/varnish-agent.tmpl /conf/

COPY ./assets/start.sh /start.sh

CMD ["/start.sh"]