FROM debian:stretch-slim

ENV MARATHON_HOST marathon.mesos
ENV MARATHON_PORT 8080
ENV VARNISH_APP_ID /varnish
ENV VARNISH_PORT_PROTOCOL http
ENV VARNISH_PORT 6085
ENV VARNISH_AGENT_USERNAME varnish
ENV VARNISH_AGENT_PASSWORD password

#Nginx Port
EXPOSE 80 

RUN echo "Europe/Rome" > /etc/timezone && \
  dpkg-reconfigure -f noninteractive tzdata
 
RUN apt-get update && \
	apt-get install -y golang nginx-extras git watch

# Configure NGINX
COPY ./assets/nginx.conf /etc/nginx/nginx.conf
	
RUN nginx

# Install Goji
RUN mkdir -p /goji && \
  export GOPATH=/goji && \
  go get github.com/marcoreni/goji

# Install dashboard
RUN rm -rf /var/www/html/* && \
  git clone https://github.com/marcoreni/varnish-dashboard.git /var/www/html/

# Cleanup
RUN apt-get purge -y golang git && apt-get -y autoremove && apt-get -y clean

# Configure Goji
COPY ./assets/goji.conf ./assets/varnish-agent.tmpl /conf/

COPY ./assets/start.sh /start.sh

CMD ["/start.sh"]