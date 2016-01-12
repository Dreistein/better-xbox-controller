class XBoxStick
  constructor: (@x, @y) ->

  getLength: () =>
    Math.sqrt @x*@x + @y*@y

  getAngle: () =>
    Math.atan2 @y, @x

  isEqual: (stick) =>
    if stick instanceof XBoxStick
      if stick.x is @x and stick.y is @y
        return true
    return false

module.exports = XBoxStick
