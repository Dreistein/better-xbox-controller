class XBoxStick
  constructor: (@x, @y) ->

  getLength: () =>
    Math.sqrt @x*@x + @y*@y

  getAngle: () =>
    d = Math.atan2 @y, @x
    return (if d > 0 then d else 2*Math.PI+d) * 360 / (2* Math.PI)

  isEqual: (stick) =>
    if stick instanceof XBoxStick
      if stick.x is @x and stick.y is @y
        return true
    return false

module.exports = XBoxStick
