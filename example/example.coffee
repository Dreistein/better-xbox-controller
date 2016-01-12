XBoxController = require './controller'
USB = require 'usb'

dev = USB.findByIds(1118,654)

cont = new XBoxController dev

cont.on 'button', (key, val) ->
  console.log "Button #{key} has been " + if val then 'pressed' else 'released'
  if val
    if key is 'leftStick'
      cont.setLed cont.LED.ALL_OFF
    if key is 'a'
      cont.setLed cont.LED.LED_1
    if key is 'b'
      cont.setLed cont.LED.LED_2
    if key is 'y'
      cont.setLed cont.LED.LED_3
    if key is 'x'
      cont.setLed cont.LED.LED_4
    if key is 'xBox'
      cont.setLed cont.LED.ALTERNATING
    if key is 'start'
      cont.setLed cont.LED.ROTATING
    if key is 'back'
      cont.setLed cont.LED.BLINKING

cont.on 'trigger', (val) ->
  console.log "Trigger: right:#{val.r}\tleft:#{val.l}"
  cont.setRumbler val.l,val.r

cont.on 'stick:left', (val) ->
  console.log "Left Stick: {x:#{val.x},\ty:#{val.y}}"

cont.on 'stick:right', (val) ->
  console.log "Right Stick: {x:#{val.x},\ty:#{val.y}}"

cont.on 'error', (err) ->
  console.log err

cont.open()
