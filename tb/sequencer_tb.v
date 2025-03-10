//Sequencer Test Harness
//Hayden Martz

`timescale 1ns/100ps

module sequencer_tb;
   parameter CLOCK_500M_PERIOD = 2;
   parameter BITS_WIDTH        = 5;
   parameter RUN_TIME_CYCLES   = 100;

   //Inputs into MUT
   reg clk_500M, rst;

   //Outputs from MUT
   wire [BITS_WIDTH-1:0] dataOut;

   ///////////////////////////////////////////////////////////////////
   //RTL MUT
   sequencer #(.BITS_WIDTH(BITS_WIDTH))
      sequencer_mut(
         .clk(clk_500M),
         .rst(     rst),
         .data(dataOut)
   );

   ////////////////////////////////////////////////////////////////////
   //Create Clock
   initial clk_500M = 0;
   always
      #(CLOCK_500M_PERIOD/2) clk_500M = !clk_500M;

   ////////////////////////////////////////////////////////////////////
   //Apply Stimulus to MUT
   initial begin
      //Setup and Hold Reset:
      rst =0;
      #CLOCK_500M_PERIOD rst = 1; //Active High
      #CLOCK_500M_PERIOD rst = 0;

      #((RUN_TIME_CYCLES-1)*CLOCK_500M_PERIOD) rst = 1;
      #(CLOCK_500M_PERIOD);
      $stop;
   end
endmodule

