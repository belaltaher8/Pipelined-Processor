module my_32bit_barrelRightShifter(data_input, control_bits, data_output);

	input [31:0] data_input;
	input [4:0] control_bits;
	
	output [31:0] data_output;
	
	wire [31:0] output16bit, output8bit, output4bit, output2bit;
	
	my_16bit_rightshifter my16BitShifter(data_input, control_bits[4], output16bit);
	my_8bit_rightshifter my8BitShifter(output16bit, control_bits[3], output8bit);
	my_4bit_rightshifter my4BitShifter(output8bit, control_bits[2], output4bit);
	my_2bit_rightshifter my2BitShifter(output4bit, control_bits[1], output2bit);
	my_1bit_rightshifter my1BitShifter(output2bit, control_bits[0], data_output);
	
endmodule