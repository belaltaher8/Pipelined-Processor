module my_4bit_leftshifter(data_input, control_bit, data_output);

	input [31:0] data_input;
	input control_bit;
	
	wire [31:0] shifted;
	
	output [31:0] data_output;
	
	
	genvar k;
	generate
	for(k = 31; k > 3; k = k-1) begin: my4ShiftLoop
		assign shifted[k] = data_input[k-4];
    end
	endgenerate
    
    genvar j;
	generate
	for(j = 3; j >= 0; j = j-1) begin: my4ShiftLoop2
		assign shifted[j] = 1'b0;
    end
	endgenerate
	
	assign data_output = control_bit ? shifted : data_input;
	
	
	
endmodule