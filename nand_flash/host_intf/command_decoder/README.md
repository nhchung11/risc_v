| No | Command               | O/M | 1st cycle | 2nd cycle |
|----|-----------------------|-----|-----------|-----------|
| 1  | Read                  | M   | 00h       | 30h       |
| 2  | Change read column    | M   | 05h       | 35h       |
| 3  | Block erase           | M   | 60h       | D0h       |
| 4  | Read status           | M   | 70h       |           |
| 5  | Page program          | M   | 80h       | 10h       |
| 6  | Change write column   | M   | 85h       |           |
| 7  | Read ID               | M   | 90h       |           |
| 8  | Read parameter page   | M   | ECh       |           |
| 9  | Reset                 | M   | FFh       |           |
| 10 | Read cache random     | O   | 00h       | 31h       |
| 11 | Read cache sequential | O   | 31h       |           |
| 12 | Read cache end        | O   | 3Fh       |           |
