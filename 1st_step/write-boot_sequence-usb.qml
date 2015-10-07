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

        print("-I- === Set GPBR_0 as boot configuration word ===")
        var BSC_CR = 0xf8048054
        var BSC_CR_WPKEY = 0x6683 << 16
        var BSC_CR_GPBR_VALID = 1 << 2
        port.writeu32(BSC_CR, BSC_CR_WPKEY | BSC_CR_GPBR_VALID | 0)

        print("-I- === Load GPBR_0 with external boot from SPI0 configuration ===")
        // Enable external boot only on SPI0
        var GPBR_0 = 0xf8045400
        var EXT_MEM_BOOT_ENABLE = 1 << 18
        var SDMMC_1_DISABLE = 1 << 11
        var SDMMC_0_DISABLE = 1 << 10
        var NFC_DISABLE = 2 << 8
        var SPI_1_DISABLE = 3 << 6
        var QSPI_1_DISABLE = 3 << 2
        var QSPI_0_DISABLE = 3 << 0
        port.writeu32(GPBR_0, EXT_MEM_BOOT_ENABLE | SDMMC_1_DISABLE |
                      SDMMC_0_DISABLE | NFC_DISABLE | SPI_1_DISABLE |
                      QSPI_1_DISABLE | QSPI_0_DISABLE)

        print("-I- === Done. ===")
        print("Closing SAMBA connection")
        port.disconnect()

        print("Exiting")
    }
}
