;; wpi.lisp

;; Copyright (c) 2015, Jeremiah LaRocco <jeremiah.larocco@gmail.com>

;; Permission to use, copy, modify, and/or distribute this software for any
;; purpose with or without fee is hereby granted, provided that the above
;; copyright notice and this permission notice appear in all copies.

;; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
;; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
;; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
;; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
;; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
;; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
;; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.


(in-package #:wpi)

;; Use libgpio
(define-foreign-library libwiringPi
  (:unix "libwiringPi.so")
  (t (:default "libwiringPi")))

(use-foreign-library libwiringPi)

(defparameter +NUM-PINS+ 17)

(defparameter +WPI-MODE-PINS+  0)
(defparameter +WPI-MODE-GPIO+  1)
(defparameter +WPI-MODE-GPIO-SYS+  2)
(defparameter +WPI-MODE-PHYS+  3)
(defparameter +WPI-MODE-PIFACE+  4)
(defparameter +WPI-MODE-UNINITIALISED+ -1)

;; Pin modes

(defparameter +INPUT+  0)
(defparameter +OUTPUT+  1)
(defparameter +PWM-OUTPUT+  2)
(defparameter +GPIO-CLOCK+  3)
(defparameter +SOFT-PWM-OUTPUT+  4)
(defparameter +SOFT-TONE-OUTPUT+  5)
(defparameter +PWM-TONE-OUTPUT+  6)

(defparameter +LOW+  0)
(defparameter +HIGH+  1)

;; Pull up/down/none

(defparameter +PUD-OFF+  0)
(defparameter +PUD-DOWN+  1)
(defparameter +PUD-UP+  2)

;; PWM

(defparameter +PWM-MODE-MS+ 0)
(defparameter +PWM-MODE-BAL+ 1)

;; Interrupt levels

(defparameter +INT-EDGE-SETUP+ 0)
(defparameter +INT-EDGE-FALLING+ 1)
(defparameter +INT-EDGE-RISING+ 2)
(defparameter +INT-EDGE-BOTH+ 3)

;; Pi model types and version numbers
;; Intended for the GPIO program Use at your own risk.

(defparameter +PI-MODEL-UNKNOWN+ 0)
(defparameter +PI-MODEL-A+ 1)
(defparameter +PI-MODEL-B+ 2)
(defparameter +PI-MODEL-BP+ 3)
(defparameter +PI-MODEL-CM+ 4)
(defparameter +PI-MODEL-AP+ 5)
(defparameter +PI-MODEL-2+ 6)

(defparameter +PI-VERSION-UNKNOWN+ 0)
(defparameter +PI-VERSION-1+ 1)
(defparameter +PI-VERSION-1-1+ 2)
(defparameter +PI-VERSION-1-2+ 3)
(defparameter +PI-VERSION-2+ 4)

(defparameter +PI-MAKER-UNKNOWN+ 0)
(defparameter +PI-MAKER-EGOMAN+ 1)
(defparameter +PI-MAKER-SONY+ 2)
(defparameter +PI-MAKER-QISDA+ 3)
(defparameter +PI-MAKER-MBEST+ 4)

(defcvar ("piModelNames" +pi-model-names+ :read-only t) (:pointer :string))
(defcvar ("piModelNames" +pi-revision-names+ :read-only t) (:pointer :string))
(defcvar ("piMakerNames" +pi-maker-names+ :read-only t) (:pointer :string))

(defparameter +WPI-FATAL+ t)
(defparameter +WPI-ALMOST+ nil)

(defcfun ("wiringPiSetup" wiring-pi-setup) :int)
(defcfun ("wiringPiSetupSys" wiring-pi-setup-sys) :int)
(defcfun ("wiringPiSetupGpio" wiring-pi-setup-gpio) :int)
(defcfun ("wiringPiSetupPhys" wiring-pi-setup-phys) :int)

(defcfun ("pinModeAlt" pin-mode-alt) :void (pin :int) (mode :int))
(defcfun ("pinMode" pin-mode) :void  (pin :int) (mode :int))
(defcfun ("pullUpDnControl" pull-up-dn-control) :void  (pin :int) (pud :int))

(defcfun ("digitalRead" digital-read) :int  (pin :int))
(defcfun ("digitalWrite" digital-write) :void  (pin :int) (value :int))

(defcfun ("pwmWrite" pwm-write) :void  (pin :int) (value :int))

(defcfun ("analogRead" analog-read) :int  (pin :int))
(defcfun ("analogWrite" analog-write) :int  (pin :int) (value :int))

(defcfun ("piBoardRev" pi-board-rev) :int)

(defcfun ("wpiPinToGpio" wpi-pin-to-gpio) :int (wpiPin :int))
(defcfun ("physPinToGpio" phys-pin-to-gpio) :int (physPin :int))
(defcfun ("setPadDrive" set-pad-drive) :void (group :int) (value :int))
(defcfun ("getAlt" get-alt) :int (pin :int))
(defcfun ("pwmToneWrite" pwm-town-write) :void (pin :int) (freq :int))
(defcfun ("digitalWriteByte" digital-write-byte) :void (value :int))
(defcfun ("pwmSetMode" pwm-set-mode) :void (mode :int))
(defcfun ("pwmSetRange" pwm-set-range) :void (range :int))
(defcfun ("pwmSetClock" pwm-set-clock) :void (divisor :int))
(defcfun ("gpioClockSet" gpio-clock-set) :void (pin :int) (freq :int))

(defcfun ("waitForInterrupt" wait-for-interrupt) :int (pin :int) (mS :int))


(defcfun ("wiringPiISR" wiring-pi-isr-interal) :int (pin :int) (mode :int) (function :pointer))

(defparameter *isr-function* nil)

(defcallback wiring-pi-isr-cb :void ()
    (if *isr-function*
	(funcall *isr-function*)))
(defun wiring-pi-isr (pin mode func)
  (setf *isr-function* func)
  (wiring-pi-isr-internal pin mode wiring-pi-isr-cb))

(defcfun ("piThreadCreate" pi-thread-create-internal) :int (function :pointer))

(defparameter *thread-function* nil)

(defcallback pi-thread-cb :int ()
    (if *thread-function*
	(funcall *thread-function*)
	0))

(defun pi-thread-create (pin mode func)
  (setf *thread-function* func)
  (pi-thread-create-internal pi-thread-cb))

(defcfun ("piLock" pi-lock) :void (key :int))
(defcfun ("piUnlock" pi-unlock) :void (key :int))


(defcfun ("piHiPri" pi-hi-pri) :int (pri :int))

(defcfun ("delay" delay) :void (howLong :int))
(defcfun ("delayMicroseconds" delay-microseconds) :void (howLong :int))
(defcfun ("millis" millis) :int)
(defcfun ("micros" micros) :int)


(defcfun ("wiringPiI2CRead" i2c-read) :int (fd :int))
(defcfun ("wiringPiI2CReadReg8" i2c-read-reg8) :int (fd :int) (reg :int))
(defcfun ("wiringPiI2CReadReg16" i2c-read-reg16) :int (fd :int) (reg :int))

(defcfun ("wiringPiI2CWrite" i2c-write) :int (fd :int) (data :int))
(defcfun ("wiringPiI2CWriteReg8" i2c-write-reg8) :int (fd :int) (reg :int) (data :int))
(defcfun ("wiringPiI2CWriteReg16" i2c-write-reg16) :int (fd :int) (reg :int) (data :int))

(defcfun ("wiringPiI2CSetupInterface" i2c-setup-interface) :int (device :string) (dev-id :int))
(defcfun ("wiringPiI2CSetup" i2c-setup) :int (dev-id :int))

(defcfun ("wiringPiSPIGetFd" spi-get-fd) :int (channel :int))
(defcfun ("wiringPiSPIDataRW" spi-data-rw-internal) :int (channel :int) (data :pointer) (len :int))
(defcfun ("wiringPiSetupMode" spi-setup-mode) :int (channel :int) (speed :int) (mode :int))
(defcfun ("wiringPiSPISetup" spi-setup) :int (channel :int) (speed :int))

(defun spi-data-rw (channel data &optional (len (length data)))
  (typecase data
      (list
       (let ((mp (foreign-alloc :unsigned-char :count len :initial-contents data)))
	 (spi-data-rw-internal channel mp len)
	 (let ((rval (loop for i from 0 below len
			  collect (mem-aref mp :unsigned-char i))))
	   (foreign-free mp)
	   rval)))
      (simple-vector
       (spi-data-rw-internal channel data len)
       data)))

(defcfun ("serialOpen" serial-open) :int (device :int) (baud :int))
(defcfun ("serialClose" serial-close) :void (fd :int))
(defcfun ("serialFlush" serial-flush) :void (fd :int))
(defcfun ("serialPutchar" serial-putchar) :void (fd :int) (c :unsigned-char))
(defcfun ("serialPuts" serial-puts) :void (fd :int) (s :string))
(defcfun ("serialDataAvail" serial-data-avail) :int (fd :int))
(defcfun ("serialGetChar" serial-getchar) :int (fd :int))

(defcfun ("shiftIn" shift-in) :unsigned-char (d-pin :unsigned-char) (c-pin :unsigned-char) (order :unsigned-char))
(defcfun ("shiftOut" shift-out) :unsigned-char (d-pin :unsigned-char) (c-pin :unsigned-char) (order :unsigned-char) (val :unsigned-char))

(defcfun ("softPwmCreate" soft-pwm-create) :int (pin :int) (value :int) (range :int))
(defcfun ("softPwmWrite" soft-pwm-write) :void (pin :int) (value :int))
(defcfun ("softPwmStop" soft-pwm-stop) :void (pin :int))

(defcfun ("softToneCreate" soft-tone-create) :int (pin :int))
(defcfun ("softToneStop" soft-tone-stop) :void (pin :int))
(defcfun ("softToneWrite" soft-tone-write) :void (pin :int) (freq :int))

(defcfun ("softServoWrite" soft-servo-write) :void (pin :int) (value :int))
(defcfun ("softServoSetup" soft-servo-setup) :int (p0 :int) (p1 :int) (p2 :int) (p3 :int)
	 (p4 :int) (p5 :int) (p6 :int) (p7 :int))

(defcfun ("mcp3422Setup" mcp-3422-setup) :int (pin-base :int) (i2c-address :int) (sample-rate :int) (gain :int))

(defcfun ("drcSetupSerial" drc-setup-serial) :int (pin-base :int) (num-pins :int) (device :string) (baud :int))

(defcfun ("sn3218Setup" sn-3218-setup) :int (pin-base :int))
(defcfun ("sr595Setup" sr-5955-setup) :int (pin-base :int) (num-pins :int) (data-pin :int) (clock-pin :int) (latch-pin :int))

(defcfun ("pcf8591Setup" pcf-8591-setup) :int (pin-base :int) (i2c-address :int))
(defcfun ("pcf8574Setup" pcf-8574-setup) :int (pin-base :int) (i2c-address :int))

(defcfun ("mcp4802Setup" mcp-4802-setup) :int (pin-base :int) (spi-channel :int))
(defcfun ("mcp3004Setup" mcp-3004-setup) :int (pin-base :int) (spi-channel :int))
(defcfun ("mcp3002Setup" mcp-3002-setup) :int (pin-base :int) (spi-channel :int))

(defcfun ("mcp23s17Setup" mcp-23s17-setup) :int (pin-base :int) (spi-port :int ) (dev-id :int))
(defcfun ("mcp23s08Setup" mcp-23s08-setup) :int (pin-base :int) (spi-port :int ) (dev-id :int))

(defcfun ("mcp23017Setup" mcp-23017-setup) :int (pin-base :int) (i2c-address :int))
(defcfun ("mcp23016Setup" mcp-23016-setup) :int (pin-base :int) (i2c-address :int))
(defcfun ("mcp23008Setup" mcp-23008-setup) :int (pin-base :int) (i2c-address :int))

(defcfun ("max5322Setup" max-5322-setup) :int (pin-base :int) (spi-channel :int))
(defcfun ("max31855Setup" max-31855-setup) :int (pin-base :int) (spi-channel :int))

(defparameter +MCP23x08_IODIR+ #x00)
(defparameter +MCP23x08_IPOL+ #x01)
(defparameter +MCP23x08_GPINTEN+ #x02)
(defparameter +MCP23x08_DEFVAL+ #x03)
(defparameter +MCP23x08_INTCON+ #x04)
(defparameter +MCP23x08_IOCON+ #x05)
(defparameter +MCP23x08_GPPU+ #x06)
(defparameter +MCP23x08_INTF+ #x07)
(defparameter +MCP23x08_INTCAP+ #x08)
(defparameter +MCP23x08_GPIO+ #x09)
(defparameter +MCP23x08_OLAT+ #x0A)

;; MCP23x17 Registers

(defparameter +MCP23x17_IODIRA+ #x00)
(defparameter +MCP23x17_IPOLA+ #x02)
(defparameter +MCP23x17_GPINTENA+ #x04)
(defparameter +MCP23x17_DEFVALA+ #x06)
(defparameter +MCP23x17_INTCONA+ #x08)
(defparameter +MCP23x17_IOCON+ #x0A)
(defparameter +MCP23x17_GPPUA+ #x0C)
(defparameter +MCP23x17_INTFA+ #x0E)
(defparameter +MCP23x17_INTCAPA+ #x10)
(defparameter +MCP23x17_GPIOA+ #x12)
(defparameter +MCP23x17_OLATA+ #x14)

(defparameter +MCP23x17_IODIRB+ #x01)
(defparameter +MCP23x17_IPOLB+ #x03)
(defparameter +MCP23x17_GPINTENB+ #x05)
(defparameter +MCP23x17_DEFVALB+ #x07)
(defparameter +MCP23x17_INTCONB+ #x09)
(defparameter +MCP23x17_IOCONB+ #x0B)
(defparameter +MCP23x17_GPPUB+ #x0D)
(defparameter +MCP23x17_INTFB+ #x0F)
(defparameter +MCP23x17_INTCAPB+ #x11)
(defparameter +MCP23x17_GPIOB+ #x13)
(defparameter +MCP23x17_OLATB+ #x15)

;; Bits in the IOCON register

(defparameter +IOCON_UNUSED+ #x01)
(defparameter +IOCON_INTPOL+ #x02)
(defparameter +IOCON_ODR+ #x04)
(defparameter +IOCON_HAEN+ #x08)
(defparameter +IOCON_DISSLW+ #x10)
(defparameter +IOCON_SEQOP+ #x20)
(defparameter +IOCON_MIRROR+ #x40)
(defparameter +IOCON_BANK_MODE+ #x80)

;; Default initialisation mode

(defparameter +IOCON_INIT+ +IOCON_SEQOP+)

;; SPI Command codes

(defparameter +CMD_WRITE+ #x40)
(defparameter +CMD_READ+ #x41)

(defparameter +IODIRA+ #x00)
(defparameter +IPOLA+ #x02)
(defparameter +GPINTENA+ #x04)
(defparameter +DEFVALA+ #x06)
(defparameter +INTCONA+ #x08)
(defparameter +IOCON+ #x0A)
(defparameter +GPPUA+ #x0C)
(defparameter +INTFA+ #x0E)
(defparameter +INTCAPA+ #x10)
(defparameter +GPIOA+ #x12)
(defparameter +OLATA+ #x14)

(defparameter +IODIRB+ #x01)
(defparameter +IPOLB+ #x03)
(defparameter +GPINTENB+ #x05)
(defparameter +DEFVALB+ #x07)
(defparameter +INTCONB+ #x09)
(defparameter +IOCONB+ #x0B)
(defparameter +GPPUB+ #x0D)
(defparameter +INTFB+ #x0F)
(defparameter +INTCAPB+ #x11)
(defparameter +GPIOB+ #x13)
(defparameter +OLATB+ #x15)

;; Bits in the IOCON register

(defparameter +IOCON_UNUSED+ #x01)
(defparameter +IOCON_INTPOL+ #x02)
(defparameter +IOCON_ODR+ #x04)
(defparameter +IOCON_HAEN+ #x08)
(defparameter +IOCON_DISSLW+ #x10)
(defparameter +IOCON_SEQOP+ #x20)
(defparameter +IOCON_MIRROR+ #x40)
(defparameter +IOCON_BANK_MODE+ #x80)

;; Default initialisation mode

(defparameter +IOCON_INIT+ +IOCON_SEQOP+)

;; SPI Command codes

(defparameter +CMD_WRITE+ #x40)
(defparameter +CMD_READ+ #x41)


(defparameter +MCP23016_GP0+ #x00)
(defparameter +MCP23016_GP1+ #x01)
(defparameter +MCP23016_OLAT0+ #x02)
(defparameter +MCP23016_OLAT1+ #x03)
(defparameter +MCP23016_IPOL0+ #x04)
(defparameter +MCP23016_IPOL1+ #x05)
(defparameter +MCP23016_IODIR0+ #x06)
(defparameter +MCP23016_IODIR1+ #x07)
(defparameter +MCP23016_INTCAP0+ #x08)
(defparameter +MCP23016_INTCAP1+ #x09)
(defparameter +MCP23016_IOCON0+ #x0A)
(defparameter +MCP23016_IOCON1+ #x0B)

;; Bits in the IOCON register

(defparameter +IOCON_IARES+ #x01)

;; Default initialisation mode

(defparameter +IOCON_INIT+ 0)

