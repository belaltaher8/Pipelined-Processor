module my_32bit4to1_mux(input_data1, input_data2, input_data3, input_data4, output_data, select_signal);

    input [31:0] input_data1;
    input [31:0] input_data2;
    input [31:0] input_data3;
    input [31:0] input_data4;
    
    
    input [1:0] select_signal;
    
    output [31:0] output_data;
    
    wire [31:0] mux1Output, mux2Output;
    
    my_32bit2to1_mux mux1b(input_data1, input_data2, mux1Output, select_signal[0]);
    my_32bit2to1_mux mux2b(input_data3, input_data4, mux2Output, select_signal[0]);
    
    my_32bit2to1_mux mux3b(mux1Output, mux2Output, output_data, select_signal[1]);
    
endmodule