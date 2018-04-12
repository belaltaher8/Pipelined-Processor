module my_1bit_leftshifter(data_input, control_bit, data_output);

	input [31:0] data_input;
	input control_bit;
	
	wire [31:0] shifted;
	
	output [31:0] data_output;
	
	
	genvar k;
	generate
	for(k = 31; k > 0; k = k-1) begin: my1ShiftLoop
		assign shifted[k] = data_input[k-1];
    end
	endgenerate
    
    assign shifted[0] = 1'b0;
	
	assign data_output = control_bit ? shifted : data_input;
	
	
	
endmodule