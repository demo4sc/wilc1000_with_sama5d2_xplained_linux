import SAMBA 1.0

Script {
    onScriptStarted: {
        print("Opening SAMBA connection")
        var port = samba.connection('at91').ports[0]
        if (!port) {
            print("-E- === Error cannot find proper AT91 USB connection ===")
            return
        }
        var status = port.connect()
        if (!status) {
            print("-E- === Error connecting to the chip ===")
            return
        }

        var device = samba.device("sama5d2")

        // Reconfigure L2-Cache as SRAM
        var SFR_L2CC_HRAMC = 0xf8030058
        port.writeu32(SFR_L2CC_HRAMC, 0)

        // serialflash
        print("-I- === Initialize SPI flash access ===")
        port.writeApplet(device.applet("serialflash"))
        status = port.executeApplet(Applet.CmdInit, 0)
        if (status === 0)
        {
            // erase first 64K block
            "-I- === Erase all the NAND flash blocs and test the erasing ==="
            port.executeApplet(8, 0)

            print("-I- === Load AT91Bootstrap in the first sector ===")
            port.executeAppletWrite(0x000000, "at91bootstrap-sama5d2_xplained.bin")
            print("-I- === Load u-boot environment ===")
            port.executeAppletWrite(0x004000, "u-boot-env.bin")
            print("-I- === Load u-boot ===")
            port.executeAppletWrite(0x008000, "u-boot-sama5d2-xplained.bin")
            print("-I- === Load Kernel image and device tree database ===")
            port.executeAppletWrite(0x060000, "at91-sama5d2_xplained.dtb")
            status = port.executeAppletWrite(0x06c000, "zImage")
            if (!status)
                print("-E- === Error writing file to SPI flash ===")
                return
        } else {
            print("-E- === SPI flash access error = " + status + " ===")
            return
        }

        print("-I- === Done. ===")
        print("Closing SAMBA connection")
        port.disconnect()

        print("Exiting")
    }
}
