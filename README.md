XBox 360 Controller Library for Node.JS
=========================================
XBox 360 Library inspired by the [node-xbox-controller](https://github.com/andrew/node-xbox-controller) library (basically a windows/linux port) written in CoffeeScript / JavaScript.

The library is completely event-driven and based on libusb / [node-usb](https://github.com/nonolith/node-usb). Future releases will add support for an easy way of detecting controller.

Also note that there are still a lot of improvements to be done and that the API is undergoing rapid developement. Things may break. Hang in there, I'll do my best.

Installation
============
Libusb is required. On Linux, you'll need libudev to build libusb. On Ubuntu/Debian simply run `sudo apt-get install build-essential libudev-dev`
and then

`npm install better-xbox-controller`

For more information and troubleshooting have a look at the [installation section](https://github.com/nonolith/node-usb#installation) of the usb library.

Usage
======

```javascript
var XBoxController = require('better-xbox-controller');
var USB = require('usb');

var device = USB.findByIds(0x045e,0x028e);
var controller = new XBoxController(device);

// setting event handlers

//open the controller
controller.open()
```

See also the [example code](https://github.com/Dreistein/better-xbox-controller/blob/master/example/example.coffee) (written in CoffeeScript)


Inputs
--------------
# Buttons
The controller class has two different ways to subscribing to button events.
Either a listener is subscribed to a specific button or to all buttons.

Either way a the following keys are used by the events:
* start
* back
* leftStick
* rightStick
* padUp
* padDown
* padLeft
* padRight
* a
* b
* x
* y
* leftBack
* rightBack
* xBox

## Event: button(key,status)
Emitted when a button state changes.

- `key`: String representing the button
- `status`: Whether the button is pressed or not

## Event: button:key(status)
Emitted when a specific button is pressed where `<key>` is one of the button constants.

- `status`: Whether the button is pressed or not

# Trigger
There exist two trigger on the controller. Each has an unsigned 8 bit value respectively.

## Event: trigger(triggerValues)
Emitted when one of the trigger changes.

- `triggerValues`: An Object containing the current trigger values with properties `r` and `l`.

## Event: trigger:side(triggerValue)
Emitted when a specific trigger changes. `<side>` is either `left` or `right`.

- `triggerValue`: The current value of the trigger.

# Sticks
There exist two sticks on the controller. Each of the sticks has signed 16 bit x and y properties. The events use a XBoxStick object for easier handling.

The controller class also supports dead zones for the sticks. By default it's set to 6000 but can be changed by accessing the `dead` property. Every length below the dead zone value will be treated as 0 in x and y direction. Likewise you can disable the feature by setting `dead` to 0.

## Event: stick(stickValues : XBoxStick)
Emitted when one of the sticks change.

- `stickValues`: An Object with two XBoxStick objects (properties `l` and `r`).

## Event: stick:side(stickValue)
Emitted when a specific stick changes where `<side>` is either `right` or `left`.

- `stickValue`: XBoxStick object representing the stick state.

## Class XBoxStick
Convenience class containing the stick values. The class has two properties `x` and `y`. Additionally the class has two methods to calculate the length and angle of the vector.

### .getLength()
Calculates and returns the length of the vector.

### .getAngle()
Calculates and returns the angle of the vector in degrees.

LEDs
----
The leds of the controller can be changed to a specific state or pattern.

The xBox 360 controller implements the following states and pattern:
* ALL_OFF
* ALL_BLINKING
* FLASH_AND_LED_1
* FLASH_AND_LED_2
* FLASH_AND_LED_3
* FLASH_AND_LED_4
* LED_1
* LED_2
* LED_3
* LED_4
* ROTATING
* BLINKING
* SLOW_BLINKING
* ALTERNATING

## .setLed(state)
Method to send a request to the xBox controller.

- `state`: One of the possible states as String.

## Event: led(state)
This event is sent by the xBox controller when the state of the LED changes.

- `state`: A String representing the current LED state.

Rumbler
-------
The controller contains two different rumble motors which can be accessed.
## .setRumbler(heavy, light)
Sets the speeds of the rumbler motors.

- `heavy`: The speed of the heavy rumbler motor (0-255).
- `light`: The speed of the light rumbler motor (0-255).

Developement
============
If you want to use the source files you need to have [CoffeeScript](http://coffeescript.org) installed.
To download the source files and install the dependencies:
```
git clone https://github.com/Dreistein/better-xbox-controller.git
cd better-xbox-controller
npm install
```
The source files are located in the src directory. An example is also included.
The example can be launched with `npm test` which will also compile the coffeescript files to javascript files.

To build the javascript files separately you can run `npm run-script build`

A lot of information on the underlying protocol can be found at http://tattiebogle.net/index.php/ProjectRoot/Xbox360Controller/UsbInfo
