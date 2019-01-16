'use strict'

const express = require('express')

const { PORT = '3022' } = process.env
const app = express()

const Influx = require('influx');
const os = require('os');
const influx = new Influx.InfluxDB({
  host: 'influxdb',
  database: 'telegraf',
  schema: [
    {
      measurement: 'response_times',
      fields: {
        path: Influx.FieldType.STRING,
        duration: Influx.FieldType.INTEGER
      },
      tags: [
        'host'
      ]
    }
  ]
})

// app.use((req, res, next) => {
//   influx.getDatabaseNames()
//   .then(names => {
//     res.send('Databases: ' + names.join(', '))
//   })
// })

app.use((req, res, next) => {
  const start = Date.now()

  res.on('finish', () => {
    const duration = Date.now() - start
    console.log(`Request to ${req.path} took ${duration}ms`);

    influx.writePoints([
      {
        measurement: 'response_times',
        tags: { host: os.hostname() },
        fields: { duration, path: req.path },
      }
    ]).catch(err => {
      res.send(`Error saving data to InfluxDB! ${err.stack}`)
    })
  })
  return next()
})

app.get('/', function (req, res) {
  setTimeout(() => {
    res.send('Hello world!');
    //res.redirect('/')
    }, 
    Math.random() * 1000)
})

app.get('/times', function (req, res) {
  influx.query(`
    select * from response_times
    where host = ${Influx.escape.stringLit(os.hostname())}
    order by time desc
    limit 10
  `).then(result => {
    res.json(result)
  }).catch(err => {
    res.status(500).send(err.stack)
  })
})

app.listen(PORT)