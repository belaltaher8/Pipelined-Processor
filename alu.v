module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

	input [31:0] data_operandA, data_operandB;
	input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
	
	output [31:0] data_result;
	output isNotEqual, isLessThan, overflow;
    
    wire[31:0] bInputToAdder;
    wire[31:0] negativeB;
	
	 wire [31:0] bitwiseAndOutput, bitwiseOrOutput, leftShiftOutput, rightShiftOutput, addOutput;
    wire sub;
    wire carry_out;
    wire Ocase1, Ocase2, Ocase3, Ocase4;
    wire R, notR, S, notS, Pa, notPa, Pb, notPb;
    wire notOverflow;
    wire isEqual;
    wire lessThanCase1, lessThanCase2, lessThanCase3;
    wire [31:0] invertedResult;
    
    assign sub = ctrl_ALUopcode[0];
	
    // And/Or
    
	my_bitwise_and bitwiseAnd(data_operandA, data_operandB, bitwiseAndOutput);
	my_bitwise_or bitwiseOr(data_operandA, data_operandB, bitwiseOrOutput);
	
    //Shifting
    
    my_32bit_barrelLeftShifter leftShifter(data_operandA, ctrl_shiftamt, leftShiftOutput);
    my_32bit_barrelRightShifter rightShifter(data_operandA, ctrl_shiftamt, rightShiftOutput);
    
    // Finds ~b for when we do subtraction
    
    genvar k;
	 generate
	 for(k = 31; k >= 0; k = k-1) begin: negB
		not myNotB(negativeB[k], data_operandB[k]);
    end
	 endgenerate
    
    
    //Adder
    
    my_32bit2to1_mux myMux1(data_operandB, negativeB, bInputToAdder, sub);
    my_ALU_adder adder(data_operandA, bInputToAdder, sub, addOutput, carry_out);
    
    
    // Overflow
    assign R = data_result[31];
    assign Pa = data_operandA[31];
    assign Pb = data_operandB[31];
    
    not myNot1(notR, R);
    not myNot2(notPa, Pa);
    not myNot3(notPb, Pb);
    not myNot4(notS, sub);
    
    and overflowAnd1(Ocase1, notR, sub, Pa, notPb);
    and overflowAnd2(Ocase2, sub, notPa, Pb, R);
    and overflowAnd3(Ocase3, notS, notPa, notPb, R);
    and overflowAnd4(Ocase4, notS, Pa, Pb, notR); 
    
    or overflowOr(overflow, Ocase1, Ocase2, Ocase3, Ocase4);
    
    
    // Is not equal to   
    wire [31:0] ABXor;
    
    genvar b;
	 generate
	 for(b = 31; b >= 0; b = b-1) begin: xorLoop
		my_1bit_xor xorGate(data_operandA[b], data_operandB[b], ABXor[b]);
    end
	endgenerate
    
    wire tempisNotEqual, AIsZero, BIsZero;
    
    and isNotEqualGate(tempisNotEqual, ~ABXor[31], ~ABXor[30], ~ABXor[29], ~ABXor[28], ~ABXor[27], ~ABXor[26], ~ABXor[25],
                         ~ABXor[24], ~ABXor[23], ~ABXor[22], ~ABXor[21], ~ABXor[20], ~ABXor[19], ~ABXor[18], ~ABXor[17],
                          ~ABXor[16], ~ABXor[15], ~ABXor[14], ~ABXor[13], ~ABXor[12], ~ABXor[11], ~ABXor[10], ~ABXor[9],
                           ~ABXor[8], ~ABXor[7], ~ABXor[6], ~ABXor[5], ~ABXor[4], ~ABXor[3], ~ABXor[2], ~ABXor[1], ~ABXor[0]);
    
    and isNotEqualGate2(AIsZero, ~data_operandA[31], ~data_operandA[30], ~data_operandA[29], ~data_operandA[28], ~data_operandA[27], ~data_operandA[26],
     ~data_operandA[25], ~data_operandA[24], ~data_operandA[23], ~data_operandA[22], ~data_operandA[21], ~data_operandA[20], ~data_operandA[19], ~data_operandA[18],
      ~data_operandA[17], ~data_operandA[16], ~data_operandA[15], ~data_operandA[14], ~data_operandA[13], ~data_operandA[12], ~data_operandA[11], ~data_operandA[10],
       ~data_operandA[9], ~data_operandA[8], ~data_operandA[7], ~data_operandA[6], ~data_operandA[5], ~data_operandA[4], ~data_operandA[3], ~data_operandA[2],
        ~data_operandA[1], ~data_operandA[0]);
        
          and isNotEqualGate3(BIsZero, ~data_operandB[31], ~data_operandB[30], ~data_operandB[29], ~data_operandB[28], ~data_operandB[27], ~data_operandB[26],
     ~data_operandB[25], ~data_operandB[24], ~data_operandB[23], ~data_operandB[22], ~data_operandB[21], ~data_operandB[20], ~data_operandB[19], ~data_operandB[18],
      ~data_operandB[17], ~data_operandB[16], ~data_operandB[15], ~data_operandB[14], ~data_operandB[13], ~data_operandB[12], ~data_operandB[11], ~data_operandB[10],
       ~data_operandB[9], ~data_operandB[8], ~data_operandB[7], ~data_operandB[6], ~data_operandB[5], ~data_operandB[4], ~data_operandB[3], ~data_operandB[2],
        ~data_operandB[1], ~data_operandB[0]);
        
        and isNotEqualGate4(isNotEqual, tempisNotEqual, ~AIsZero, ~BIsZero);
    
    // Less Than
    
    assign isLessThan = data_result[31];
    
    
    // Mux for output
    my_32bit8to1_mux myMux2(addOutput, addOutput, bitwiseAndOutput, bitwiseOrOutput, leftShiftOutput, rightShiftOutput, 32'b0, 32'b0, data_result, ctrl_ALUopcode[2:0]);
	
	
endmodule