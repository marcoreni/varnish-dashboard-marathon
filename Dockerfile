FROM debian:stable-slim

ENV MARATHON_HOST marathon.mesos
ENV MARATHON_PORT 8080
ENV VARNISH_APP_ID /varnish
ENV VARNISH_PORT_PROTOCOL http
ENV VARNISH_PORT 6081

RUN echo "Europe/Rome" > /etc/timezone && \
  dpkg-reconfigure -f noninteractive tzdata
 
RUN apt-get update && \
	apt-get install -y ufw golang nginx git 
	
# Install Goji
RUN mkdir -p /goji && \
  export GOPATH=/goji && \
  go get github.com/byxorna/goji

# Configure Goji
COPY ./assets/goji.conf ./assets/varnish-agent.tmpl /conf/

# Install dashboard
RUN rm -rf /var/www/html/* && \
  git clone https://github.com/brandonwamboldt/varnish-dashboard.git /var/www/html/
 
RUN service nginx start

EXPOSE 80 #Nginx Port
EXPOSE 8000 #Goji Port

COPY ./assets/start.sh /start.sh

CMD ["/start.sh"]