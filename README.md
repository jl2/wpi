#wpi

wpi is a Common Lisp binding to the wiringPi library.

It supports all of the basic wiringPi functions (pinMode, digitalWrite, digitalRead, etc.) as well as the I2C, SPI, Serial, Shift, SoftPWM, SoftTone, and SoftServo libraries.


The easiest way to get started is to use QuickLisp and clone the library into your ASDF/QuickLisp search path:

```bash
cd ~/src/lisp
git clone https://github.com/jl2/wpi
```

Next, start a REPL or Slime as root:

```bash
sudo emacs --user $USER -f slime
```

Finally, connect an LED to GPIO pin 4 (wiringPi pin 7) and run the following:

```commonlisp
(ql:quickload 'wpi)

(wpi:wiring-pi-setup)
(defun blink (n)
    (wpi:pin-mode 7 wpi:+output+)
    (dotimes (i n)
        (wpi:digital-write 7 1)
	(sleep 0.5)
	(wpi:digital-write 7 0)
	(sleep 0.5)))
(blink 10)
```

If everything is configured and working correctly, there should be no error messages, and the LED should blink 10 times.

# Notes
wiringPi, and hence this library, require running as the root user.

This Common Lisp binding is released under the ISC license, but wiringPi itself is under the LGPL.

This library has not been tested very well (yet).  Basic functionality works, but I haven't tested more advanced features, like i2c and SPI.  Any help would be appreciated, and please create issues for any bugs.


