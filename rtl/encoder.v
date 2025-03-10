//Generates an Orthogonal basis set of dimension 3, with N_i points per dimension.
//Converts input data from a binary parallel data bus to encoded level values (in binary) for each dimension.
//Hayden Martz

//pretty trivial atm
//Just adds a 1-clock delay. Could remove in future for speed, make combinational only.

//Registering outputs so output drive strengths and input delays are predictable.

`timescale 1ns/100ps //so behavioral sim works

module encoder
   #( parameter BITS_WIDTH = 5, //mod_2(32); 32=4*4*2
      parameter DIM0_WIDTH = 2, //Dimension 1 has 4 points
      parameter DIM1_WIDTH = 2, //Dimension 2 has 4 points
      parameter DIM2_WIDTH = 1) //Dimension3 has 2 points
   (  input clk, rst,
      input      [BITS_WIDTH-1:0] data,
      output [DIM0_WIDTH-1:0] x0,
      output [DIM1_WIDTH-1:0] x1,
      output [DIM2_WIDTH-1:0] x2
   );

   //Creating regs. using output reg... creates Black Boxes during synthesis (critical warning)
   reg [DIM0_WIDTH-1:0] x0_reg;
   reg [DIM1_WIDTH-1:0] x1_reg;
   reg [DIM2_WIDTH-1:0] x2_reg;

   //Convert input bits to output bus
   //Should synth into a synchronous Flip-Flop
   always @(posedge clk) begin: encoder_proc
      if(rst == 1'b1) begin
         x0_reg <= {DIM0_WIDTH{1'b0}};
         x1_reg <= {DIM1_WIDTH{1'b0}};
         x2_reg <= {DIM2_WIDTH{1'b0}};
      end else begin
         x0_reg <= data[DIM0_WIDTH-1:0];
         x1_reg <= data[DIM0_WIDTH+DIM1_WIDTH-1:DIM0_WIDTH];
         x2_reg <= data[BITS_WIDTH-1:DIM0_WIDTH+DIM1_WIDTH];
      end
   end

   assign x0 = x0_reg;
   assign x1 = x1_reg;
   assign x2 = x2_reg;

endmodule