Page: 2kB + 64B OOB<br>
Block: 64page<br>
Plane: 1024block: 64kpage<br>
Die: 2 plane: 125k page<br>
Bus width: 8-bit<br>
Total: 256MB<br>

REGISTERS MAP
| No | Register offset | Register name | RW | Function               |
|----|-----------------|---------------|----|------------------------|
| 1  | 0x00            | CONTROL       | RW | Control register       |
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


COMMANDS
| No | Command               | O/M | 1st cycle | 2nd cycle |  cmd  |
|----|-----------------------|-----|-----------|-----------|-------|
| 1  | Read page             | M   | 00h       | 30h       | 0001  |
| 2  | Change read column    | M   | 05h       | 35h       | 0011  |
| 3  | Block erase           | M   | 60h       | D0h       | 0010  |
| 4  | Read status           | M   | 70h       |           | 0110  |
| 5  | Page program          | M   | 80h       | 10h       | 0111  |
| 6  | Change write column   | M   | 85h       |           | 0101  |
| 7  | Read ID               | M   | 90h       |           | 0100  |
| 8  | Read parameter page   | M   | ECh       |           | 1100  |
| 9  | Reset                 | M   | FFh       |           | 1101  |
| 10 | Read cache random     | O   | 00h       | 31h       | 1111  |
| 11 | Read cache sequential | O   | 31h       |           | 1110  |
| 12 | Read cache end        | O   | 3Fh       |           | 1010  |
