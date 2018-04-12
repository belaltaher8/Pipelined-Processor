module my_5bit_comparator(inputA, inputB, EQ);

	input [4:0] inputA, inputB;
	
	output EQ;
	
	
	wire bit0, bit1, bit2, bit3, bit4, tempEQ, tempEQ2;
	
	my_1bit_xor xor0(inputA[0], inputB[0], bit0);
	my_1bit_xor xor1(inputA[1], inputB[1], bit1);
	my_1bit_xor xor2(inputA[2], inputB[2], bit2);
	my_1bit_xor xor3(inputA[3], inputB[3], bit3);
	my_1bit_xor xor4(inputA[4], inputB[4], bit4);
	
	and myEQAnd(tempEQ, ~bit4, ~bit3, ~bit2, ~bit1, ~bit0);
    and myEQAnd2(tempEQ2, ~inputA[4], ~inputA[3], ~inputA[2], ~inputA[1], ~inputA[0]);
    
    and myEQAnd4(EQ, tempEQ, ~tempEQ2);
	
endmodule