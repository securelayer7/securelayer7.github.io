+++
title = "Reading data from EEPROM without desoldering"
date = "2019-07-17"
author = "CJHackerz, Shubham Chougule"
cover = "img/IMG_20190716_121835.jpg"
tags = ["IoT", "Hardware", "Cybersecurity"]
description = "EEPROM is read-only non-volatile memory whose contents can be erased and reprogrammed using a pulsed voltage often time used in embedded systems (network routers) and smart IoT devices. EEPROM holds firmware data and bootloader, in this post we will explore non-destructive way to read data from EEPROM for security assements purposes."
showFullContent = false
+++

## Introduction

In IoT/Hardware security it is common practice of dumping firmware/bootloader data inorder to perform reverse engineering for closed source system applications.

Well known easiest way is to download .bin/.zip (packed firmware) files from device manufacturer's website which they provide to end users for firmware upgrade operations. And later us hackers/security researchers throw these files to reverse engineering softwares such as binwalk to check it's contents and extract the needed stuff. But there are some challenges to this method as more and more embedded device manufacturers are becoming aware of it:

* __Availability:__ Some companies only allow to obtain firmware files for update if you are a registered parnter with them and you need to get login creds or device manufacturer is too lazy that never provided any update for the device so you can't find those file anywhere online.
* __Encryption:__ It's been becoming a big headache lately since companies have started pushing strongly encrypted firmware files with unbrekable symmetric ciphers such as AES which makes reverse engineering task nightmare. There are ways to find encryption key in previous updates of firmware [CheckThisOut](https://www.youtube.com/watch?v=4urMITJKQQs) but if it is stored on hardware part of the secure element chip (STM32) then no way you can retive the key.

## The new easy way

{{< figure src="/img/IMG_20190716_122847.jpg" alt="SOIC8 Adapter" position="center" style="border-radius: 10px;" caption="SOIC8 Adapter" captionPosition="center" captionStyle="color: white;" >}}

Meet SOIC8, it's programming chip which allows embedded software developers to test EEPROM chips not just you can write changes with it but also read existing data from there or you can say dump the firmware easily. You can order one with clip adapter from [AliExpress](https://www.aliexpress.com/item/SOIC8-SOP8-Test-Clip-For-EEPROM-93CXX-25CXX-24CXX-in-circuit-programming-New/1956963818.html) for roughly around 5$. Behind SOIC8 this there are 8 more pins which will be used to connect SPI communication device (In our case RaspberryPi).

Now next step is to indetify model number of our EEPROM chip and it's orientation on PCB, challange here is small size. Due to thier very small size it is often impossible to see the text written on the chip with naked eyes. What you can do is use soldering microscope or if you don't have one you can use camera of your smart phone along with flash light hold at 45 degree angle for best viewing experince since direct flash light on chip will make hard to see the text. For Android users I would like to recommend this app called [OpenCamera](https://play.google.com/store/apps/details?id=net.sourceforge.opencamera) which will allow you to control focus and ISO settings along with adjustments of noise filtering algorithms.

{{< figure src="/img/IMG_20190716_131249.png" alt="Winbond EEPROM" position="center" style="border-radius: 10px;" caption="Picture of Winbond EEPROM taken in OpenCamera" captionPosition="center" captionStyle="color: white;" >}}

Gotcha it's [Winbond 25q128fvsg](https://www.winbond.com/resource-files/w25q128fv_revhh1_100913_website1.pdf) from datasheet __Figure 1a__ we now know exact pin numbers and what they do. And basically location of cirular notch is exactly where pin 1 is situated (bottom left in above picture).

Now power on your target device and put SOIC8 adapter clip in such way that red wire lands on pin1 of EEPROM. And start making connetions on RaspberryPi device according to table below (Number refers to Physical pins): 

|RaspberryPi|Winbond EEPROM|
|:---------:|:------------:|
|24         |1             |
|35         |2             |
|-          |3             |
|6          |4             |
|38         |5             |
|40         |6             |
|-          |7             |
|1          |8             |

__Check out [RaspberryPi pin config](https://pinout.xyz)__

Once done power on your RaspberryPi open terminal and Type following. Please note you should be using official [RaspbianOS](https://www.raspberrypi.org/downloads/raspbian/)

```bash
sudo raspi-config
```

You will be presented with menu, go to Interfacing options and then enable SPI interface and then reboot.

{{< figure src="https://cdn.sparkfun.com/assets/learn_tutorials/4/4/9/spi-menu2.png" alt="Raspi-config menu" position="center" style="border-radius: 10px;" caption="Interfacing option in Raspi-config" captionPosition="center" captionStyle="color: white;" >}}

Once done now you have to get software in order to read and write from EEPROM memory, use following command below to get it easily:

```bash
sudo apt install flashrom -y
```

Now you are ready to start reading data from target EEPROM with flashrom

```bash
flashrom -p linux_spi:dev=/dev/spidev0.0,spispeed=512 -r filename.bin
```

Wait few minutes (15-30min approx)

{{< figure src="/img/spi_dump_success-screenshot.jpeg" alt="spi-dump-sucess-screenshot" position="center" style="border-radius: 10px;" caption="Screenshot of successful firmware dump" captionPosition="center" captionStyle="color: white;" >}}

## Conclusions

With help of this method you avoid damaging your EEPROM chip and save lot's time of soldering and desoldering.

__Honourable references:__

* [RaspberryPi as poor man's hardware hacking tool](https://payatu.com/using-rasberrypi-as-poor-mans-hardware-hacking-tool/)