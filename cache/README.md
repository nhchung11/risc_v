**2-way Set-associative Cache**
<br>
Instruction memory size : 4kB<br>
Physical Address        : 12 bit<br>
Block size              : 8B -> Offset: 3 bit<br>
Block number            : 2^12 / 2^3 = 2^9<br>
Cache size              : 2^9<br>
Number of cache line    : 2^9 / 2^3 = 2^6<br>
Number of set           : 2^6/2^1 = 2^5 = 32<br>
<br>
|                       12 bit                          |<br>
|   4 bit tag   |   5 bit set   |   3 bit B/L offset    |<br>
