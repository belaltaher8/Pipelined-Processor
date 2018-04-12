module my_12bit2to1_mux(input_data1, input_data2, output_data, select_signal);
   
    input [11:0] input_data1;
    input [11:0] input_data2;
    
    input select_signal;
    
    output [11:0] output_data;
    
    assign output_data = select_signal ? input_data2 : input_data1;
    
endmodule