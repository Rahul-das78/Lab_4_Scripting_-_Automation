`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2025 16:05:59
// Design Name: 
// Module Name: COUNTER
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






module top_COUNTER(count, clk, reset);

input wire clk;
input wire reset;
output reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 4'b0000; 
        else
            count <= count + 1;
    end

endmodule

