import SAMBA 3.0
import SAMBA.Connection.Serial 3.0
import SAMBA.Device.SAMA5D2 3.0

AppletLoader {
	connection: SerialConnection {
	}

	device: SAMA5D2 {
	}

	onConnectionOpened: {
		print("-I- === Initialize SPI flash access ===")
		appletInitialize("serialflash")

		// erase all memory
		print("-I- === Erase all the flash ===")
		appletErase(0, connection.applet.memorySize)

		// write files
		print("-I- === Load AT91Bootstrap in the first sector ===")
		appletWrite(0x00000, "at91bootstrap.bin", true)

		print("-I- === Load u-boot environment ===")
		appletWrite(0x06000, "u-boot-env.bin")

		print("-I- === Load u-boot ===")
		appletWrite(0x08000, "u-boot.bin")

		print("-I- === Load device tree database ===")
		appletWrite(0x6f000, "at91-sama5d2_xplained.dtb")

		print("-I- === Load Kernel image ===")
		appletWrite(0x77000, "zImage")

		print("-I- === Done. ===")
	}
}
