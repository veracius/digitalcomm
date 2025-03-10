//Uses PRBS31 to generate a sequence of n-bit numbers, to be fed into the encoder.
//Takes the n LSbs of the current generated value (register) and wires them to the output.
//PRBS31 = x31+x28+1
//Hayden Martz

`timescale 1ns/100ps //for behavioral sim

module sequencer
   #( parameter BITS_WIDTH =  5,
      parameter PRBS_SIZE  = 32,
      parameter PRBS_SEED  = 32'b1011_0101_0101_0011_1000_1100_1001_1111) //repeatedly rolled a die
   (  input clk, rst,
      output [BITS_WIDTH-1:0] data
   );

   //Creating register to hold current PRBS value
   reg [PRBS_SIZE-1:0] prbs_reg;

   //Reset (Active High) sets reg to SEED; otherwise right shift reg 
   //and insert to PRBS31 bit
   always @(posedge clk) begin: sequencer_proc
      if(rst == 1'b1) begin
         prbs_reg <= PRBS_SEED;
      end else begin
         prbs_reg[PRBS_SIZE-2:0] <=  prbs_reg[PRBS_SIZE-1:1];             //Non-Blocking
         prbs_reg[PRBS_SIZE-1]   <= (prbs_reg[31] ^ prbs_reg[28]) ^ 1'b1; //Non-Blocking; reg won't update till end of process "stage"
      end
   end

   assign data = prbs_reg[BITS_WIDTH-1:0];
endmodule
