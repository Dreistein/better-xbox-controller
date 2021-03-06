EventEmitter = require 'events'
Stick = require './stick'
fs = require 'fs'
config = JSON.parse fs.readFileSync __dirname + '/config.json'

createStateObject = () ->
  data = {
    button: {}
    trigger:
      r: 0x00
      l:0x00
    stick:
      r: new Stick 0, 0
      l: new Stick 0, 0
  }
  for k,v of config.button
    data.button[k] = false
  return data


class XBoxController extends EventEmitter
  constructor: (@device) ->
    @dead = 6000

    # convinience property to not break old API
    @LED = {}
    for k,v of config.led
      @LED[k] = k

  open: () =>
    if not @device?
      return @emit 'error', 'No Controller Set!'

    @device.open()
    inputInterface = @device.interface(0)
    if inputInterface.isKernelDriverActive()
      inputInterface.detachKernelDriver()
    inputInterface.claim()

    led = []
    for k,v of @LED
      led[v] = k


    for ep in inputInterface.endpoints
      if ep.direction is 'in'
        @in = ep
      else
        @out = ep

    @state = createStateObject()

    @in.startPoll()

    inputHandler = (data) =>
      buttonChange = false
      d = data.readUInt16BE(2)
      #console.log d
      for k,v of config.button
        actual = (d & v) > 0
        #console.log k, actual
        if @state.button[k] isnt actual
          @state.button[k] = actual
          event = 'button:' + k
          @emit event, actual
          @emit 'button', k, actual
          buttonChange = true

      triggerChange = false
      if @state.trigger.l isnt data[4]
        @state.trigger.l = data[4]
        triggerChange = true
        @emit 'trigger:left', data[4]
      if @state.trigger.r isnt data[5]
        @state.trigger.r = data[5]
        triggerChange = true
        @emit 'trigger:right', data[5]

      if triggerChange
        @emit 'trigger', @state.trigger

      stickChange = false

      x = data.readInt16LE(6)
      y = data.readInt16LE(8)
      if @dead > Math.sqrt x*x+y*y
        x = y = 0
      stick = new Stick x,y
      if not stick.isEqual @state.stick.l
        @state.stick.l = stick
        @emit 'stick:left', stick
        stickChange = true

      x = data.readInt16LE(10)
      y = data.readInt16LE(12)
      if @dead > Math.sqrt x*x+y*y
        x = y = 0
      stick = new Stick x,y
      if not stick.isEqual @state.stick.r
        @state.stick.r = stick
        @emit 'stick:right', stick
        stickChange = true

      if stickChange
        @emit 'stick', @state.stick

      if buttonChange or triggerChange or stickChange
        @emit 'all', @state

    ledHandler = (data) =>
      state = data[3]
      @emit 'led', led[state]

    @in.on 'data', (data) ->
      if data[0] is 0x00 and data[1] is 0x14
        inputHandler(data)
      else if data[0] is 0x01 and data[1] is 0x03
        ledHandler(data)
      #headset report. true for attached false for detached
      else if data[0] is 0x08 and data[1] is 0x03
        @emit 'headset', if data[2] then true else false
      else console.log data


  close: () =>
    @device.close()

  setLed: (state) =>
    state = config.led[state]
    if not state?
      throw new Error "Unknown LED state! '#{state}'"
    buf = new Buffer [0x01,0x03,state]
    @_sendData buf

  setRumbler: (heavy, light) =>
    heavy = Math.min(Math.max(heavy, 0), 255)
    light = Math.min(Math.max(light, 0), 255)
    buf = new Buffer [0,8,0,heavy,light,0,0,0]
    @_sendData buf

  _sendData: (buf) =>
    @out.transfer buf, (err) ->
      if err then return @emit 'error', err

module.exports = XBoxController
