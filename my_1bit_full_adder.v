module my_1bit_full_adder(input_a, input_b, c_in, sum, c_out);

    input input_a, input_b, c_in;
    
    output sum, c_out;
    
    wire w1, w2, w3;
    
    xor xor1(w1, input_a, input_b);
    xor xor2(sum, w1, c_in);
    
    and and1(w2, w1, c_in);
    and and2(w3, input_a, input_b);
    
    or or1(c_out, w2, w3);
    
endmodule