module my_17to32bit_extender(input_data, output_data);

	input [16:0] input_data;
	
	output [31:0] output_data;
	
	
	 genvar a;
	 generate
		for(a = 0; a <= 16; a = a+1) begin: extendingLoop
			assign output_data[a] = input_data[a];
		end
	 endgenerate
	 
	 genvar b;
	 generate
		for(b = 17; b <= 31; b = b+1) begin: extendingLoop2
			assign output_data[b] = input_data[16];
		end
	 endgenerate
	 
endmodule