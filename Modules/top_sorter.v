`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2025 23:05:51
// Design Name: 
// Module Name: sorter
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


module top_sorter(
    input [7:0]A,B,C,
    output reg [7:0]out1,out2,out3,
    wire GT1,GT2,GT3, LT1,LT2,LT3, EQ1,EQ2,EQ3
    );
 // Generating the control signals
 comparator C1 (A,B, GT1,LT1,EQ1); // GT = Greater Than, LT = Lesser Than, EQ = Equal 
 comparator C2 (B,C, GT2,LT2,EQ2);
 comparator C3 (C,A, GT3,LT3,EQ3);
 
 // Sorting with the help of control signals
 
 always @(*) 
 begin
    // FOR A>B>=C
    if (GT1 & (GT2|EQ2)) begin // if A>B and B>=C
        out1 = A;
        out2 = B;
        out3 = C;
    end 
    // FOR A>C>B
    else if(GT1 & LT2 & LT3) begin // if A>B and B<C and C<A
        out1 = A;
        out2 = C;
        out3 = B;
    end
    // FOR B>A>=C
    else if(LT1 & (LT3|EQ3)) begin // if A<B and C<=A
        out1 = B;
        out2 = A;
        out3 = C;
    end
    // FOR B>C>A
    else if(LT1 & GT2 & GT3) begin // if A<B and B>C and C>A
        out1 = B;
        out2 = C;
        out3 = A;
    end
    // FOR C>A>=B
    else if((GT1|EQ1) & GT3) begin // if A>=B and C>A
        out1 = C;
        out2 = A;
        out3 = B;
    end
    // FOR C>B>A
    else if(LT1 & LT2) begin // if A<B and B<C 
        out1 = C;
        out2 = B;
        out3 = A;
    end
    else begin
        out1 = A;
        out2 = B;
        out3 = C;
    end
    
end
 
endmodule

module comparator(
    input [7:0]a, 
    input [7:0]b,
    output GT,LT,EQ);
    
    assign GT = (a>b) ? 1 : 0;
    assign LT = (a<b) ? 1 : 0;
    assign EQ = (a==b) ? 1 : 0;
    
endmodule
