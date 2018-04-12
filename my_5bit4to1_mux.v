module my_5bit4to1_mux(input_data1, input_data2, input_data3, input_data4, output_data, select_signal);

    input [4:0] input_data1;
    input [4:0] input_data2;
    input [4:0] input_data3;
    input [4:0] input_data4;
    
    
    input [1:0] select_signal;
    
    output [4:0] output_data;
    
    wire [4:0] mux1Output, mux2Output;
    
    my_5bit2to1_mux mux1(input_data1, input_data2, mux1Output, select_signal[0]);
    my_5bit2to1_mux mux2(input_data3, input_data4, mux2Output, select_signal[0]);
    
    my_5bit2to1_mux mux3(mux1Output, mux2Output, output_data, select_signal[1]);
    
endmodule