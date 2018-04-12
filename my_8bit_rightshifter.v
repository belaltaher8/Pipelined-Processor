module my_8bit_rightshifter(data_input, control_bit, data_output);

	input [31:0] data_input;
	input control_bit;
	
	wire [31:0] shifted;
	
	output [31:0] data_output;
	
	
	genvar k;
	generate
	for(k = 0; k < 24; k = k+1) begin: my8RightShiftLoop
		assign shifted[k] = data_input[k+8];
    end
	endgenerate
    
    genvar j;
	generate
	for(j = 24; j < 32; j = j+1) begin: my8RightShiftLoop2
		assign shifted[j] = data_input[31];
    end
	endgenerate
	
	assign data_output = control_bit ? shifted : data_input;
	
	
	
endmodule