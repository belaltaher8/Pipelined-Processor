module my_1bit_xor(inputA, inputB, output_data);

	input inputA, inputB;
	
	output output_data;
	
	wire w1, w2, w3, notw1, notw2, notw3, w4;
	
	
	and myAnd1(w1, inputA, inputB);
	not myNot1(notw1, w1);
	
	and myAnd2(w2, inputA, notw1);
	not myNot2(notw2, w2);
	
	and myAnd3(w3, inputB, notw1);
	not myNot3(notw3, w3);
	
	and myAnd4(w4, notw3, notw2);
	not myNot4(output_data, w4);
	
	
endmodule