# varnish-agent-dashboard-marathon

This Docker image creates a fully functional varnish agent dashboard for a Marathon environment. 
It uses:
* Goji (server mode) to automatically create config.json based on running tasks ( https://github.com/byxorna/goji )
* Varnish dashboard ( https://github.com/brandonwamboldt/varnish-dashboard )

You can customize the following ENV parameters:
* MARATHON_HOST marathon.mesos
* MARATHON_PORT 8080
* VARNISH_APP_ID /varnish
* VARNISH_PORT_PROTOCOL http
* VARNISH_PORT 6081

It exposes port 80 to show the dashboard