module my_32bit16to1_mux(input_data1, input_data2, input_data3, input_data4, input_data5, input_data6, input_data7, input_data8,
							input_data9, input_data10, input_data11, input_data12, input_data13, input_data14, input_data15, input_data16, output_data, select_signal);

    input [31:0] input_data1;
    input [31:0] input_data2;
    input [31:0] input_data3;
    input [31:0] input_data4;
    input [31:0] input_data5;
    input [31:0] input_data6;
    input [31:0] input_data7;
    input [31:0] input_data8;
    input [31:0] input_data9;
    input [31:0] input_data10;
    input [31:0] input_data11;
    input [31:0] input_data12;
    input [31:0] input_data13;
    input [31:0] input_data14;
    input [31:0] input_data15;
    input [31:0] input_data16;
	 
    input [3:0] select_signal;
    
    output [31:0] output_data;
	 
    wire [31:0] mux1Output, mux2Output;
    
    my_32bit8to1_mux mux1(input_data1, input_data2, input_data3, input_data4, input_data5, input_data6, input_data7, input_data8, mux1Output, select_signal[2:0]);
    my_32bit8to1_mux mux2(input_data9, input_data10, input_data11, input_data12, input_data13, input_data14, input_data15, input_data16, mux2Output, select_signal[2:0]);
    
    my_32bit2to1_mux mux3(mux1Output, mux2Output, output_data, select_signal[3]);
    
endmodule