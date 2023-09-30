# TDS3000 series oscilloscope floppy drive replacement with Gotek/FlashFloppy

TDS3000 series scopes are still pretty capable instruments and have life left in them but floppy drives most were equipped with overstayed their welcome a while ago. This guide describes the replacement of the [TDS3032B](/Images/TDS3032B_Before.jpg) oscilloscope [floppy drive](/Images/FloppyDrive.jpg) with the Gotek floppy emulator.

## Compatible Scopes

This will work with the:

- Tektronix TDS3000 series. This series includes the TDS3012, [TDS3032 (tested)][], TDS3052, TDS3014, TDS3034, and TDS3054
- Agilent 54600 series. This series includes the 54621A, 54621D, [54622A (tested)][], 54622D, 54624A, 54641A, 54641D, 54642A, and 54642D
   - Comes with the TEAC FD-05HF drive stock

[TDS3032 (tested)]: https://github.com/andrewpono/TDS3000-Series-Gotek-FlashFloppy/blob/main/Images/TDS3032B_After.jpg
[54622A (tested)]: https://github.com/keirf/FlashFloppy/issues/155#issuecomment-1270752948

## Hardware

  * Gotek floppy emulator. Some are advertised as Tektronix scope specific but are pretty expensive. We'll take a DIY route: get the cheapest Gotek embroidery machine 26 pin FFC type emulator, at the time of this writing it's either SFR1M44-DU26 or SFR720-DU26 (also known as KP-DU26 or "Floppy Drive Emulator fit for Barudan embroidery machine 720kb DD with 26pin FFC"). These are the same, PCB marked SFRC2D.A (STM CPU) or SFRC2D.B (Artery CPU), except for stock FW. 720K models are cheaper and easier to get, but probably unusable as is, 1.44M reportedly is usable even with stock FW.
  * The 26 pin 1mm pitch flex cable has to have contacts on opposite sides. Some scopes use that, but stock one may be too stiff to reconfigure for use with the emulator. Get the [flex cable](https://www.digikey.com/en/products/detail/w%C3%BCrth-elektronik/686726152001/4573371).

## FlashFloppy

Emulator needs to be flashed with [FlashFloppy firmware](https://github.com/keirf/FlashFloppy). Follow [FlashFloppy wiki](https://github.com/keirf/FlashFloppy/wiki) guides. At the time of this writing Gotek emulators shipped are likely to use [Artery CPU](/Images/ArteryChip.jpg). USB drivers for that chip come as an installer, I unpacked them to [here](/ArteryDrivers) for examination/use.

After flashing, RA, RB & RC 0-Ohm jumpers have to be [removed](/Images/PCB_Jumpers.jpg). Also remove JD and JE [jumpers](/Images/Back_Jumpers.jpg) from the header at the back, leave S1 jumper in place. Useful info can be found [here](https://github.com/keirf/FlashFloppy/issues/155).

## Installation

Take scope back cover off. Watch a video on how to get the handle off, contrary to some reports mine was easy to remove with serrated jaw needle nose pliers. Once the cover is off, floppy drive falls out. Disconnect the flex cable from the scope and put it aside. Dry fit the emulator. Chances are it'll sit a bit too high for the USB connector to be accessible. Cut the [plastic stops](/Images/MechMod_Tek.jpg) to about half-size with a knife or side cutters. Shave [corners](/Images/MechMod_Gotek3.jpg) of the emulator enclosure to allow it to sit lower in the scope. Once happy with the [fit](/Images/TDS3032B_After.jpg), connect new flex cable and reassemble the scope. 

## Usage

Format USB drive to FAT32 and copy a [formatted floppy image](1m44_fat12.img) to it. No other files need to be added, the emulator will add one more file on its own to keep track of the last image used. More image files can be added to increase capacity, but it is not necessary (a [png image from the scope](/Images/TEK00001.PNG) takes only a few kB). To get the files from the USB drive plug it into the PC and extract the floppy image file with 7zip or other disk image utility. One alternative is [this](http://www.fysnet.net/ultimate/index.htm) excellent utility. Both can be run from the USB drive. Scope can be set to save preconfigured reports to the floppy using Hard Copy button located to the left of the screen. Configuration of the report is done with the Utility button.
