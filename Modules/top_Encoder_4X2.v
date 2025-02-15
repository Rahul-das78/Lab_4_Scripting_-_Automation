`timescale 1ns / 1ps


module top_Encoder_4X2( 
input [3:0] I1,
output reg[1:0] Y);

always@(I1)
    begin
        casex(I1)
            
            4'b0000 : Y = 2'bXX;
            4'b0001 : Y = 2'b00;
            4'b001X : Y = 2'b01;
            4'b01XX : Y = 2'b10;
            4'b1XXX : Y = 2'b11;
            // all possible combinations of I are covered and Y is defined for them
            default : Y = 2'b00;
            
        endcase
    end
endmodule
