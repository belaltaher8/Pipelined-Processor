module my_2to4_decoder(input_bits, output_bits, enable);
	
	input [1:0] input_bits;
	input enable;
	
	output [3:0] output_bits;
	
	wire not0Output, not1Output;
	
	not myNot0(not0Output, input_bits[0]);
	not myNot1(not1Output, input_bits[1]);
	
		
	and myAnd3(output_bits[3],input_bits[0], input_bits[1], enable);
	and myAnd2(output_bits[2], not0Output, input_bits[1], enable);
	and myAnd1(output_bits[1], input_bits[0], not1Output, enable);
	and myAnd0(output_bits[0], not0Output, not1Output, enable);
	
endmodule
	
	
	
	