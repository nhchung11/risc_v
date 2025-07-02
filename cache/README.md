2-way Set-associative Cache

Instruction memory size : 4kB
Physical Address        : 12 bit
Block size              : 8B -> Offset: 3 bit
Block number            : 2^12 / 2^3 = 2^9 
Cache size              : 2^9 
Number of cache line    : 2^9 / 2^3 = 2^6
Number of set           : 2^6/2^1 = 2^5 = 32

|                       12 bit                          |
|   4 bit tag   |   5 bit set   |   3 bit B/L offset    |
