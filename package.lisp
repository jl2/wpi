;; package.lisp

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

(defpackage #:wpi
  (:use #:cl #:cffi)
  (:export #:wiringPiSetup

	   #:+NUM-PINS+

	   #:+WPI-MODE-PINS+ 
	   #:+WPI-MODE-GPIO+ 
	   #:+WPI-MODE-GPIO-SYS+ 
	   #:+WPI-MODE-PHYS+ 
	   #:+WPI-MODE-PIFACE+ 
	   #:+WPI-MODE-UNINITIALISED+

	   ;; Pin modes

	   #:+INPUT+ 
	   #:+OUTPUT+ 
	   #:+PWM-OUTPUT+ 
	   #:+GPIO-CLOCK+ 
	   #:+SOFT-PWM-OUTPUT+ 
	   #:+SOFT-TONE-OUTPUT+ 
	   #:+PWM-TONE-OUTPUT+ 

	   #:+LOW+ 
	   #:+HIGH+ 

	   ;; Pull up/down/none

	   #:+PUD-OFF+ 
	   #:+PUD-DOWN+ 
	   #:+PUD-UP+ 

	   ;; PWM

	   #:+PWM-MODE-MS+
	   #:+PWM-MODE-BAL+

	   ;; Interrupt levels

	   #:+INT-EDGE-SETUP+
	   #:+INT-EDGE-FALLING+
	   #:+INT-EDGE-RISING+
	   #:+INT-EDGE-BOTH+

	   ;; Pi model types and version numbers
	   ;; Intended for the GPIO program Use at your own risk.

	   #:+PI-MODEL-UNKNOWN+
	   #:+PI-MODEL-A+
	   #:+PI-MODEL-B+
	   #:+PI-MODEL-BP+
	   #:+PI-MODEL-CM+
	   #:+PI-MODEL-AP+
	   #:+PI-MODEL-2+

	   #:+PI-VERSION-UNKNOWN+
	   #:+PI-VERSION-1+
	   #:+PI-VERSION-1-1+
	   #:+PI-VERSION-1-2+
	   #:+PI-VERSION-2+

	   #:+PI-MAKER-UNKNOWN+
	   #:+PI-MAKER-EGOMAN+
	   #:+PI-MAKER-SONY+
	   #:+PI-MAKER-QISDA+
	   #:+PI-MAKER-MBEST+

	   #:+pi-model-names+
	   #:+pi-revision-names+
	   #:+pi-maker-names+

	   #:+WPI-FATAL+
	   #:+WPI-ALMOST+

	   #:wiring-pi-setup
	   #:wiring-pi-setup-sys
	   #:wiring-pi-setup-gpio
	   #:wiring-pi-setup-phys

	   #:pin-mode-alt
	   #:pin-mode
	   #:pull-up-dn-control

	   #:digital-read
	   #:digital-write

	   #:pwm-write

	   #:analog-read
	   #:analog-write

	   #:pi-board-rev

	   #:wpi-pin-to-gpio
	   #:phys-pin-to-gpio
	   #:set-pad-drive
	   #:get-alt
	   #:pwm-town-write
	   #:digital-write-byte
	   #:pwm-set-mode
	   #:pwm-set-range
	   #:pwm-set-clock
	   #:gpio-clock-set

	   #:wait-for-interrupt


	   #:wiring-pi-isr
	   #:pi-thread-create

	   #:pi-lock
	   #:pi-unlock


	   #:pi-hi-pri

	   #:delay
	   #:delay-microseconds
	   #:millis
	   #:micros

	   #:i2c-read
	   #:i2c-read-reg8
	   #:i2c-read-reg16

	   #:i2c-write
	   #:i2c-write-reg8
	   #:i2c-write-reg16

	   #:i2c-setup-interface
	   #:i2c-setup

	   #:spi-get-fd
	   #:spi-data-rw
	   #:spi-setup-mode
	   #:spi-setup

	   #:serial-open
	   #:serial-close
	   #:serial-flush
	   #:serial-putchar
	   #:serial-puts
	   #:serial-data-avail
	   #:serial-getchar

	   #:shift-in
	   #:shift-out


	   #:soft-pwm-create
	   #:soft-pwm-write
	   #:soft-pwm-stop

	   #:soft-tone-create
	   #:soft-tone-stop
	   #:soft-tone-write

	   #:soft-servo-write
	   #:soft-servo-setup

	   #:mcp-3422-setup

	   #:drc-setup-serial
	   #:sn-3218-setup
	   #:sr-5955-setup

	   #:pcf-8591-setup
	   #:pcf-8574-setup

	   #:mcp-4802-setup
	   #:mcp-3004-setup
	   #:mcp-3002-setup

	   #:mcp-23s17-setup
	   #:mcp-23s08-setup

	   #:mcp-23017-setup
	   #:mcp-23016-setup
	   #:mcp-23008-setup

	   #:max-5322-setup
	   #:max-31855-setup


	   #:+MCP23x08_IODIR+
	   #:+MCP23x08_IPOL+
	   #:+MCP23x08_GPINTEN+
	   #:+MCP23x08_DEFVAL+
	   #:+MCP23x08_INTCON+
	   #:+MCP23x08_IOCON+
	   #:+MCP23x08_GPPU+
	   #:+MCP23x08_INTF+
	   #:+MCP23x08_INTCAP+
	   #:+MCP23x08_GPIO+
	   #:+MCP23x08_OLAT+

	   ;; MCP23x17 Registers

	   #:+MCP23x17_IODIRA+
	   #:+MCP23x17_IPOLA+
	   #:+MCP23x17_GPINTENA+
	   #:+MCP23x17_DEFVALA+
	   #:+MCP23x17_INTCONA+
	   #:+MCP23x17_IOCON+
	   #:+MCP23x17_GPPUA+
	   #:+MCP23x17_INTFA+
	   #:+MCP23x17_INTCAPA+
	   #:+MCP23x17_GPIOA+
	   #:+MCP23x17_OLATA+

	   #:+MCP23x17_IODIRB+
	   #:+MCP23x17_IPOLB+
	   #:+MCP23x17_GPINTENB+
	   #:+MCP23x17_DEFVALB+
	   #:+MCP23x17_INTCONB+
	   #:+MCP23x17_IOCONB+
	   #:+MCP23x17_GPPUB+
	   #:+MCP23x17_INTFB+
	   #:+MCP23x17_INTCAPB+
	   #:+MCP23x17_GPIOB+
	   #:+MCP23x17_OLATB+

	   ;; Bits in the IOCON register

	   #:+IOCON_UNUSED+
	   #:+IOCON_INTPOL+
	   #:+IOCON_ODR+
	   #:+IOCON_HAEN+
	   #:+IOCON_DISSLW+
	   #:+IOCON_SEQOP+
	   #:+IOCON_MIRROR+
	   #:+IOCON_BANK_MODE+

	   ;; Default initialisation mode

	   #:+IOCON_INIT+

	   ;; SPI Command codes

	   #:+CMD_WRITE+
	   #:+CMD_READ+

	   #:+IODIRA+
	   #:+IPOLA+
	   #:+GPINTENA+
	   #:+DEFVALA+
	   #:+INTCONA+
	   #:+IOCON+
	   #:+GPPUA+
	   #:+INTFA+
	   #:+INTCAPA+
	   #:+GPIOA+
	   #:+OLATA+

	   #:+IODIRB+
	   #:+IPOLB+
	   #:+GPINTENB+
	   #:+DEFVALB+
	   #:+INTCONB+
	   #:+IOCONB+
	   #:+GPPUB+
	   #:+INTFB+
	   #:+INTCAPB+
	   #:+GPIOB+
	   #:+OLATB+

	   ;; Bits in the IOCON register

	   #:+IOCON_UNUSED+
	   #:+IOCON_INTPOL+
	   #:+IOCON_ODR+
	   #:+IOCON_HAEN+
	   #:+IOCON_DISSLW+
	   #:+IOCON_SEQOP+
	   #:+IOCON_MIRROR+
	   #:+IOCON_BANK_MODE+

	   ;; Default initialisation mode

	   #:+IOCON_INIT+

	   ;; SPI Command codes

	   #:+CMD_WRITE+
	   #:+CMD_READ+


	   #:+MCP23016_GP0+
	   #:+MCP23016_GP1+
	   #:+MCP23016_OLAT0+
	   #:+MCP23016_OLAT1+
	   #:+MCP23016_IPOL0+
	   #:+MCP23016_IPOL1+
	   #:+MCP23016_IODIR0+
	   #:+MCP23016_IODIR1+
	   #:+MCP23016_INTCAP0+
	   #:+MCP23016_INTCAP1+
	   #:+MCP23016_IOCON0+
	   #:+MCP23016_IOCON1+

	   ;; Bits in the IOCON register

	   #:+IOCON_IARES+

	   ;; Default initialisation mode

	   #:+IOCON_INIT+


	   ))

