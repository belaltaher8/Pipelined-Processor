module my_32bit8to1_mux(input_data1, input_data2, input_data3, input_data4, input_data5, input_data6, input_data7, input_data8, output_data, select_signal);

    input [31:0] input_data1;
    input [31:0] input_data2;
    input [31:0] input_data3;
    input [31:0] input_data4;
    input [31:0] input_data5;
    input [31:0] input_data6;
    input [31:0] input_data7;
    input [31:0] input_data8;
    
    input [2:0] select_signal;
    
    output [31:0] output_data;
    
    wire [31:0] mux1Output, mux2Output;
    
    my_32bit4to1_mux mux1a(input_data1, input_data2, input_data3, input_data4, mux1Output, select_signal[1:0]);
    my_32bit4to1_mux mux2a(input_data5, input_data6, input_data7, input_data8, mux2Output, select_signal[1:0]);
    
    my_32bit2to1_mux mux3a(mux1Output, mux2Output, output_data, select_signal[2]);
    
endmodule