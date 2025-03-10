//Takes a 5 bit input symbol vector and uses sampling to create a 12-bit output (for a DAC)
//ASSUMES INPUT DATA IS HELD FOR FULL SAMPLE PERIOD. Reduces overhead in this module; but makes 
//rest of design more fragile. Make sure input clock for this a factor of SAMPLES_PER_SYMBOL
//greater than the clock for the encoder/feed logic.
//For DIM=3
//Not sure the selected basis waveforms are orthogonal. Ran out of time to check, will see?
//they're similar to QAM, so I would expect them to work. Not sure the one I added will, though.
//Hayden Martz

`timescale 1ns/100ps //for sim

module modulator
   #( parameter DIM0_WIDTH = 2, //Dimension 1 has 4 points
      parameter DIM1_WIDTH = 2, //Dimension 2 has 4 points
      parameter DIM2_WIDTH = 1) //Dimension3 has 2 points
      parameter SAMPLES_PER_SYMBOL = 10, //num samples between 0 and T
      parameter COUNTER_SIZE       = 4,  //max(log_2(SAMPLES_PER_SYMBOL))
      parameter ADC_DEPTH          = 12,
      parameter ADC_ZERO_OFFSET    = ADC_DEPTH'b1000_0000_0000) //Depends on Circuit/ADC
   (  input clk, rst,
      input  [DIM0_WIDTH-1:0] x0,
      input  [DIM1_WIDTH-1:0] x1,
      input  [DIM2_WIDTH-1:0] x2,
      output [ADC_DEPTH-1:0] out_sample
   );

   //Waveform Sample Memory
   reg signed [ADC_DEPTH-1:0] basis0_mem [1:SAMPLES_PER_SYMBOL];
   reg signed [ADC_DEPTH-1:0] basis1_mem [1:SAMPLES_PER_SYMBOL];
   reg signed [ADC_DEPTH-1:0] basis2_mem [1:SAMPLES_PER_SYMBOL];

   //Control & Intermediary Signals
   reg [COUNTER_SIZE-1:0] sample_index_reg;
   reg [ADC_DEPTH-1:0] psi0_reg;
   reg [ADC_DEPTH-1:0] psi1_reg;
   reg [ADC_DEPTH-1:0] psi2_reg;
   reg [ADC_DEPTH-1:0] mixed_reg; //holdmixed datal, wired to output
   //Initialize the Memory
   initial begin
      $readmemh("./vec/basis0.mem", basis0_mem); //(1/3)sinc(t/T)sin(2πt/T)
      $readmemh("./vec/basis1.mem", basis1_mem); //(1/3)sinc(t/T)sin(2πt/T+π/2)
      $readmemh("./vec/basis2.mem", basis2_mem); //(1/3)sinc(t/T)sin(2πt/T-π/2)
   end

   //Control Signal: Sample Index Register
   always @(posedge clk) begin: index_proc
      if(rst == 1'b1) begin
         sample_index_reg <= (COUNTER_SIZE-1)'d1;
      end else begin
         sample_index_reg <= (sample_index_reg == 10) ? 1 : sample_index_reg + 1;
      end
   end

   //Generate each vector component's waveform sample
   //Tried to avoid multipliers. Perhaps shouldn't.
   always @(posedge clk) begin: phi_modulation_proc
      if(rst == 1'b1) begin
         psi0_reg <= {ADC_DEPTH-1{1'b0}};
         psi1_reg <= {ADC_DEPTH-1{1'b0}};
         psi2_reg <= {ADC_DEPTH-1{1'b0}};
      end else begin
         psi0_reg <= (x0[1]?basis0_mem[sample_index_reg]>>>1:0) + (x0[0]?basis0_mem[sample_index_reg]>>>2:0);
         psi1_reg <= (x1[1]?basis1_mem[sample_index_reg]>>>1:0) + (x1[0]?basis1_mem[sample_index_reg]>>>2:0);
         psi2_reg <= (x2[1]?basis2_mem[sample_index_reg]>>>1:0) + (x2[0]?basis2_mem[sample_index_reg]>>>2:0);
      end
   end

   always @(posedge clk) begin: mixing_proc
      if(rst == 1'b1) begin
         mixed_reg <= 0;
      end else begin
         mixed_reg <= psi0_reg + psi1_reg + psi2_reg + ADC_ZERO_OFFSET;
      end
   end

   assign out_sample = mixed_reg;
endmodule
