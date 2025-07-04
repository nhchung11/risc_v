## **2-way Set-associative Cache Design**

### **System Specifications**
| Parameter               | Value               | Notes                          |
|-------------------------|---------------------|--------------------------------|
| Instruction Memory Size | 4kB                 | = 2<sup>12</sup> bytes         |
| Instruction Cache Size  | 1kB                 | = 2<sup>10</sup> bytes         |
| Physical Address Width  | 12 bits             | Covers full 4kB memory space   |
| Block Size              | 16B                 | = 2<sup>4</sup> bytes          |
| Offset Bits             | 4 bits              | log<sub>2</sub>(16) = 4        |
| Number of Blocks        | 256                 | 4kB/16B = 2<sup>8</sup> blocks |
| Number of Cache Lines   | 64                  | 1kB/16B = 2<sup>6</sup> lines  |
| Associativity           | 2-way               | 2 lines per set                |
| Number of Sets          | 32                  | 64/2 = 2<sup>5</sup> sets      |

### **12-bit Physical Address Breakdown**

| Bit Range  | Field    | Size   | Description                     |
|------------|----------|--------|---------------------------------|
| 11:8       | Tag      | 4-bit  | Identifies block in main memory |
| 7:3        | Set      | 5-bit  | Selects which cache set (0-31)  |
| 2:0        | Offset   | 3-bit  | Byte within block (0-7)         |
