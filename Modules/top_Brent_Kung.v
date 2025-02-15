`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.02.2025 11:09:32
// Design Name: 
// Module Name: Brent_Kung
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

module AND(out,a,b);
    input a,b;
    output out;
    and #1 (out, a, b);
endmodule

module XOR(out,a,b);
    input a,b;
    output out;
    xor #1 (out, a, b);
endmodule

module XOR3(out,a,b,c);
    input a,b,c;
    output out;
    xor #1 (out, a, b, c);
endmodule

module a_or_bc (out,a,b,c);
    input a,b,c;
    output out;
    and (g, b, c);
    or #1 (out, a, g);
endmodule



module majority(out,a,b,c);
    input a,b,c;
    output out;
    and (g, a, b);
    and (h, b, c);
    and (i, c, a);
    or #1 (out, g, h, i);
endmodule

module top_Brent_Kung(
    input [31:0] a,b ,
    input cin,
    output [32:0] sum
//    output cout
    
    );
    
    wire [31:1] carry;
    
    wire [31:0] P0;
    wire [15:0] P1;
    wire [7:0] P2;
    wire [3:0] P3;
    wire [1:0] P4;
    wire P5;
    
    wire [31:0] G0;
    wire [15:0] G1;
    wire [7:0] G2;
    wire [3:0] G3;
    wire [1:0] G4;
    wire G5;
    //wire [31:1] c_internal;
    
    // order 0
    // G0[0]
    majority m1(G0[0],a[0],b[0],cin);
    
    // G0 [31:1]
    genvar i;
    generate
        begin
            for (i=0;i<31;i=i+1) begin
                AND ad1(G0[i+1],a[i+1],b[i+1]);
            end
        end
    endgenerate
    
    
    // P0 [31:0]
    genvar j,k,l,m,n;
    generate
        begin
            for (j=0;j<32;j=j+1) begin
                XOR xr1(P0[j],a[j],b[j]);
            end
        end
    endgenerate
    
    // P1 [15:0]
    generate
        begin
            for (k=0;k<16;k=k+1) begin
                AND ad2(P1[k],P0[2*k],P0[2*k+1]);
            end
        end
    endgenerate
    // P2 [7:0]
    generate
        begin
            for (l=0;l<8;l=l+1) begin
                AND ad3(P2[l],P1[2*l],P1[2*l+1]);
            end
        end
    endgenerate
    // P3 [3:0]
    generate
        begin
            for (m=0;m<4;m=m+1) begin
                AND ad4(P3[m],P2[2*m],P2[2*m+1]);
            end
        end
    endgenerate
    // P4 [1:0]
    generate
        begin
            for (n=0;n<2;n=n+1) begin
                AND ad5(P4[n],P3[2*n],P3[2*n+1]);
            end
        end
    endgenerate
    
    AND a78(P5,P4[1],P4[0]);
    
    // G1 [15:0]
    genvar o,p,q,r;
    generate
        begin
            for (o=0;o<16;o=o+1) begin
                a_or_bc acb1(G1[o],G0[o*2+1],P0[o*2+1],G0[o*2]);
            end
        end
    endgenerate
    
    // G2 [7:0]
    generate
        begin
            for (p=0;p<8;p=p+1) begin
                a_or_bc acb2(G2[p],G1[p*2+1],P1[p*2+1],G1[p*2]);
            end
        end
    endgenerate
    
    // G3 [3:0]
    generate
        begin
            for (q=0;q<4;q=q+1) begin
                a_or_bc acb3(G3[q],G2[q*2+1],P2[q*2+1],G2[q*2]);
            end
        end
    endgenerate
    
    // G4 [1:0]
    generate
        begin
            for (r=0;r<2;r=r+1) begin
                a_or_bc acb4(G4[r],G3[r*2+1],P3[r*2+1],G3[r*2]);
            end
        end
    endgenerate
    
    // G5
    a_or_bc abc1(G5,G4[1],P4[1],G4[0]);
    
    // generating the carries at each pair c1, c2,c4,c8,c16, cout
    
    
    a_or_bc abc2(carry[1], G0[0],P0[0],cin);
    a_or_bc abc3(carry[2], G1[0],P1[0],cin);
    a_or_bc abc4(carry[4], G2[0],P2[0],cin);
    a_or_bc abc5(carry[8], G3[0],P3[0],cin);
    a_or_bc abc6(carry[16], G4[0],P4[0],cin);
    a_or_bc abc7(sum[32], G5,P5,cin);
    
    
    a_or_bc abc8(carry[3],G0[2], P0[2], carry[2]);
    
    a_or_bc abc9(carry[5],G0[4], P0[4], carry[4]);
    a_or_bc abc10(carry[6],G1[2], P1[2], carry[4]);
    a_or_bc abc11(carry[7],G0[6], P0[6], carry[6]);
    
    a_or_bc abc12(carry[9],G0[8], P0[8], carry[8]);
    a_or_bc abc13(carry[10],G1[4], P1[4], carry[8]);
    a_or_bc abc14(carry[12],G2[2], P2[2], carry[8]);
    
    a_or_bc abc15(carry[11],G0[10], P0[10], carry[10]);
    a_or_bc abc16(carry[13],G0[12], P0[12], carry[12]);
    
    a_or_bc abc17(carry[14],G1[6], P1[6], carry[12]);
    
    a_or_bc abc18(carry[17],G0[16], P0[16], carry[16]);
    
    a_or_bc abc19(carry[18],G1[8], P1[8], carry[16]);
    
    a_or_bc abc20(carry[20],G2[4], P2[4], carry[16]);
    
    a_or_bc abc21(carry[24],G3[2], P3[2], carry[16]);
    
    a_or_bc abc22(carry[15],G0[14], P0[14], carry[14]);
    
    a_or_bc abc23(carry[19],G0[18], P0[18], carry[18]);
    
    a_or_bc abc24(carry[21],G0[20], P0[20], carry[20]);
    
    a_or_bc abc25(carry[22],G1[10], P1[10], carry[20]);
    
    a_or_bc abc26(carry[25],G0[24], P0[24], carry[24]);
    
    a_or_bc abc27(carry[26],G1[12], P1[12], carry[24]);
    
    a_or_bc abc28(carry[28],G2[6], P2[6], carry[24]);
    
    a_or_bc abc29(carry[23],G0[22], P0[22], carry[22]);
    a_or_bc abc30(carry[27],G0[26], P0[26], carry[26]);
    
    a_or_bc abc31(carry[29],G0[28], P0[28], carry[28]);
    a_or_bc abc32(carry[30],G1[14], P1[14], carry[28]);
    
    a_or_bc abc33(carry[31],G0[30], P0[30], carry[30]);
    
    
    // calculating sum
    genvar pq;
    XOR3 x1(sum[0],a[0],b[0],cin);
    generate begin
        for (pq=1;pq<32;pq=pq+1) begin
            XOR3 xr5(sum[pq],a[pq],b[pq],carry[pq]);
        end
    end
    endgenerate
    
        
    
endmodule
