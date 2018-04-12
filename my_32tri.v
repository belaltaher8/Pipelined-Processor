module my_32tri(input_data, output_data, enable);

    input [31:0] input_data;
    input enable;
    
    output[31:0] output_data;
    	
	genvar k;
	generate
	for(k = 0; k < 32; k = k+1) begin: triStateLoop
		my_tri thetris(input_data[k], enable, output_data[k]);
        
    end
	endgenerate
    
endmodule