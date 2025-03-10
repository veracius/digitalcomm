//Synchronizer Test Harness
//Hayden Martz

`timescale 1ns/100ps

module synchronizer_tb;
   parameter CLOCK_500M_PERIOD = 2;
   parameter CLOCK_100M_PERIOD = 10;
   parameter BITS_WIDTH        = 5;
   parameter RUN_TIME_CYCLES   = 25;

   //Inputs into MUT
   reg clk_100M, clk_500M, rst;
   reg [BITS_WIDTH-1:0] dataIn;

   //Outputs from MUT
   wire [BITS_WIDTH-1:0] dataOut;

   //Register Arrays to hold vector dat
   integer N;
   reg [BITS_WIDTH-1:0] encoder_vectors[0:2**BITS_WIDTH-1];

   ///////////////////////////////////////////////////////////////////
   //RTL MUT
   synchronizer #(.BITS_WIDTH(BITS_WIDTH))
      synchronizer_mut(
         .clk_src( clk_100M),
         .clk_dest(clk_500M),
         .rst(          rst),
         .ctrl(    clk_100M),
         .data_src(  dataIn),
         .data_dest(dataOut)
   );

   ////////////////////////////////////////////////////////////////////
   //Create Clock
   initial begin
      clk_100M = 0;
      clk_500M = 0;
   end
   always
      #(CLOCK_100M_PERIOD/2) clk_100M = !clk_100M;
   always
      #(CLOCK_500M_PERIOD/2) clk_500M = !clk_500M;


   ////////////////////////////////////////////////////////////////////
   //Apply Stimulus to MUT
   initial begin
      //Setup and Hold Reset:
      rst =0;
      #CLOCK_100M_PERIOD rst = 1; //Active High
      #CLOCK_100M_PERIOD rst = 0;

      #((RUN_TIME_CYCLES-1)*CLOCK_100M_PERIOD) rst = 1;
      #(CLOCK_100M_PERIOD);
      $stop;
   end

   //Generate Symbol Data
   initial begin
      //Load Vectors into Memory
      $readmemb("/home/f/Documents/projects-local/digitalcomm/vec/encoder.vec", encoder_vectors);

      //Cycle through vectors
      N = 0;
      while(1'b1) begin
         @(posedge clk_100M)
            dataIn = encoder_vectors[N];
         N = (N == 2**BITS_WIDTH-1) ? 0 : N+1;
      end
   end
endmodule
