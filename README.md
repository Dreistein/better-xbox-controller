XBox 360 Controller Library for Node.JS
=========================================
XBox 360 Library inspired by the [node-xbox-controller](https://github.com/andrew/node-xbox-controller) library written in CoffeeScript / JavaScript.

The library is completely event-driven and based on libusb / [node-usb](https://github.com/nonolith/node-usb). Future releases will add support for an easy way of detecting controller.

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
var controller = new XBoxController();
```

The library attempts automatically to find a controller with PID `0x045e` and VID ``
