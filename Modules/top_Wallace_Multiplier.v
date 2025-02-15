`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.09.2024 16:53:08
// Design Name: 
// Module Name: Wallace_Multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// Rahul
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



// Half Adder
module HA(Sum, Cout, A, B);

    input A, B;
    output Sum, Cout;
    
    assign Sum = A^B;
    assign Cout = A&B;

endmodule

// Full Adder
module FA(Sum, Cout, A, B, Cin);
    
    input A, B, Cin;
    output Sum, Cout;
    
    assign Sum = A^B^Cin;
    assign Cout = (A&B)|(B&Cin)|(Cin&A);
    
endmodule  


// Carry generator for CLA adder which will be used as fast adder
module Carry_generator(A,B,C); //Cin is not used because for wallace tree implementation we don't need C in at the 1st term
    input [5:0] A;
    input [5:0] B;
    output [6:1] C;         // C is the 6 generated carrys
    wire [5:0] G;
    wire [5:0] P;
    
    // Carry generate
    assign G[0] = A[0]&B[0];
    assign G[1] = A[1]&B[1];
    assign G[2] = A[2]&B[2];
    assign G[3] = A[3]&B[3];
    assign G[4] = A[4]&B[4];
    assign G[5] = A[5]&B[5];
    
    // Carry propagate
    assign P[0] = A[0]^B[0];
    assign P[1] = A[1]^B[1];
    assign P[2] = A[2]^B[2];
    assign P[3] = A[3]^B[3];
    assign P[4] = A[4]^B[4];
    assign P[5] = A[5]^B[5];
    
    // Carry at output
    assign C[1] = G[0]; // Cin = 0
    assign C[2] = G[1] | (P[1]&G[0]);
    assign C[3] = G[2] | (P[2]&G[1]) | (P[2]&P[1]&G[0]);
    assign C[4] = G[3] | (P[3]&G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0]);
    assign C[5] = G[4] | (P[4]&G[3]) | (P[4]&P[3]&G[2]) | (P[4]&P[3]&P[2]&G[1])| (P[4]&P[3]&P[2]&P[1]&G[0]);
    assign C[6] = G[5] | (P[5]&G[4]) | (P[5]&P[4]&G[3]) | (P[5]&P[4]&P[3]&G[2])| (P[5]&P[4]&P[3]&P[2]&G[1])| (P[5]&P[4]&P[3]&P[2]&P[1]&G[0]);
endmodule

// Fast Adder : CLA
module CLA_Adder(A,B,S,Cout);  
    input [5:0] A;    
    input [5:0] B;  
    output [5:0] S;
    output Cout;
    wire [6:1] C; // Cin = 0
    wire [5:0] P;
    Carry_generator gen(.A(A),.B(B),.C(C));
    
    //
    // Carry propagate
    assign P[0] = A[0] ^ B[0];
    assign P[1] = A[1] ^ B[1];
    assign P[2] = A[2] ^ B[2];
    assign P[3] = A[3] ^ B[3];
    assign P[4] = A[4] ^ B[4];
    assign P[5] = A[5] ^ B[5];
    
    // Sum
    assign S[0] = P[0] ;
    assign S[1] = P[1] ^ C[1] ;
    assign S[2] = P[2] ^ C[2] ;
    assign S[3] = P[3] ^ C[3] ;
    assign S[4] = P[4] ^ C[4] ;
    assign S[5] = P[5] ^ C[5] ;
    
    // Carry from the generator
    assign Cout = C[6];
    
endmodule


// Wallace_Multiplier
module top_Wallace_Multiplier( X, Y, Product );
    
    input [3:0] X;
    input [3:0] Y;
    output [7:0] Product;
    
    wire [15:0] PP; // PP = Partial Product
    wire HS1,HC1,HS2,HC2,HS3,HC3,FS1,FC1,FS2,FC2,FS3,FC3;
    wire [5:0] A; // A = {FC3,FS3,HS3,HS2,HS1,PP1}
    wire [5:0] B; // B = {PP[15],HC3,HC2,PP[12],PP[8],PP[4]}
    wire [5:0] S;
    wire Cout;
    
    assign PP[0] = X[0] & Y[0]; //PP[00] = PP[0] MEANS A=0,B=0
    assign PP[1] = X[1] & Y[0]; //PP[01] = PP[1]  A=1,B=0
    assign PP[2] = X[2] & Y[0]; //PP[02] = PP[2] A=2,B=0
    assign PP[3] = X[3] & Y[0]; //PP[03] = PP[3] A=3,B=0
    
    assign PP[4] = X[0] & Y[1]; //PP[10] = PP[4] MEANS A=0,B=1
    assign PP[5] = X[1] & Y[1]; //PP[11] = PP[5] MEANS A=1,B=1
    assign PP[6] = X[2] & Y[1]; //PP[12] = PP[6] MEANS A=2,B=1
    assign PP[7] = X[3] & Y[1]; //PP[13] = PP[7] MEANS A=3,B=1
    
    assign PP[8]  = X[0] & Y[2]; //PP[20] = PP[8] MEANS A=0,B=2
    assign PP[9]  = X[1] & Y[2]; //PP[21] = PP[9] MEANS A=1,B=2
    assign PP[10] = X[2] & Y[2]; //PP[22] = PP[10] MEANS A=2,B=2
    assign PP[11] = X[3] & Y[2]; //PP[23] = PP[11] MEANS A=3,B=2
    
    assign PP[12] = X[0] & Y[3]; //PP[30] = PP[12] MEANS A=0,B=3
    assign PP[13] = X[1] & Y[3]; //PP[31] = PP[13] MEANS A=1,B=3
    assign PP[14] = X[2] & Y[3]; //PP[32] = PP[14] MEANS A=2,B=3
    assign PP[15] = X[3] & Y[3]; //PP[33] = PP[15] MEANS A=3,B=3
    
    
    // WALLACE TREE ROW REDUCTION STEP 1
    HA HA1(.Sum(HS1),.Cout(HC1),.A(PP[5]),.B(PP[2]));
    FA FA1(.Sum(FS1),.Cout(FC1),.A(PP[3]),.B(PP[6]),.Cin(PP[9]));
    FA FA2(.Sum(FS2),.Cout(FC2),.A(PP[7]),.B(PP[10]),.Cin(PP[13]));
    // STEP 2
    HA HA2(.Sum(HS2),.Cout(HC2),.A(HC1),.B(FS1));
    HA HA3(.Sum(HS3),.Cout(HC3),.A(FS2),.B(FC1));
    FA FA3(.Sum(FS3),.Cout(FC3),.A(FC2),.B(PP[11]),.Cin(PP[14]));
    // STEP 3 USING FAST ADDER CLA ADDER
    assign A = {FC3   ,FS3,HS3,HS2   ,HS1  ,PP[1]};
    assign B = {PP[15],HC3,HC2,PP[12],PP[8],PP[4]};
    CLA_Adder fastadd(.A(A),.B(B),.S(S),.Cout(Cout)); 
    
    // Result
    assign Product = {Cout,S,PP[0]};
    
    
endmodule
