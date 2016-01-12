XBox 360 Controller Library for Node.JS
=========================================
XBox 360 Library inspired by the [node-xbox-controller](https://github.com/andrew/node-xbox-controller) library written in CoffeeScript / JavaScript.

The library is completely event-driven and based on libusb / [node-usb](https://github.com/nonolith/node-usb). Future releases will add support for an easy way of detecting controller.

Also note that there are still a lot of improvements to be done. Hang in there, I'll do my best.

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
```

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

## Event: button:<key>(status)
Emitted when a specific button is pressed where `<key>` is one of the button keys.

- `status`: Whether the button is pressed or not

# Trigger
There exist two trigger on the controller. Each has an unsigned 8 bit value respectively.

## Event: trigger(triggerValues)
Emitted when one of the trigger changes.

- `triggerValues`: An Object containing the current trigger values with properties `r` and `l`.

## Event: trigger:<side>(triggerValue)
Emitted when a specific trigger changes. `<side>` is either `left` or `right`.

- `triggerValue`: The current value of the trigger.

# Sticks
There exist two sticks on the controller. Each of the sticks has signed 16 bit x and y properties.

## Event: stick(stickValues)
Emitted when one of the sticks change. The object has the following structure:
```javascript
{
  r: {
    x,y
  },
  l: {
    x,y
  }
}
```

- `stickValues`: The current stick values.

## Event: stick:<side>(stickValue)
Emitted when a specific stick changes where `<side>` is either `right` or `left`.

- `stickValue`: Object with x and y properties representing the stick state.

LEDs
----
The leds of the controller can be changed to a specific state or pattern.

## .setLed(state)
Use the `XBoxController.setLed(state)` method to send a request to the xBox controller.

States are numeric constants, set in the `XBoxController.LED` object.
The `.LED` object contains the following properties:
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
