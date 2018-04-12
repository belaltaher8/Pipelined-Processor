module my_5to32_decoder(input_bits, output_bits, enable);

	input [4:0] input_bits;
	input enable;
	
	output [31:0] output_bits;
	
	wire enable1, enable2, enable3, enable4;
	
	my_2to4_decoder decoderEnable(input_bits[4:3],{enable4, enable3, enable2, enable1}, enable);
	
	my_3to8_decoder decoderOne(input_bits[2:0], output_bits[7:0], enable1);
	my_3to8_decoder decoderTwo(input_bits[2:0], output_bits[15:8], enable2);
	my_3to8_decoder decoderThree(input_bits[2:0], output_bits[23:16], enable3);
	my_3to8_decoder decoderFour(input_bits[2:0], output_bits[31:24], enable4);
	
endmodule

