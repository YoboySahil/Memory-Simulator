# Memory-Simulator
A Verilog-based Simulator of a Set-Associative Cache and Memory Interaction.

## Requirements
- C++ and Verilog should be installed in order to run all needed files.

## Steps to write and run code
1. Write your program in `code.txt` file as per the instruction set mentioned below, in the same directory as all the source code files. Alternatively you can generate random instructions using `generator.cpp`.
2. Now compile and run the `memory_assembler.cpp` file. This will convert the code in `code.txt` to `code.bin` (Machine code for the written instructions).
3. Now compile and run the `cache_memory.v` file, cache hit and miss are displayed with the value sent to the processor (in case of read) in the output window.

## Instruction Set and other details

To read from memory address 20(say): 
`rd 20`

To write 100 in memory address 24(say): 
`wr 24 100`


- Comments can be written without any syntax before `{` and after `}`.
- Total Main-Memory's size is set to 1024 x 4 x 32 bits (16kB)
- The Cache size is set to 8 x 4 x 4 x 32 bits (512B)
- The Set-Associative Cache currently implemented is 4-Way Set Associative.

## Contributors
Sahil Safy, Tanmay Shrivastav, Anikesh Parashar, Sanidhya Singh, Prerna, Ayushka Sahu.

Made as Course Project for CSN221, Autumn Semester 2022 (IITR)