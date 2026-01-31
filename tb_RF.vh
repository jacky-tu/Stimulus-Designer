integer i;

initial begin
  // init
  READ_A        = 16'b0;
  READ_B        = 16'b0;
  Write_Addr    = 16'b0;
  Write_Enable  = 1'b0;
  Clk           = 1'b0;
  D             = 16'b0;


  // write 0 in RF

  #5;
  Write_Enable = 1'b1;
  D            = 16'b0;

  for (i = 0; i < 16; i = i + 1) begin
    // one-hot write address
    Write_Addr = (16'b1 << i);

    // generate one write cycle (rising edge write)
    #5;  Clk = 1'b1;
    #5;  Clk = 1'b0;
  end


  // =================================== test begin ===============================

  #5; // write FFFF in RF[0]
  Write_Enable  = 1'b1;
  Write_Addr    = 16'b0000000000000001;
  D             = 16'b1111111111111111;

  #5; // rising edge
  Clk           = 1'b1;

  #10; // falling edge, write FFFF in RF[1]
  Clk           = 1'b0;
  Write_Enable  = 1'b1;
  Write_Addr    = 16'b0000000000000010;
  D             = 16'b1111111111111111;

  #10; // rising edge
  Clk           = 1'b1;

  #10; // falling edge, write FFFF in RF[15]
  Clk           = 1'b0;
  Write_Enable  = 1'b1;
  Write_Addr    = 16'b1000000000000000;
  D             = 16'b1111111111111111;

  #10; // rising edge
  Clk           = 1'b1;

  #10; // falling edge, write FFFF in RF[14]
  Clk           = 1'b0;
  Write_Enable  = 1'b1;
  Write_Addr    = 16'b0100000000000000;
  D             = 16'b1111111111111111;

  #10; // rising edge
  Clk           = 1'b1;

  #10; // falling edge, read RF[0], RF[1], QA, QB 0->1
  Clk           = 1'b0;
  Write_Enable  = 1'b0;
  READ_A        = 16'b0000000000000001;
  READ_B        = 16'b0000000000000010;

  #10; // rising edge   
  Clk           = 1'b1;

  #10; // falling edge, read RF[2], RF[3], QA, QB 1->0 
  Clk           = 1'b0;
  Write_Enable  = 1'b0;
  READ_A        = 16'b0000000000000100;
  READ_B        = 16'b0000000000001000;

  #10; // rising edge
  Clk           = 1'b1;

  #10; 
  // falling edge, read RF[14] RF[15], QA, QB 0->1, measure 
  // clk to Q delay difference between RF[0],RF[1] and RF[14], RF[15]?
  Clk           = 1'b0;
  Write_Enable  = 1'b0;
  READ_A        = 16'b1000000000000000;
  READ_B        = 16'b0100000000000000;

  #10; // rising edge
  Clk           = 1'b1;

  
  #10; 
  // critical path? write and read at the same cycle
  // falling edge, QA, QB 0->1, measure, clk to Q delay difference between RF[0],RF[1] and RF[14], RF[15]?
  Clk           = 1'b0;
  Write_Enable  = 1'b1;
  Write_Addr    = 16'b0000000000000100;
  D             = 16'b1111111111111111;
  READ_A        = 16'b0000000000000100;
  READ_B        = 16'b0000000000000100;

  #10; // rising edge
  Clk           = 1'b1;

  #10;
  $stop;
end