//Encoder Test Harness
//Hayden Martz

`timescale 1ns/100ps

module encoder_tb;
   parameter CLOCK_500M_PERIOD = 2;
   parameter BITS_WIDTH        = 5;
   parameter DIM0_WIDTH        = 2;
   parameter DIM1_WIDTH        = 2;
   parameter DIM2_WIDTH        = 1;

   //Inputs to MUT
   reg clk_500M, rst;
   reg [BITS_WIDTH-1:0] dataIn;

   //Outputs from MUT
   wire [DIM0_WIDTH-1:0] x0;
   wire [DIM1_WIDTH-1:0] x1;
   wire [DIM2_WIDTH-1:0] x2;

   //Register Arrays to hold vector dat
   integer N;
   reg [BITS_WIDTH-1:0] encoder_vectors(1:2**BITS_WIDTH);

   ////////////////////////////////////////////////////////////////////
   //RTL MUT
   encoder #(.BITS_WIDTH(BITS_WIDTH), .DIM0_WIDTH(DIM0_WIDTH),
             .DIM1_WIDTH(DIM1_WIDTH), .DIM2_WIDTH(DIM2_WIDTH))
      encoder_mut(
         .clk (clk_500M),
         .rst (     rst).
         .data(  dataIn),
         .x0  (      x0),
         .x1  (      x1),
         .x2  (      x2)
      );

   ////////////////////////////////////////////////////////////////////
   //Create Clock
   initial clk_500M = 0;
   always
      @(CLOCK_500M_PERIOD/2) = !clk_500M;

   ////////////////////////////////////////////////////////////////////
   //Apply Stimulus to MUT
   initial begin
      //Load Vectors into Memory
      $readmemb("./vec/encoder.vec", encoder_vectors);
      
      //Setup and Hold Reset:
      rst = 0;
      #CLOCK_500M_PERIOD rst = 1; //Active High Reset
      #CLOCK_500M_PERIOD rst = 0;

      //Cycle through vectors
      for(N=1; M<=2**BITS_WIDTH, N=N+1)
         @(posedge clk_500M)
            dataIn = encoder_vectors(N);

      //Flush Pipeline
      repeat(3)
         #CLOCK_500M_PERIOD;
      
      $stop;
   end
endmodule
