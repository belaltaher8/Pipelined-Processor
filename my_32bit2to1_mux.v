module my_32bit2to1_mux(input_data1, input_data2, output_data, select_signal);
   
    input [31:0] input_data1;
    input [31:0] input_data2;
    
    input select_signal;
    
    output [31:0] output_data;
    
    assign output_data = select_signal ? input_data2 : input_data1;
    
endmodule