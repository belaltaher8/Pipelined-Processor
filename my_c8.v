module my_c8(G0, P0, c0, c8);

    input G0, P0, c0;
    
    output c8;
    
    wire w1;
    
    and myAnd1(w1, P0, c0);
    
    
    or myOr1(c8, G0, w1);
    
endmodule