MIPS-Processor
==============

MIPS processor written in VHDL for the Xilinx Spartan 6 FPGA.

The processor project is devided into 3 parsts and accounts for 50% of the grade in Computer Design course at NTNU ([TDT4255](http://www.ntnu.edu/studies/courses/TDT4255)).

## Part 1: multicycle MIPS processor

The suggested architecture for the simple multi-cycle MIPS processor is depicted in the figure bellow. Major components of the processor are a program counter, an instruction decoder, a control unit, a register file, a memory module (used to implement both the instruction and data memories), and an ALU. All these modules are implemented individually and then combined to form the MIPS processor. The VHDL implementations of the ALU, the register file and the memory module will be provided as supporting files.

![Simple multi-cycle MIPS processor](https://raw.github.com/Starefossen/mips-processor/master/docs/mips_multisycle.png?login=Starefossen&token=747f3099fb1d20cc7906920cda4e2f2d)

## Part 2: pipelined MIPS processor

In the second part the processor is extend by changing the datapath to a pipeline. This means that we will need to add pipeline registers and make a new control module which accommodates the pipeline processing. All hazards are handled through software so we don’t need to implement the hazard detection and controlling module. This will be added in Part 3.

![Pipelined MIPS processor](https://raw.github.com/Starefossen/mips-processor/master/docs/mips_pipeline.png?login=Starefossen&token=b29707db05f9504e830b644881def7e1)