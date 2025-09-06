| No | Register offset | Register name | RW | Function               |
|----|-----------------|---------------|----|------------------------|
| 1  | 0x00            | CMD           | RW | Command                |
| 2  | 0x04            | STATUS        | RO | Status register        |
| 3  | 0x08            | COMMAND       | RW | Command register       |
| 4  | 0x0C            | ADDR0         | RW | Address bytes          |
| 5  | 0x10            | ADDR1         | RW | Address bytes          |
| 6  | 0x14            | ADDR2         | RW | Extra cycles if needed |
| 7  | 0x18            | DATA_TX       | RW | FIFO for data in       |
| 8  | 0x1C            | DATA_RX       | RO | FIFO for data out      |
| 9  | 0x20            | FITO_STATUS   | RW | FIFO status            |
| 10 | 0x24            | ECC_CTRL      | RW | ECC engine control     |
| 11 | 0x28            | ECC_STATUS    | RO | ECC results            |
| 12 | 0x2C            | TIMING_CFG    | RW | Timing parameters      |
| 13 | 0x30            | DMA_CTRL      | RW | DMA control            |
| 14 | 0x34            | INT_STATUS    | RW | Interupt flags         |
| 15 | 0x38            | INT_MASK      | RW | Interupt enable/mask   |
| 16 | 0x3C            | BAD_BLOCK_REG | RO | Bad block bits         |
| 17 | 0x40            | CONFIG        | RW | Config                 |