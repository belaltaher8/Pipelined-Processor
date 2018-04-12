module my_32bit_register(input_data, clock, write_enable, output_data, clear);

	input [31:0] input_data;
	input clock, write_enable, clear;
	
	output [31:0] output_data;
	
	genvar i;
	generate
	for(i = 0; i < 32; i = i+1) begin: flipFlopLoop
		dflipflop curr_dff(input_data[i], clear, write_enable, clock, output_data[i]);
	end
	endgenerate
	
endmodule
	
	
	