module dflipflop(input_data, clear, write_enable, clk, output_data);

	input input_data, clear, clk, write_enable;
	
	output output_data;
	reg output_data;
	
	always @(posedge clk or posedge clear) begin
		if(clear) begin
			output_data = 1'b0;
		end else if(write_enable) begin
			output_data = input_data;
		end
	end
	
endmodule
