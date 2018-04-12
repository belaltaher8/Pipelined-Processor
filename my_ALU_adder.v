module my_ALU_adder(input_a, input_b, c_in, sum, overflow);

    input [31:0] input_a, input_b;
    input c_in;
    
    wire [31:0] intermediateSum;
    
    output[31:0] sum;
    output overflow;
    
    wire G0, P0, G1, P1, G2, P2, G3, P3;
    wire c8, c16, c24;
    
    wire zeroIndicator;  
    
    
    nor myNor(zeroIndicator, input_a[31], input_a[30],input_a[29],input_a[28],input_a[27],input_a[26],input_a[25],input_a[24],input_a[23],input_a[22],input_a[21],input_a[20],input_a[19],input_a[18],input_a[17],input_a[16],input_a[15],input_a[14],input_a[13],input_a[12],input_a[11],input_a[10],input_a[9],input_a[8],input_a[7],input_a[6],input_a[5],input_a[4],input_a[3],input_a[2],input_a[1],input_a[0],input_b[31],input_b[30],input_b[29],input_b[28],input_b[27],input_b[26],input_b[25],input_b[24],input_b[23],input_b[22],input_b[21],input_b[19],input_b[18],input_b[17],input_b[16],input_b[15],input_b[14],input_b[13],input_b[12],input_b[11],input_b[10],input_b[9],input_b[8],input_b[7],input_b[6],input_b[5],input_b[4],input_b[3],input_b[2],input_b[1],input_b[0]);
    
    my_CLA_full_adder block0(input_a[7:0], input_b[7:0], c_in, G0, P0, intermediateSum[7:0]);
    my_CLA_full_adder block1(input_a[15:8], input_b[15:8], c8, G1, P1, intermediateSum[15:8]);
    my_CLA_full_adder block2(input_a[23:16], input_b[23:16], c16, G2, P2, intermediateSum[23:16]);
    my_CLA_full_adder block3(input_a[31:24], input_b[31:24], c24, G3, P3, intermediateSum[31:24]);
    
    my_c8 c8Block(G0, P0, c_in, c8);
    my_c16 c16Block(G0, P0, G1, P1, c_in, c16); 
    my_c24 c24Block(G0, P0, G1, P1, G2, P2, c_in, c24);
    my_c32 c32Block(G0, P0, G1, P1, G2, P2, G3, P3, c_in, overflow);
    
    assign sum = zeroIndicator ? 32'h00000000 : intermediateSum;
    
    
    
    
    
endmodule