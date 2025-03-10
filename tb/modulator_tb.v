//Tests the basic modulator

//Synchronizer Test Harness
//Hayden Martz

`timescale 1ns/100ps

module modulator_tb;
   parameter CLOCK_50M_PERIOD  = 20;
   parameter CLOCK_500M_PERIOD = 2;
   parameter BITS_WIDTH        = 5;
   parameter DIM0_WIDTH        = 2; //Dimension 1 has 4 points
   parameter DIM1_WIDTH        = 2; //Dimension 2 has 4 points
   parameter DIM2_WIDTH        = 1; //Dimension3 has 2 points
   parameter ADC_DEPTH         = 12;
   parameter RUN_TIME_CYCLES   = 25;

   //Inputs into MUT
   reg clk_50M, clk_500M, rst;
   reg [DIM0_WIDTH-1:0] x0;
   reg [DIM1_WIDTH-1:0] x1;
   reg [DIM2_WIDTH-1:0] x2;

   //Outputs from MUT
   wire [ADC_DEPTH-1:0] dataOut;

   //Register Arrays to hold vector dat
   integer N;
   reg [BITS_WIDTH-1:0] encoder_vectors[0:2**BITS_WIDTH-1];

   ///////////////////////////////////////////////////////////////////
   //RTL MUT
   modulator modulator_mut(
         .clk(      clk_500M),
         .rst(           rst),
         .x0(             x0),
         .x1(             x1),
         .x2(             x2),
         .out_sample(dataOut)
   );

   ////////////////////////////////////////////////////////////////////
   //Create Clock
   initial begin
      clk_50M  = 0;
      clk_500M = 0;
   end
   always
      #(CLOCK_50M_PERIOD/2) clk_50M = !clk_50M;
   always
      #(CLOCK_500M_PERIOD/2) clk_500M = !clk_500M;


   ////////////////////////////////////////////////////////////////////
   //Apply Stimulus to MUT
   initial begin
      //Setup and Hold Reset:
      rst =0;
      #CLOCK_50M_PERIOD rst = 1; //Active High
      #CLOCK_50M_PERIOD rst = 0;

      #((RUN_TIME_CYCLES-1)*CLOCK_50M_PERIOD) rst = 1;
      #(CLOCK_50M_PERIOD);
      $stop;
   end

   //Generate Symbol Data
   initial begin
      //Load Vectors into Memory
      $readmemb("/home/f/Documents/projects-local/digitalcomm/vec/encoder.vec", encoder_vectors);

      //Cycle through vectors
      N = 0;
      while(1'b1) begin
         @(posedge clk_50M)
            x0 = encoder_vectors[N][1:0];
            x1 = encoder_vectors[N][3:2];
            x2 = encoder_vectors[N][4:4];
         N = (N == 2**BITS_WIDTH-1) ? 0 : N+1;
      end
   end
endmodule
