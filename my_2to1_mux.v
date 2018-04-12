module my_2to1_mux(input_data1, input_data2, output_data, select_signal);
   
    input input_data1;
    input input_data2;
    
    input select_signal;
    
    output output_data;
    
    assign output_data = select_signal ? input_data2 : input_data1;
    
endmodule