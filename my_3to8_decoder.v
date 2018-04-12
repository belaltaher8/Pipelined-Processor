module my_3to8_decoder(input_bits, output_bits, enable);

	input [2:0] input_bits;
	input enable;
	
	output [7:0] output_bits;
	
	wire not0Output, not1Output, not2Output;
	
	not(not0Output, input_bits[0]);
	not(not1Output, input_bits[1]);
	not(not2Output, input_bits[2]);
	
	and myAnd7(output_bits[7], input_bits[2], input_bits[1], input_bits[0], enable);
	and myAnd6(output_bits[6], input_bits[2], input_bits[1], not0Output, enable);
	and myAnd5(output_bits[5], input_bits[2], not1Output, input_bits[0], enable);
	and myAnd4(output_bits[4], input_bits[2], not1Output, not0Output, enable);
	and myAnd3(output_bits[3], not2Output, input_bits[1], input_bits[0], enable);
	and myAnd2(output_bits[2], not2Output, input_bits[1], not0Output, enable);
	and myAnd1(output_bits[1], not2Output, not1Output, input_bits[0], enable);
	and myAnd0(output_bits[0], not2Output, not1Output, not0Output, enable);
	
endmodule