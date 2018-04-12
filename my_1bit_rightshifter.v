module my_1bit_rightshifter(data_input, control_bit, data_output);

	input [31:0] data_input;
	input control_bit;
	
	wire [31:0] shifted;
	
	output [31:0] data_output;
	
	
	genvar k;
	generate
	for(k = 0; k < 31; k = k+1) begin: my1RightShiftLoop
		assign shifted[k] = data_input[k+1];
    end
	endgenerate
    
    assign shifted[31] = data_input[31];
	
	assign data_output = control_bit ? shifted : data_input;
	
	
	
endmodule