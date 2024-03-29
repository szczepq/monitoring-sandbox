@ECHO OFF
TITLE sandbox.bat - TICK Sandbox

SET interactive=1
SET COMPOSE_CONVERT_WINDOWS_PATHS=1

ECHO %cmdcmdline% | FIND /i "/c"
IF %ERRORLEVEL% == 0 SET interactive=0

REM Enter attaches users to a shell in the desired container
IF "%1"=="enter" (
    IF "%2"=="" (
        ECHO sandbox enter ^(influxdb^|^|chronograf^|^|kapacitor^|^|telegraf^|^|ifql^|^|grafana^)
        GOTO End
    )
    IF "%2"=="influxdb" (
        ECHO Entering ^/bin^/bash session in the influxdb container...
        docker-compose exec influxdb /bin/bash
        GOTO End
    )
    IF "%2"=="chronograf" (
        ECHO Entering ^/bin^/bash session in the chronograf container...
        docker-compose exec chronograf /bin/bash
        GOTO End
    )
    IF "%2"=="kapacitor" (
        ECHO Entering ^/bin^/bash session in the kapacitor container...
        docker-compose exec kapacitor /bin/bash
        GOTO End
    )
    IF "%2"=="telegraf" (
        ECHO Entering ^/bin^/bash session in the telegraf container...
        docker-compose exec telegraf /bin/bash
        GOTO End
    )
    IF "%2"=="grafana" (
        ECHO Entering ^/bin^/bash session in the grafana container...
        docker-compose exec grafana /bin/bash
        GOTO End
    )
)

REM Logs streams the logs from the container to the shell
IF "%1"=="logs" (
    IF "%2"=="" (
        ECHO sandbox logs ^(influxdb^|^|chronograf^|^|kapacitor^|^|telegraf^|^|grafana^)
        GOTO End
    )
    IF "%2"=="influxdb" (
        ECHO Following the logs from the influxdb container...
        docker-compose logs -f influxdb
        GOTO End
    )
    IF "%2"=="chronograf" (
        ECHO Following the logs from the chronograf container...
        docker-compose logs -f chronograf
        GOTO End
    )
    IF "%2"=="kapacitor" (
        ECHO Following the logs from the kapacitor container...
        docker-compose logs -f kapacitor
        GOTO End
    )
    IF "%2"=="telegraf" (
        ECHO Following the logs from the telegraf container...
        docker-compose logs -f telegraf
        GOTO End
    )
)

IF "%1"=="up" (
    ECHO Spinning up Docker Images...
    ECHO If this is your first time starting sandbox this might take a minute...
    docker-compose up -d --build
    ECHO Opening tabs in browser...
    timeout /t 3 /nobreak > NUL
    START "" http://localhost:8888
    START "" http://localhost:3000
    START "" http://localhost:3020
    GOTO End
)

IF "%1"=="down" (
    ECHO Stopping and removing running sandbox containers...
    docker-compose down
    GOTO End
)

IF "%1"=="restart" (
    ECHO Stopping all sandbox processes...
    docker-compose down >NUL 2>NUL
    ECHO Starting all sandbox processes...
    docker-compose up -d --build >NUL 2>NUL
    ECHO Services available!
    GOTO End
)

IF "%1"=="delete-data" (
    ECHO Deleting all influxdb, kapacitor and chronograf data...
    rmdir /S /Q kapacitor\data influxdb\data chronograf\data grafana\data
    GOTO End
)

IF "%1"=="docker-clean" (
    ECHO Stopping all running sandbox containers...
    docker-compose down
    echo Removing TICK images...
    docker rmi influxdb:latest telegraf:latest grafana:latest kapacitor:latest chrono_config:latest quay.io/influxdb/chronograf:latest >NUL 2>NUL
    GOTO End
)

IF "%1"=="influxdb" (
    ECHO Entering the influx cli...
    docker-compose exec influxdb /usr/bin/influx
    GOTO End
)

ECHO sandbox commands:
ECHO   up           -^> spin up the sandbox environment
ECHO   down         -^> tear down the sandbox environment
ECHO   restart      -^> restart the sandbox
ECHO   influxdb     -^> attach to the influx cli
ECHO.
ECHO   enter ^(influxdb^|^|kapacitor^|^|chronograf^|^|telegraf^|^|grafana^) -^> enter the specified container
ECHO   logs  ^(influxdb^|^|kapacitor^|^|chronograf^|^|telegraf^|^|grafana^) -^> stream logs for the specified container
ECHO.
ECHO   delete-data  -^> delete all data created by the TICK Stack
ECHO   docker-clean -^> stop and remove all running docker containers and images

:End
IF "%interactive%"=="0" PAUSE
EXIT /B 0
