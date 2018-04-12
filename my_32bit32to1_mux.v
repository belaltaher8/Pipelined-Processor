module my_32bit32to1_mux(input_data1, input_data2, input_data3, input_data4, input_data5, input_data6, input_data7, input_data8,
							input_data9, input_data10, input_data11, input_data12, input_data13, input_data14, input_data15, input_data16,
						   input_data17, input_data18, input_data19, input_data20, input_data21, input_data22, input_data23, input_data24,
							input_data25, input_data26, input_data27, input_data28, input_data29, input_data30, input_data31, input_data32, output_data, select_signal);

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
	 input [31:0] input_data17;
    input [31:0] input_data18;
    input [31:0] input_data19;
    input [31:0] input_data20;
    input [31:0] input_data21;
    input [31:0] input_data22;
    input [31:0] input_data23;
    input [31:0] input_data24;
    input [31:0] input_data25;
    input [31:0] input_data26;
    input [31:0] input_data27;
    input [31:0] input_data28;
    input [31:0] input_data29;
    input [31:0] input_data30;
    input [31:0] input_data31;
    input [31:0] input_data32;
	 
    input [4:0] select_signal;
    
    output [31:0] output_data;
    
    wire [31:0] mux1Output, mux2Output;
    
    my_32bit16to1_mux mux1(input_data1, input_data2, input_data3, input_data4, input_data5, input_data6, input_data7, input_data8,
							input_data9, input_data10, input_data11, input_data12, input_data13, input_data14, input_data15, input_data16, mux1Output, select_signal[3:0]);
							
    my_32bit16to1_mux mux2(input_data17, input_data18, input_data19, input_data20, input_data21, input_data22, input_data23, input_data24,
							input_data25, input_data26, input_data27, input_data28, input_data29, input_data30, input_data31, input_data32, mux2Output, select_signal[3:0]);
    
    my_32bit2to1_mux mux3(mux1Output, mux2Output, output_data, select_signal[4]);
    
endmodule