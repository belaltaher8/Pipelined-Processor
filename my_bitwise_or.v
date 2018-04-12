module my_bitwise_or(data_input1, data_input2, data_output);

	input [31:0] data_input1, data_input2;
	
	output [31:0] data_output;
	
	genvar k;
	generate
	for(k = 0; k < 32; k = k+1) begin: bitWiseOrLoop
		or myOr(data_output[k], data_input1[k], data_input2[k]);
   end
	endgenerate
	
endmodule