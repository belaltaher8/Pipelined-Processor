module my_12to32bit_extender(input_data, output_data);

	input [11:0] input_data;
	
	output [31:0] output_data;
	
	
	 genvar a;
	 generate
		for(a = 0; a <= 11; a = a+1) begin: extendingLoop
			assign output_data[a] = input_data[a];
		end
	 endgenerate
	 
	 genvar b;
	 generate
		for(b = 12; b <= 31; b = b+1) begin: extendingLoop2
			assign output_data[b] = 1'b0;
		end
	 endgenerate
	 
endmodule