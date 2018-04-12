module my_c32(G0, P0, G1, P1, G2, P2, G3, P3, c0, c32);

    input G0, P0, G1, P1, G2, P2, G3, P3, c0;
    
    output c32;
    
    wire w1, w2, w3, w4;
    
    and myAnd1(w1, P3, P2, P1, P0, c0);
    
    and myAnd2(w2, P3, P2, P1, G0);
    
    and myAnd3(w3, P3, P2, G1);
    
    and myAnd4(w4, P3, G2);
    
    
    or myOr(c32, G3, w4, w3, w2, w1);
    
endmodule