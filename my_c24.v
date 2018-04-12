module my_c24(G0, P0, G1, P1, G2, P2, c0, c24);

    input G0, P0, G1, P1, G2, P2, c0;
    
    output c24;
    
    wire w1, w2, w3;
    
    and myAnd1(w1, P2, P1, P0, c0);
    
    and myAnd2(w2, P2, P1, G0);
    
    and myAnd3(w3, P2, G1);
    
    
    or myOr1(c24, G2, w3, w2, w1);
    
endmodule