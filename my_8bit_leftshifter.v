module my_8bit_leftshifter(data_input, control_bit, data_output);

	input [31:0] data_input;
	input control_bit;
	
	wire [31:0] shifted;
	
	output [31:0] data_output;
	
	
	genvar k;
	generate
	for(k = 31; k > 7; k = k-1) begin: my8ShiftLoop
		assign shifted[k] = data_input[k-8];
    end
	endgenerate
    
    genvar j;
	generate
	for(j = 7; j >= 0; j = j-1) begin: my8ShiftLoop2
		assign shifted[j] = 1'b0;
    end
	endgenerate
	
	assign data_output = control_bit ? shifted : data_input;
	
	
	
endmodule