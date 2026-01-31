initial begin
    // init
    WE_0    = 1'b0;
    WE      = 1'b0;
    CLK     = 1'b0;
    D       = 1'b0;
    READ_A  = 1'b0;
    READ_B  = 1'b0;

    #10;
    CLK     = 1'b1;

    // =====================================================

    #10; // write value 1 in RF
    CLK     = 1'b0;
    WE      = 1'b1;
    WE_0    = 1'b0;
    D       = 1'b1;

    #10;
    CLK     = 1'b1;
    WE      = 1'b0;
    
    WE_0    = 1'b1;

    #10; // read value 1 from RF
    CLK     = 1'b0;
    WE      = 1'b0;
    WE_0    = 1'b0;
    D       = 1'b0;

    READ_A  = 1'b1;
    READ_B  = 1'b1;

    #10;
    CLK     = 1'b1;

    READ_A  = 1'b0;
    READ_B  = 1'b0;

    // =====================================================

    #10; // write value 0 in RF
    CLK     = 1'b0;
    WE      = 1'b1;
    WE_0    = 1'b0;
    D       = 1'b0;

    #10;
    CLK     = 1'b1;
    WE      = 1'b0;
    WE_0    = 1'b1;

    #10; // read value 0 from RF
    CLK     = 1'b0;
    WE      = 1'b0;
    WE_0    = 1'b0;
    D       = 1'b0;

    READ_A  = 1'b1;
    READ_B  = 1'b1;

    // =====================================================

    #10;
    CLK     = 1'b1;

    READ_A  = 1'b0;
    READ_B  = 1'b0;

    #10;
    $stop;
end