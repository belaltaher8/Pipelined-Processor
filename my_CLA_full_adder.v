module my_CLA_full_adder(input_a, input_b, c_in, bigG, bigP, sum);

    input [7:0] input_a, input_b;
    input c_in;
    
    output bigG, bigP;
    output [7:0] sum;
    
    wire w6, w5, w4, w3, w2, w1, w0;
    wire [7:0] g,p;
    
    wire ripple1, ripple2, ripple3, ripple4, ripple5, ripple6, ripple7, ripple8;
    
    
    and and1(g[0], input_a[0], input_b[0]);
    and and2(g[1], input_a[1], input_b[1]);
    and and3(g[2], input_a[2], input_b[2]);
    and and4(g[3], input_a[3], input_b[3]);
    and and5(g[4], input_a[4], input_b[4]);
    and and6(g[5], input_a[5], input_b[5]);
    and and7(g[6], input_a[6], input_b[6]);
    and and8(g[7], input_a[7], input_b[7]);
    
    or or1(p[0], input_a[0], input_b[0]);
    or or2(p[1], input_a[1], input_b[1]);
    or or3(p[2], input_a[2], input_b[2]);
    or or4(p[3], input_a[3], input_b[3]);
    or or5(p[4], input_a[4], input_b[4]);
    or or6(p[5], input_a[5], input_b[5]);
    or or7(p[6], input_a[6], input_b[6]);
    or or8(p[7], input_a[7], input_b[7]);

    and PAnd(bigP, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0]);
    
    and GAnd0(w0, p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
    and GAnd1(w1, p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
    and GAnd2(w2, p[7], p[6], p[5], p[4], p[3], g[2]);
    and GAnd3(w3, p[7], p[6], p[5], p[4], g[3]);
    and GAnd4(w4, p[7], p[6], p[5], g[4]);
    and GAnd5(w5, p[7], p[6], g[5]);
    and GAnd6(w6, p[7], g[6]);
    
    or GOr(bigG, w0, w1, w2, w3, w4, w5, w6, g[7]);
    
    
    my_1bit_full_adder adder0(input_a[0], input_b[0], c_in, sum[0], ripple1);
    my_1bit_full_adder adder1(input_a[1], input_b[1], ripple1, sum[1], ripple2);
    my_1bit_full_adder adder2(input_a[2], input_b[2], ripple2, sum[2], ripple3);
    my_1bit_full_adder adder3(input_a[3], input_b[3], ripple3, sum[3], ripple4);
    my_1bit_full_adder adder4(input_a[4], input_b[4], ripple4, sum[4], ripple5);
    my_1bit_full_adder adder5(input_a[5], input_b[5], ripple5, sum[5], ripple6);
    my_1bit_full_adder adder6(input_a[6], input_b[6], ripple6, sum[6], ripple7);
    my_1bit_full_adder adder7(input_a[7], input_b[7], ripple7, sum[7], ripple8);
    
    
endmodule