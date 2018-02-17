## ALU (```alu.vhd```)

* Inputs: two 32 bit operands, operation to be performed, carry
* Outputs: 32 bit result of arithmetic/logical operation, next flag values

It is a combinational circuit that performs the arithmetic/logical operations for the DP instructions. The “operation to be  performed” input can come from the opcode field of DP instructions

## Shifter (```shifter.vhd```)
* Inputs: 32 bit data to be shifted, shift type (LSL|LSR|ASR|ROR) and shift amount
* Outputs: 32 bit data after shifting, shifter carry
It  is  a  combinational  circuit  that  performs  the  required  shift  operation  by  the  specified number of bits. This serves the purpose for DP and DT instructions requiring shift. It also outputs  shifter  carry. Which carry (ALU or shifter) is to be used for updating the carry flag is decided elsewhere.

## Multiplier (```multiplier.vhd```)
* Inputs: Two 32 bit operands
* Outputs: One 32 bit result

## Register Files (```register.vhd```)
* Inputs: 32 bit data to be written, two 4 bit read addresses, one 4 bit write address, clock, reset, write enable
* Outputs: two 32 bit data outputs, PC output

## Processor Memory path (```processor_memory.vhd```)
* Inputs: 32 bit data from processor, 32 bit data from memory, type of DT instruction, byte offset in memory address
* Outputs: 32 bit data to processor, 32 bit data to memory, memory write enable signals

## Memory (```memory.vhd```)