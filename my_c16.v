module my_c16(G0, P0, G1, P1, c0, c16);

    input G0, P0, G1, P1, c0;
    
    output c16;
    
    wire w1, w2;
    
    and myAnd1(w1, P1, P0, c0);
    
    and myAnd2(w2, P1, G0);
    
    
    or myOr1(c16, G1, w1, w2);
    
endmodule