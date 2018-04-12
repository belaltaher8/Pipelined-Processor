module regfile(
	clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
	data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	output [31:0] data_readRegA, data_readRegB;
	
	wire [31:0] registerToWrite;
    
	wire [31:0] reg1Output,  reg2Output,  reg3Output,  reg4Output,  reg5Output,  reg6Output,  reg7Output,  reg8Output,  reg9Output,  reg10Output,  reg11Output,  reg12Output,
					 reg13Output,  reg14Output,  reg15Output,  reg16Output,  reg17Output,  reg18Output,  reg19Output,  reg20Output,  reg21Output,  reg22Output,  reg23Output,  reg24Output,	 
					  reg25Output,  reg26Output,  reg27Output,  reg28Output,  reg29Output,  reg30Output,  reg31Output;
    
	my_5to32_decoder writeReg(ctrl_writeReg, registerToWrite, ctrl_writeEnable);
	
    

    my_32bit_register reg1( data_writeReg, clock, registerToWrite[1],  reg1Output,  ctrl_reset);
	my_32bit_register reg2( data_writeReg, clock, registerToWrite[2],  reg2Output,  ctrl_reset);
	my_32bit_register reg3( data_writeReg, clock, registerToWrite[3],  reg3Output,  ctrl_reset);
	my_32bit_register reg4( data_writeReg, clock, registerToWrite[4],  reg4Output,  ctrl_reset);
	my_32bit_register reg5( data_writeReg, clock, registerToWrite[5],  reg5Output,  ctrl_reset);
	my_32bit_register reg6( data_writeReg, clock, registerToWrite[6],  reg6Output,  ctrl_reset);
	my_32bit_register reg7( data_writeReg, clock, registerToWrite[7],  reg7Output,  ctrl_reset);
	my_32bit_register reg8( data_writeReg, clock, registerToWrite[8],  reg8Output,  ctrl_reset);
	my_32bit_register reg9( data_writeReg, clock, registerToWrite[9],  reg9Output,  ctrl_reset);
	my_32bit_register reg10(data_writeReg, clock, registerToWrite[10], reg10Output, ctrl_reset);
	my_32bit_register reg11(data_writeReg, clock, registerToWrite[11], reg11Output, ctrl_reset);
	my_32bit_register reg12(data_writeReg, clock, registerToWrite[12], reg12Output, ctrl_reset);
	my_32bit_register reg13(data_writeReg, clock, registerToWrite[13], reg13Output, ctrl_reset);
	my_32bit_register reg14(data_writeReg, clock, registerToWrite[14], reg14Output, ctrl_reset);
	my_32bit_register reg15(data_writeReg, clock, registerToWrite[15], reg15Output, ctrl_reset);
	my_32bit_register reg16(data_writeReg, clock, registerToWrite[16], reg16Output, ctrl_reset);
	my_32bit_register reg17(data_writeReg, clock, registerToWrite[17], reg17Output, ctrl_reset);
	my_32bit_register reg18(data_writeReg, clock, registerToWrite[18], reg18Output, ctrl_reset);
	my_32bit_register reg19(data_writeReg, clock, registerToWrite[19], reg19Output, ctrl_reset);
	my_32bit_register reg20(data_writeReg, clock, registerToWrite[20], reg20Output, ctrl_reset);
	my_32bit_register reg21(data_writeReg, clock, registerToWrite[21], reg21Output, ctrl_reset);
	my_32bit_register reg22(data_writeReg, clock, registerToWrite[22], reg22Output, ctrl_reset);
	my_32bit_register reg23(data_writeReg, clock, registerToWrite[23], reg23Output, ctrl_reset);
	my_32bit_register reg24(data_writeReg, clock, registerToWrite[24], reg24Output, ctrl_reset);
	my_32bit_register reg25(data_writeReg, clock, registerToWrite[25], reg25Output, ctrl_reset);
	my_32bit_register reg26(data_writeReg, clock, registerToWrite[26], reg26Output, ctrl_reset);
	my_32bit_register reg27(data_writeReg, clock, registerToWrite[27], reg27Output, ctrl_reset);
	my_32bit_register reg28(data_writeReg, clock, registerToWrite[28], reg28Output, ctrl_reset);
	my_32bit_register reg29(data_writeReg, clock, registerToWrite[29], reg29Output, ctrl_reset);
	my_32bit_register reg30(data_writeReg, clock, registerToWrite[30], reg30Output, ctrl_reset);
	my_32bit_register reg31(data_writeReg, clock, registerToWrite[31], reg31Output, ctrl_reset);

	
	my_32bit32to1_mux muxOperandA(32'b00000000000000000000000000000000, reg1Output,  reg2Output,  reg3Output,  reg4Output,  reg5Output,  reg6Output,  reg7Output,  reg8Output,  reg9Output,  reg10Output,  reg11Output,  reg12Output,
					 reg13Output,  reg14Output,  reg15Output,  reg16Output,  reg17Output,  reg18Output,  reg19Output,  reg20Output,  reg21Output,  reg22Output,  reg23Output,  reg24Output,	 
					  reg25Output,  reg26Output,  reg27Output,  reg28Output,  reg29Output,  reg30Output,  reg31Output, data_readRegA, ctrl_readRegA);
					  
	my_32bit32to1_mux muxOperandB(32'b00000000000000000000000000000000, reg1Output,  reg2Output,  reg3Output,  reg4Output,  reg5Output,  reg6Output,  reg7Output,  reg8Output,  reg9Output,  reg10Output,  reg11Output,  reg12Output,
					 reg13Output,  reg14Output,  reg15Output,  reg16Output,  reg17Output,  reg18Output,  reg19Output,  reg20Output,  reg21Output,  reg22Output,  reg23Output,  reg24Output,	 
					  reg25Output,  reg26Output,  reg27Output,  reg28Output,  reg29Output,  reg30Output,  reg31Output, data_readRegB, ctrl_readRegB);
	
endmodule


