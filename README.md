# Monitoring Sandbox

This repo is a quick way to get influxdb, kapacitor, chronograf, telegraf, grafana up and working together.

### Running

To run the `sandbox`, simply use the convenient cli:

```bash
$ ./sandbox
sandbox commands:
  up           -> spin up the sandbox environment (add -nightly to grab the latest nightly builds of InfluxDB and Chronograf)
  down         -> tear down the sandbox environment
  restart      -> restart the sandbox
  influxdb     -> attach to the influx cli

  enter (influxdb||kapacitor||chronograf||telegraf||grafana) -> enter the specified container
  logs  (influxdb||kapacitor||chronograf||telegraf||grafana) -> stream logs for the specified container

  delete-data  -> delete all data created by the TICK Stack
  docker-clean -> stop and remove all running docker containers
```

To get started just run `./sandbox up`. You browser will open two tabs:

- `localhost:8888` - Chronograf's address. You will use this as a management UI for the full stack
- `localhost:3020` - node test app
- `localhost:3000` - Grafana's address. Ypu can use it instead of Choreograf

> NOTE: Make sure to stop any existing installations of `influxdb`, `kapacitor`, `chronograf` or `grafana`. If you have them running the Sandbox will run into port conflicts and fail to properly start. In this case stop the existing processes and run `./sandbox restart`. Also make sure you are **not** using _Docker Toolbox_.  


Once the Sandbox launches, you should see your dashboard appear in your browser: