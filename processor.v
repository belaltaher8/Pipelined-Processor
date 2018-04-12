/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB,                   // I: Data from port B of regfile
 
);
     // Control signals
     input clock, reset;
     
     // Imem
     output [11:0] address_imem;
     input [31:0] q_imem;
     
     // Dmem
     output [11:0] address_dmem;
     output [31:0] data;
     output wren;
     input [31:0] q_dmem;
     
     // Regfile
     output ctrl_writeEnable;
     output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
     output [31:0] data_writeReg;
     input [31:0] data_readRegA, data_readRegB;
     
     
     
	 
///////////////////////////////////////////////////////////////////////////////////////////////////////////	 
	 //FETCH
     
     wire [11:0] tempPC_input, tempPC_input2, tempPC_input3;
     wire [11:0] nextDefaultPC, PC_input;
     wire PCResetSig;
	 wire PCresetCase2;
	 wire stallControl;
	  
	 and PCResetCase2Gate(PCresetCase2, PC_input[11], PC_input[10], PC_input[9], PC_input[8], PC_input[7], PC_input[6], PC_input[5], PC_input[4], PC_input[3], PC_input[2], PC_input[1], PC_input[0]); 
	  
     or PCResetGate(PCResetSig, reset, PCresetCase2);
	  
	 //PC    
	 my_12bit_register myPC(PC_input, clock, 1'b1, address_imem, PCResetSig);	 
	 
	 
	 
	 
	 //PC Adder
     wire [31:0] pcAdderInputB;
     
     my_32bit2to1_mux pcAdderInputMux(32'b00000000000000000000000000000001, 32'b11111111111111111111111111111111, pcAdderInputB, stallControl);
	 my_ALU_adder myPCAdder(address_imem, pcAdderInputB, 1'b0, nextDefaultPC);
      
	 
	 
	 
	 //PC MUX for jumps
	 wire jumpControlSignal, TSignal;
	 wire [11:0] target;
     
	 or myTOr(TSignal, jumpControlSignal, bexControl);
	 my_12bit2to1_mux PCMUX(nextDefaultPC, target, tempPC_input, TSignal);
	 
	 
     //PC MUX for branching
	 wire [12:0] branchAddress;
	  
	 my_12bit2to1_mux BranchMux(tempPC_input, branchAddress, tempPC_input2, branchControl);
	  
      
     //PC MUX for JR
     my_12bit2to1_mux JRMux(tempPC_input2, realALU_inputA, PC_input, jrControlSignal);
	  
	  
	 //Checks if we should insert no ops
	 wire noOpSignal;
     wire tempnoOpSignal, secondnoOpSignal;
	  
	 or myNoOpOr(tempnoOpSignal, branchControl, jumpControlSignal, jrControlSignal, bexControl);
     
     or myNoOpOr2(noOpSignal, tempnoOpSignal, secondnoOpSignal);
     
     dflipflop noOpFlipFlop(tempnoOpSignal, reset, 1'b1, clock, secondnoOpSignal);
	  
	 
	 //Saves register file instruction in latch
	 wire [31:0] decodeInsn, tempq_imem;
     wire [31:0] realq_imem;
	 wire [11:0] PCLatch1_output;
	 
	 
	 //NoOp mux
	 my_32bit2to1_mux noOpMux1(q_imem, 32'b00000000000000000000000000000000, tempq_imem, noOpSignal);
     my_32bit2to1_mux noOpMuxStall(tempq_imem, 32'b00000000000000000000000000000000, realq_imem, stallControl);
	 
	 
	 //IR Latch
	 my_32bit_register IRLatch(realq_imem, clock, 1'b1, decodeInsn, reset); 
	 
	 
	 //PC Latch
	 my_12bit_register PCLatch1(address_imem, clock, 1'b1, PCLatch1_output, reset);
     
     wire swFetch;
     
     and myswFetch(swFetch, ~q_imem[31], q_imem[30], ~q_imem[29], ~q_imem[28], ~q_imem[27]); //01000
	 
	 
///////////////////////////////////////////////////////////////////////////////////////////////////////////
     //DECODE

	 //F/D LATCH
	 
     
     
     //Decode all the important information of all the possible commands
     wire [4:0]  opcodeBitsDecode, rdDecode, rsDecode, rtDecode, shamtDecode, ALUopDecode;
     wire [16:0] immediateDecode;
     wire [26:0] targetDecode;
	  
     genvar a;
	 generate
		for(a = 31; a >= 27; a = a-1) begin: opcodeExtraction
            assign opcodeBitsDecode[a-27] = decodeInsn[a];
		end
	 endgenerate
     
     genvar b;
	 generate
		for(b = 26; b >= 22; b = b-1) begin: rdExtraction
            assign rdDecode[b-22] = decodeInsn[b];
		end
	 endgenerate
     
     genvar c;
	 generate
		for(c = 21; c >= 17; c = c-1) begin: rsExtraction
            assign rsDecode[c-17] = decodeInsn[c];
		end
	 endgenerate
     
     genvar d;
	 generate
		for(d = 16; d >= 12; d = d-1) begin: rtExtraction
            assign rtDecode[d-12] = decodeInsn[d];
		end
	 endgenerate
     
     genvar e;
	 generate
		for(e = 11; e >= 7; e = e-1) begin: shamtExtraction
            assign shamtDecode[e-7] = decodeInsn[e];
		end
	 endgenerate
     
     genvar f;
	 generate
		for(f = 6; f >= 2; f = f-1) begin: ALUOpExtraction
            assign ALUopDecode[f-2] = decodeInsn[f];
		end
	 endgenerate
     
     genvar g;
	 generate
		for(g = 16; g >= 0; g = g-1) begin: ImmediateExtraction
            assign immediateDecode[g] = decodeInsn[g];
		end
	 endgenerate
     
     genvar h;
	 generate
		for(h = 26; h >= 0; h = h-1) begin: TargetExtraction
            assign targetDecode[h] = decodeInsn[h];
		end
	 endgenerate
	 
	 
	 //Decodes all the possible opcodes
	 wire ALUDecode, addiDecode, swDecode, lwDecode, jDecode, bneDecode, jalDecode, jrDecode, bltDecode, bexDecode, setxDecode;
     wire ALUsubDecode;
	  
	 and opcodeExtraction1(ALUDecode,   ~opcodeBitsDecode[4], ~opcodeBitsDecode[3], ~opcodeBitsDecode[2], ~opcodeBitsDecode[1], ~opcodeBitsDecode[0]); //00000 ALU
	 and opcodeExtraction2(addiDecode,  ~opcodeBitsDecode[4], ~opcodeBitsDecode[3],  opcodeBitsDecode[2], ~opcodeBitsDecode[1],  opcodeBitsDecode[0]); //00101 addi
	 and opcodeExtraction3(swDecode,    ~opcodeBitsDecode[4], ~opcodeBitsDecode[3],  opcodeBitsDecode[2],  opcodeBitsDecode[1],  opcodeBitsDecode[0]); //00111 sw
	 and opcodeExtraction4(lwDecode,    ~opcodeBitsDecode[4],  opcodeBitsDecode[3], ~opcodeBitsDecode[2], ~opcodeBitsDecode[1], ~opcodeBitsDecode[0]); //01000 lw 
	 and opcodeExtraction5(jDecode,     ~opcodeBitsDecode[4], ~opcodeBitsDecode[3], ~opcodeBitsDecode[2], ~opcodeBitsDecode[1],  opcodeBitsDecode[0]); //00001 j
	 and opcodeExtraction6(bneDecode,   ~opcodeBitsDecode[4], ~opcodeBitsDecode[3], ~opcodeBitsDecode[2],  opcodeBitsDecode[1], ~opcodeBitsDecode[0]); //00010 bne
	 and opcodeExtraction7(jalDecode,   ~opcodeBitsDecode[4], ~opcodeBitsDecode[3], ~opcodeBitsDecode[2],  opcodeBitsDecode[1],  opcodeBitsDecode[0]); //00011 jal
	 and opcodeExtraction8(jrDecode,    ~opcodeBitsDecode[4], ~opcodeBitsDecode[3],  opcodeBitsDecode[2], ~opcodeBitsDecode[1], ~opcodeBitsDecode[0]); //00100 jr
	 and opcodeExtraction9(bltDecode,   ~opcodeBitsDecode[4], ~opcodeBitsDecode[3],  opcodeBitsDecode[2],  opcodeBitsDecode[1], ~opcodeBitsDecode[0]); //00110 blt
	 and opcodeExtraction10(bexDecode,   opcodeBitsDecode[4], ~opcodeBitsDecode[3],  opcodeBitsDecode[2],  opcodeBitsDecode[1], ~opcodeBitsDecode[0]); //10110 bex
	 and opcodeExtraction11(setxDecode,  opcodeBitsDecode[4], ~opcodeBitsDecode[3],  opcodeBitsDecode[2], ~opcodeBitsDecode[1],  opcodeBitsDecode[0]); //10101 setx 
	  
     and opcodeExtraction12(ALUsubDecode, ~ALUopDecode[4], ~ALUopDecode[3], ~ALUopDecode[2], ~ALUopDecode[1],  ALUopDecode[0]); //00001 ALU opcode for sub
     
	  
	 wire branchDecode, rdInA;
	 wire [4:0] tempctrl_readRegA, tempctrl_readRegB, tempctrl_readRegB2;
	  
	 or branchOr(branchDecode, bneDecode, bltDecode);
	 or rdInAOr(rdInA, branchDecode, jrDecode);
	  
     
     //ALU input A is either $rs or $rd so MUX between two
     //ALU input b is either $rt or $rd so MUX between two     
	 my_5bit2to1_mux myS2Mux(rtDecode, rdDecode, tempctrl_readRegB, swDecode);
	 my_5bit2to1_mux myS2Mux2(tempctrl_readRegB, 5'b00000, tempctrl_readRegB2, bexDecode);
     my_5bit2to1_mux myS2Mux3(tempctrl_readRegB2, rsDecode, ctrl_readRegB, branchDecode);
	  
	 my_5bit2to1_mux myS1Mux(rsDecode, rdDecode, tempctrl_readRegA, rdInA);
	 my_5bit2to1_mux myS1Mux2(tempctrl_readRegA, 5'b11110, ctrl_readRegA, bexDecode);
     
     
     //Calculate ALUinB control signal
     wire ALUinBSignal, ALUinBSignalDecode, tempALUinBSignalDecode;
	  
	 or myALUInBGate(tempALUinBSignalDecode, addiDecode, swDecode, lwDecode);
        
     assign ALUinBSignalDecode = noOpSignal ? 1'b0 : tempALUinBSignalDecode;   
     dflipflop aluInBLatch(ALUinBSignalDecode, reset, 1'b1, clock, ALUinBSignal);
     
	 
	  //Saves ALU inputs in latch
     wire [31:0] ALU_inputA;
     wire [31:0] realALU_inputB, ALU_output;
	 wire [31:0] ALU_inputB;
	 wire [11:0] PCLatch2_output;
     wire [4:0] tempALU_opcode;
     wire [4:0] ALU_opcode;
     wire [4:0] shamt;
     wire addiSignal;
	  
	  
	 //Extends immediate
     wire [31:0] immediateExtended, BMuxImmediate;
        
     my_17to32bit_extender mySignExtender(immediateDecode, immediateExtended);
     my_32bit_register immediateLatch(immediateExtended, clock, 1'b1, BMuxImmediate, reset);
	  
	  
	 //Rs1 Latch
	 wire [4:0] rs1Execute, rs1Input;
	 
     my_5bit2to1_mux rs1Mux(ctrl_readRegA, 5'b00000, rs1Input, noOpSignal);
	 my_5bit_register rs1Latch(rs1Input, clock, 1'b1, rs1Execute, reset);
	  
	  
	  //Rs2 Latch
	 wire [4:0] rs2Execute, rs2Input;
	  
     my_5bit2to1_mux rs2Mux(ctrl_readRegB, 5'b00000, rs2Input, noOpSignal);
	 my_5bit_register rs2Latch(rs2Input, clock, 1'b1, rs2Execute, reset);
     
	 
     
     //A latch  
     wire [31:0] ALatch_input;
     
     my_32bit2to1_mux AMux(data_readRegA, 32'b00000000000000000000000000000000, ALatch_input, noOpSignal);
	 my_32bit_register ALatch(ALatch_input, clock, 1'b1, ALU_inputA, reset);
     
	  
     //B latch
     wire [31:0] BLatch_input;
     
     my_32bit2to1_mux BMux(data_readRegB, 32'b00000000000000000000000000000000, BLatch_input, noOpSignal);
	 my_32bit_register BLatch1(BLatch_input, clock, 1'b1, ALU_inputB, reset);
      
      
     //PC latch 2
	 my_12bit_register PCLatch2(PCLatch1_output, clock, 1'b1, PCLatch2_output, reset);
	  
	  
     //ALU opcode Register
     wire [4:0] ALUopRegInput;
     
     my_5bit2to1_mux ALUopcodeRegMux(ALUopDecode, 5'b00000, ALUopRegInput, noOpSignal);
     my_5bit_register ALUopcodeReg(ALUopRegInput, clock, 1'b1, tempALU_opcode, reset);
     
     
     //Shamt register	  
     my_5bit_register shamtReg(shamtDecode, clock, 1'b1, shamt, reset);
	  
	  
     //addi flip flop
     wire addiFlipFlopInput;
     
     assign addiFlipFlopInput = noOpSignal ? 1'b0 : addiDecode;
     dflipflop myAddiFlipFlop(addiFlipFlopInput, reset, 1'b1, clock, addiSignal);
	  
	  
     //Wren Signal
	 wire wrenExecute, wrenFlipFlopInput;
	  
     assign wrenFlipFlopInput = noOpSignal ? 1'b0 : swDecode; 
     dflipflop mywrenFlipFlop(wrenFlipFlopInput, reset, 1'b1, clock, wrenExecute);  
	   
     
     //write mux control signal
     wire writeMuxControlSignalDecode, writeMuxControlSignalExecute, writeMuxControlSignalMem, writeMuxControlSignal, writeMuxInput;
     
     or writeMuxSignalGate(writeMuxControlSignalDecode, ALUDecode, addiDecode);
     
     assign writeMuxInput = noOpSignal ? 1'b0 : writeMuxControlSignalDecode;
     dflipflop myDecodeWriteMuxGate(writeMuxInput, reset, 1'b1, clock, writeMuxControlSignalExecute);
      
     
     //Control for write enable for regfile
     wire regFileWriteEnableDecode, tempregFileWriteEnableDecode, regFileWriteEnableExecute, regFileWriteEnableMem, regFileFlipFlopInput;
     
     or regFileOrWriteOr(regFileWriteEnableDecode, writeMuxControlSignalDecode, lwDecode, jalDecode, setxDecode);
     
     assign regFileFlipFlopInput = noOpSignal ? 1'b0 : regFileWriteEnableDecode;
	 dflipflop myDecodeRegFileWE(regFileFlipFlopInput, reset, 1'b1, clock, regFileWriteEnableExecute);
      
     
     //Control for register to write to for regfile
     wire rdControlBit;
     wire jalExecute, jalMem, jalWrite;
     wire [1:0] writeRegMuxControlBits;
     wire [4:0] tempctrl_writeRegDecode, ctrl_writeRegExecute, ctrl_writeRegMem, ctrl_writeRegDecode;
     
     or rdOr(rdControlBit, writeMuxControlSignalDecode, lwDecode);
	 
     assign writeRegMuxControlBits[1] = rdControlBit;
     assign writeRegMuxControlBits[0] = jalDecode;
     
     my_5bit4to1_mux writeRegMux(5'b11110, 5'b11111, rdDecode, 5'b00000, tempctrl_writeRegDecode, writeRegMuxControlBits);
     
     my_5bit2to1_mux writeRegMux2(tempctrl_writeRegDecode, 5'b00000, ctrl_writeRegDecode, noOpSignal);
     my_5bit_register myWriteRegMuxReg1(ctrl_writeRegDecode, clock, 1'b1, ctrl_writeRegExecute, reset);	  
	  
	  
	 //Control for jumping
	 wire jumpSignalDecode, tempjumpSignalDecode;
	  
	 or myJumpOr(tempjumpSignalDecode, jDecode, jalDecode);
	 
     assign jumpSignalDecode = noOpSignal ? 1'b0 : tempjumpSignalDecode;
	 dflipflop jumpFlipFlop(jumpSignalDecode, reset, 1'b1, clock, jumpControlSignal); 
	   
	  
	 //Control for jal (because we need to set r31 to PC + 1
     wire jalFlipFlopInput;
     
     assign jalFlipFlopInput = noOpSignal ? 1'b0 : jalDecode;
	 dflipflop jalFlipFlop(jalFlipFlopInput, reset, 1'b1, clock, jalExecute);
	   
	  
	 //Target latch
	 my_12bit_register targetLatch(targetDecode[11:0], clock, 1'b1, target, reset); 
	  
	  
	 //Control for branching
	 wire bltExecute, bneExecute, bltFlipFlopInput, bneFlipFlopInput;
	 
     assign bltFlipFlopInput = noOpSignal ? 1'b0 : bltDecode;
     assign bneFlipFlopInput = noOpSignal ? 1'b0 : bneDecode;
	 dflipflop mybltFlipFlop(bltFlipFlopInput, reset, 1'b1, clock, bltExecute);
	 dflipflop mybneFlipFlop(bneFlipFlopInput, reset, 1'b1, clock, bneExecute);
	  
	  
	 //jr latch
	 wire jrControlSignal, jrFlipFlopInput;
	  
     assign jrFlipFlopInput = noOpSignal ? 1'b0 : jrDecode; 
	 dflipflop myjrFlipFlop(jrFlipFlopInput, reset, 1'b1, clock, jrControlSignal);
	  
	  
	 //bex latch
	 wire bexExecute, bexFlipFlopInput;
     
     assign bexFlipFlopInput = noOpSignal ? 1'b0 : bexDecode;	  
	 dflipflop mybexFlipFlop(bexFlipFlopInput, reset, 1'b1, clock, bexExecute);
	  
	  
	 //set x latch
	 wire setxExecute, setxFlipFlopInput;
	  
     assign setxFlipFlopInput = noOpSignal ? 1'b0 : setxDecode; 
	 dflipflop mysetxFlipFlop(setxFlipFlopInput, reset, 1'b1, clock, setxExecute);	  
      
      
      
     //ALU sub latch
     wire ALUsubExecute, ALUsubInput;
     
     assign ALUsubInput = noOpSignal ? 1'b0 : ALUsubDecode;
     dflipflop myALUsubFlipFlop(ALUsubInput, reset, 1'b1, clock, ALUsubExecute);
     
     
     
     //Stall logic
     wire isRsRd, isRtRd;
     
     my_5bit_comparator stallComparator1(q_imem[21:17], rdDecode, isRsRd);
     my_5bit_comparator stallComparator2(q_imem[16:12], rdDecode, isRtRd);
     
     wire isRsRtRd, notswFetch;
     
     or myStallOr(isRsRtRd, isRsRd, isRtRd);
     not myNotswFetch(notswFetch, swFetch);
     
     and myStallAnd(stallControl, isRsRtRd, lwDecode, notswFetch);
     
     //lw latch
     
     wire lwExecute;
     
     dflipflop mylwFlipFlop(lwDecode, reset, 1'b1, clock, lwExecute);
        
      
	  
	  
	  
     
     
///////////////////////////////////////////////////////////////////////////////////////////////////////////
     //EXECUTE
      
     //D/X LATCH
	 
     
     
     //MUX between output B from regfile (either rs or rd) and immediate
	 wire [31:0] tempALU_inputB;
     wire [31:0] realALU_inputA;
	 
	 my_32bit2to1_mux ALUInputBMux(ALU_inputB, BMuxImmediate, tempALU_inputB, ALUinBSignal);
	 
     wire [4:0] tempALU_opcode2;
     
     //MUX between the ALU opcode specified in IR and 00000 (00000) is chosen if it is an addi
     wire forceAdd;
     or myForceAddOr(forceAdd, addiSignal, wrenExecute, lwExecute);
     my_5bit2to1_mux ALUOpcodeMux(tempALU_opcode, 5'b00000, tempALU_opcode2, forceAdd);
     
     wire shouldSubSignal;
     or shouldSubtractGate(shouldSubSignal, bltExecute);
     my_5bit2to1_mux ALUOpcodeMux2(tempALU_opcode2, 5'b00001, ALU_opcode, shouldSubSignal);
	 
     
	  //MUX for bypassing input A
	 wire comparator1Output, bypassMux1HigherBit, comparator2Output, bypassMux1LowerBit;
	 wire [1:0] bypassMux1SelectBits;
	  
	 my_5bit_comparator comparator1(rs1Execute, ctrl_writeReg, comparator1Output);
	 and myComparator1And(bypassMux1HigherBit, comparator1Output, ctrl_writeEnable);
	 
	 my_5bit_comparator comparator2(rs1Execute, ctrl_writeRegMem, comparator2Output);
	 and myComparator2And(bypassMux1LowerBit, comparator2Output, regFileWriteEnableMem);
	  
	 assign bypassMux1SelectBits[1] = bypassMux1HigherBit;
	 assign bypassMux1SelectBits[0] = bypassMux1LowerBit;
	  
	 my_32bit4to1_mux bypassMux1(ALU_inputA, OLatch_output, data_writeReg, OLatch_output, realALU_inputA, bypassMux1SelectBits);
	  
	  
	  
	  //MUX for bypassing input B
	 wire comparator3Output, bypassMux2HigherBit, comparator4Output, bypassMux2LowerBit;
	 wire [1:0] bypassMux2SelectBits;
	  
	 my_5bit_comparator comparator3(rs2Execute, ctrl_writeReg, comparator3Output);
	 and myComparator3And(bypassMux2HigherBit, comparator3Output, ctrl_writeEnable);
	 
	 my_5bit_comparator comparator4(rs2Execute, ctrl_writeRegMem, comparator4Output);
	 and myComparator4And(bypassMux2LowerBit, comparator4Output, regFileWriteEnableMem);
	  
	 assign bypassMux2SelectBits[1] = bypassMux2HigherBit;
	 assign bypassMux2SelectBits[0] = bypassMux2LowerBit;
	  
	 my_32bit4to1_mux bypassMux2(tempALU_inputB, OLatch_output, data_writeReg, OLatch_output, realALU_inputB, bypassMux2SelectBits);
	  
	  
     
	  //Actual ALU
     wire ALU_lessThan;
     wire ALU_overflow;
     
     wire ALU_notEqual;
	 alu myALU(realALU_inputA, realALU_inputB, ALU_opcode, shamt, ALU_output, ALU_notEqual, ALU_lessThan, ALU_overflow);
	 
     
     
     //TODO BRANCHING (basically AND the ALU notEqual with control ORRRR lessThan with control)
     wire bltControl;
     wire branchControl, bneControl, bexControl;
	  
	 and mybneControlAnd(bneControl, bneExecute, ALU_notEqual);
	 and mybltControlAnd(bltControl, bltExecute, ALU_lessThan);
	 and mybexControlAnd(bexControl, bexExecute, ALU_notEqual);
	  
	 or myBranchControlOr(branchControl, bneControl, bltControl);
	  
	 wire [31:0] extendedPC;
     
	  
	 my_12to32bit_extender PCExtender(PCLatch2_output, extendedPC);
	 my_ALU_adder branchAdder(extendedPC, BMuxImmediate, 1'b0, branchAddress);
     
     
     
     //O latch
     wire [31:0] OLatch_output;
     my_32bit_register OLatch(ALU_output, clock, 1'b1, OLatch_output, reset);
     
     
     //B latch 2
	  wire [31:0] BLatch_output;
     my_32bit_register BLatch2(ALU_inputB, clock, 1'b1, BLatch_output, reset);
     
     
     //Wren flip flop
     dflipflop mywrenFlipFlop2(wrenExecute, reset, 1'b1, clock, wren); 
     
     
     //Write mux control signal flip flop 2
     dflipflop myDecodeWriteMuxGate2(writeMuxControlSignalExecute, reset, 1'b1, clock, writeMuxControlSignalMem);
     
     
     //Control for write enable for regfile 2
     dflipflop myDecodeRegFileWE2(regFileWriteEnableExecute, reset, 1'b1, clock, regFileWriteEnableMem);
     
     
     //Control for write register for regfile 2
     my_5bit_register myWriteRegMuxReg2(ctrl_writeRegExecute, clock, 1'b1, ctrl_writeRegMem, reset);
	  
	  
	  //PC Latch 3
	 wire [11:0] PCLatch3_output;
	  
	 my_12bit_register PCLatch3(PCLatch2_output, clock, 1'b1, PCLatch3_output, reset);
	  
	  
	 //Control for jal (because we need to set r31 to PC + 1 
	 dflipflop jalFlipFlop2(jalExecute, reset, 1'b1, clock, jalMem);
	  
	  
	 //setx flip flop
	 wire setxMem;
	  
	 dflipflop setxFlipFlop2(setxExecute, reset, 1'b1, clock, setxMem);
	  
	  
	 //target register
	 wire [11:0] targetMem;
	  
	 my_12bit_register targetLatch2(target, clock, 1'b1, targetMem, reset);
	  
	  
	  
	 //rs2 Latch
     wire [4:0] rs2Mem;
	  
	 my_5bit_register rs2Reg2(rs2Execute, clock, 1'b1, rs2Mem, reset);
      
      
     //Overflow latch
     wire overflowMem;
      
     dflipflop overFlowLatch(ALU_overflow, reset, 1'b1, clock, overflowMem);
     
     //Add i latch
     wire addiMem;
     
     dflipflop myAddiFlipFlop2(addiSignal, reset, 1'b1, clock, addiMem);
     
     //ALU sub latch
     wire ALUsubMem;
     
     dflipflop myALUsubFlipFlop2(ALUsubExecute, reset, 1'b1, clock, ALUsubMem);
     
     
     
///////////////////////////////////////////////////////////////////////////////////////////////////////////
     //MEMORY

     //X/M Latch
     
     
     
     wire [31:0] DLatch_output, OLatch2_output;
     
     
     
     //dmem
     genvar i;
	 generate
		for(i = 0; i <= 11; i = i+1) begin: dmemAddressExtraction
            assign address_dmem[i] = OLatch_output[i];
		end
	 endgenerate
	 
	 
	 //MUX for data
	 wire bypassMux3SelectBit, tempSelectBit;
	 
	 my_5bit_comparator comparator5(rs2Mem, ctrl_writeReg, tempSelectBit);
	 and myBypassMux3And(bypassMux3SelectBit, ctrl_writeEnable, tempSelectBit);
	 
	 my_32bit2to1_mux bypassMux3(BLatch_output, data_writeReg, data, bypassMux3SelectBit);
     
     
     //O latch 2
     my_32bit_register OLatch2(OLatch_output, clock, 1'b1, OLatch2_output, reset);
     
     
     //D Latch
     my_32bit_register DLatch(q_dmem, clock, 1'b1, DLatch_output, reset);
     
     //Write mux control signal flip flop 3
     dflipflop myDecodeWriteMuxGate3(writeMuxControlSignalMem, reset, 1'b1, clock, writeMuxControlSignal);
     
     
     //Control for write enable for regfile 3
     dflipflop myDecodeRegFileWE3(regFileWriteEnableMem, reset, 1'b1, clock, ctrl_writeEnable);   
        
        
     //Control for write register for regfile 3
     wire [4:0] tempctrl_writeReg;
     
     my_5bit_register myWriteRegMuxReg3(ctrl_writeRegMem, clock, 1'b1, tempctrl_writeReg, reset);
	  
	  
	  
	 //PC Latch 4
	 wire [11:0] PCLatch4_output;
	  
	 my_12bit_register PCLatch4(PCLatch3_output, clock, 1'b1, PCLatch4_output, reset);
	  
	  
     //Control for jal (because we need to set r31 to PC + 1
	 wire jalMuxSignal;
	  
	 dflipflop jalFlipFlop3(jalMem, reset, 1'b1, clock, jalMuxSignal);
	  
	  
	 //set x flip flop
	 wire setxSignal;
	  
	 dflipflop setxFlipFlop3(setxMem, reset, 1'b1, clock, setxSignal);
	  
	 
	 //target register
	 wire [11:0] targetWrite;
	  
	 my_12bit_register targetLatch3(targetMem, clock, 1'b1, targetWrite, reset);
      
     //Overflow latch
     wire overflowWrite;
      
     dflipflop overFlowLatch2(overflowMem, reset, 1'b1, clock, overflowWrite);
     
     //Add i latch
     wire addiWrite;
     
     dflipflop myAddiFlipFlop3(addiMem, reset, 1'b1, clock, addiWrite);
     
     
     //ALU sub latch
     wire ALUsubWrite;
     
     dflipflop myALUsubFlipFlop3(ALUsubMem, reset, 1'b1, clock, ALUsubWrite);
     
     
     
///////////////////////////////////////////////////////////////////////////////////////////////////////////
     //WRITE
     
     //M/W Latch
     
     wire [31:0] tempdata_writeReg, tempdata_writeReg2, tempdata_writeReg3;
     
     my_32bit2to1_mux myWriteMux(DLatch_output, OLatch2_output, tempdata_writeReg, writeMuxControlSignal);
     
       
	 //PCLatch4_output contains PC+1
     my_32bit2to1_mux myWriteMux2(tempdata_writeReg, PCLatch4_output, tempdata_writeReg2, jalMuxSignal);
	  
	  
	 my_32bit2to1_mux myWriteMux3(tempdata_writeReg2, targetWrite, tempdata_writeReg3, setxSignal);
     
     
     //Overflow muxes
     wire [31:0] overflowMuxWire1, overflowMuxWire2;
     
     my_32bit2to1_mux myOverflowMux1(32'b00000000000000000000000000000001, 32'b00000000000000000000000000000010, overflowMuxWire1, addiWrite);
     my_32bit2to1_mux myOverflowMux2(overflowMuxWire1,                     32'b00000000000000000000000000000011, overflowMuxWire2, ALUsubWrite);
     
     my_32bit2to1_mux myWriteMux4(tempdata_writeReg3, overflowMuxWire2, data_writeReg, overflowWrite);
      
      
     //ctrl_writeRegMUX
      my_5bit2to1_mux mywriteRegMux(tempctrl_writeReg, 5'b11110, ctrl_writeReg, overflowWrite);
      
      
      
      
endmodule