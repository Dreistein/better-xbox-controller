XBoxController = require '../src/controller'
USB = require 'usb'

# searching for an official xBox 360 controller
device = USB.findByIds(1118,654)
controller = new XBoxController device

# handling button events and setting the leds to corresponding pattern
controller.on 'button', (key, val) ->
  console.log "Button #{key} has been " + if val then 'pressed' else 'released'
  if val
    switch key
      when 'a' then controller.setLed 'LED_1'
      when 'b' then controller.setLed 'LED_2'
      when 'y' then controller.setLed 'LED_3'
      when 'x' then controller.setLed 'LED_4'
      when 'xBox' then controller.setLed 'ALTERNATING'
      when 'start' then controller.setLed 'ROTATING'
      when 'back' then controller.setLed 'BLINKING'
      else controller.setLed 'ALL_OFF'

# getting trigger values and using them for rumbler speeds
controller.on 'trigger', (val) ->
  console.log "Trigger: right:#{val.r}\tleft:#{val.l}"
  controller.setRumbler val.l,val.r

# Setting custom dead zone for sticks
controller.dead = 10000

# just print the values of the sticks
stick = (side, val) ->
  length = val.getLength().toFixed 2
  angle = val.getAngle().toFixed 2
  console.log "#{side} stick: {x:#{val.x},\ty:#{val.y}};\t" +
    "{l:#{length},\ta:#{angle}°}"

controller.on 'stick:left', (val) ->
  stick('left', val)

controller.on 'stick:right', (val) ->
  stick('right', val)

# in case of errors, print them
controller.on 'error', (err) ->
  console.error  err

# finally open the controller
controller.open()
