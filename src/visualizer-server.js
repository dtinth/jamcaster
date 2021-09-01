const express = require('express')
const cors = require('cors')
const net = require('net')
const jayson = require('jayson/promise')
const ndjson = require('ndjson')
const jamulusClient = new jayson.client.tcp({ host: '127.0.0.1', port: 22100 })
const { EventEmitter } = require('events')

const app = express()

const events = new EventEmitter()

async function worker() {
  for (let i = 1; ; i++) {
    try {
      console.error('Connection ' + i + ' start')
      const connection = await new Promise((resolve, reject) => {
        const conn = net.connect({ host: '127.0.0.1', port: 22100 })
        conn.on('error', reject)
        conn.on('connect', () => {
          resolve(conn)
        })
      })
      await new Promise((resolve) => {
        connection.on('end', resolve)
        connection.on('close', resolve)
        connection
          .pipe(ndjson.parse())
          .on('data', (data) => {
            events.emit('data', data)
          })
          .on('error', () => {
            reject()
          })
      })
    } catch (e) {
      console.error('Connection ' + i + ' died', e)
    } finally {
      await new Promise((resolve) => setTimeout(resolve, 1000))
    }
  }
}

worker()

app.get('/events', (req, res) => {
  res.setHeader('Content-Type', 'text/event-stream')
  res.flushHeaders()
  res.write('\n')

  const writeEvent = (event) => {
    res.write(`data: ${JSON.stringify(event)}\n\n`)
  }

  events.on('data', writeEvent)

  jamulusClient.request('jamulusclient/getClientList', {}).then(
    (result) => {
      writeEvent(result)
    },
    (err) => {
      console.error(err)
    },
  )

  res.on('close', () => {
    console.log('Client disconnected')
    events.removeListener('data', writeEvent)
    res.end()
  })
})

app.use(cors())
app.use(express.static(__dirname + '/visualizer'))
app.listen(3430, () => console.log('Visualizer server listening!'))
