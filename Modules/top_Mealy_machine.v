`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2025 01:14:24
// Design Name: 
// Module Name: Mealy_machine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_Mealy_machine( in,clk,reset,out );
    input in,clk,reset;
    output reg out;
    
    parameter [2:0] s0=0, s1=1, s2=2, s3=3, s4=4;
    reg [2:0] PS;
    
    always @(posedge clk or posedge reset)
        begin
            if(reset) 
                PS <= s0;
            else begin
          case (PS)
            s0: begin
                out <= 0;
                PS <= in ? s1 : s0;
            end
            s1: begin
                out <= 0;
                PS <= in ? s1 : s2;
            end
            s2: begin
                out <= 0;
                PS <= in ? s1 : s3;
            end
            s3: begin
                out <= 0;
                PS <= in ? s4 : s0;
            end
            s4: begin
                out <= in ? 1 : 0;
                PS <= in ? s1 : s2;
            end
            default: begin
                out = 0;
                PS = s0;
            end
            endcase
            end
        end
endmodule
