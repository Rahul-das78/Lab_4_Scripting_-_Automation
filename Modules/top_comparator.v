`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.01.2025 12:08:26
// Design Name: 
// Module Name: comparator
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


module top_comparator(
    input [7:0]a, 
    input [7:0]b,
    output GT,LT,EQ);
    
    assign GT = (a>b) ? 1 : 0;
    assign LT = (a<b) ? 1 : 0;
    assign EQ = (a==b) ? 1 : 0;
    
endmodule
