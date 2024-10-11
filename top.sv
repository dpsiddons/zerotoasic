// Random pulse generator
// (C)2024 Pete Siddons
// 

`timescale 1ns / 1ps

module top (
    input  rst,
    input  clk,
    output reg pout
    );

    logic [31:0] cnt = 32'haaaaaaaa;  // 32-bit shift register
    logic [31:0] thresh = 32'h00100000;
    logic fb;
    logic pulse;

    always_ff @(posedge clk)
    begin
        fb <= cnt[31] ^ cnt[21] ^ cnt[1] ^ cnt[0];
        cnt <= {cnt[30:0],fb};
        if (cnt<thresh)
        begin
            pulse <= 1'b1;   
        end
        else
            pulse <= 1'b0;
    end

   logic [4:0] counter;
   logic state=1'b0;
   
   always_ff @(posedge clk)
   begin
       case (state)
          1'b0:
          begin
              pout <= 1'b0;
              if (pos_edge_pulse)
	      begin
                  counter <= 5'b11111;
                  state <= 1'b1;
              end
          end
        
          1'b1:
          begin
              counter--;
              pout <= 1'b1;
              if (counter==1)
                  state <= 1'b0;
          end 
      endcase  
  end   
  
  logic sig_dly;
  
  always_ff @(posedge clk)
  begin    
      sig_dly <= pulse;
  end
  
  assign pos_edge_pulse = pulse & ~sig_dly;
  
endmodule
  
