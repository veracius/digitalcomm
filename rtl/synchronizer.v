//Synchronizes from one clock domain to the next using a basic recirculation mus synchronizer.
//Registers are wired to eachother with a mux in between. Mux control re-uses output of destination side unless control pulse is asserted.
//Control pulse passes through a basic 2FF synchronizer
//Intend dest clock to a be an even multiple of src, so may be overkill? Not sure.

//Need to study synchronizers more. 
//Hayden Martz

`timescale 1ns/100ps //for behavioral sim

module synchronizer
   #( parameter BITS_WIDTH = 5)
   (  input  clk_src, clk_dest, rst, ctrl,
      input  [BITS_WIDTH-1:0] data_src,
      output [BITS_WIDTH-1:0] data_dest
   );

   //Registers
   reg [BITS_WIDTH-1:0] data_src_reg;  //Registers input data. Potentially redundant/removable
   reg [BITS_WIDTH-1:0] data_dest_reg; //Registers output data
   reg ctrl_reg;                       //For this cdc, ctrl is just the slow(er) src clock (FF q)
   reg sync1_reg, sync2_reg;           //Dest clock domain synchronizers (FF q)

   //Wires
   wire [BITS_WIDTH-1:0] data_dest_d; //Combination MUX into dest sync reg (FF q)

   //Source Side Data Register
   always @(posedge clk_src) begin: src_data_proc
      if(rst == 1'b1) begin
         data_src_reg <= {BITS_WIDTH{1'b0}};
      end else begin
         data_src_reg <= data_src;
      end
   end

   //Mux
   assign data_dest_d = (sync2_reg) ? data_src_reg: data_dest_reg;

   //Destination Side Data Register
   always @(posedge clk_dest) begin: dest_data_proc
      if(rst == 1'b1) begin
         data_dest_reg <= {BITS_WIDTH{1'b0}};
      end else begin
         data_dest_reg <= data_dest_d;
      end
   end

   //Destination Side Data Register to Output
   assign data_dest = data_dest_reg;

   //Source Side Control Register
   always @(posedge clk_src) begin: ctrl_src_reg_proc
      if(rst == 1'b1) begin
         ctrl_reg <= 1'b0;
      end else begin
         ctrl_reg <= ctrl;
      end
   end

   //Destination Side Control Registers
   always @(posedge clk_dest) begin: sync_dest_reg_proc
      if(rst == 1'b1) begin
         sync1_reg <= 1'b0;
         sync2_reg <= 1'b0;
      end else begin
         sync1_reg <= ctrl_reg;  //Non Blocking
         sync2_reg <= sync1_reg; //Non Blocking should result in this updating a clock cycle after as a second reg, I think?
      end
   end
endmodule   
