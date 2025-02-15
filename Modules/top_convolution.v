`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2025 20:09:59
// Design Name: 
// Module Name: convolution
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


module top_convolution(
    input [0 : 8*10*10-1] image,
    input [0 : 8*3*3-1] filter,
    output reg [0 : 20*8*8-1] filtered_image
    );
    
    wire [7:0] img [9:0][9:0];
    wire [7:0] karnel [8:0];
    //wire [19:0] out_img [7:0][7:0];
    
    genvar i,j,k,m,n;
    generate
        begin
            for(i=0;i<10;i=i+1)// i is the tow
            begin
                for(j=0;j<10;j=j+1) // j is the column
                begin
                    assign img[i][j] = image[(i*(80)+j*8):(i*(80)+j*8+7)];
                end
            end
        end
    endgenerate
    generate
        begin
            for(k=0;k<8;k=k+1) 
            begin
                assign karnel[k] = filter[(k*8):(k*8+7)];
            end
        end
    endgenerate
//    generate
//        begin
//            for(m=0;m<8;m=m+1)
//            begin
//                for(n=0;n<8;n=n+1)
//                begin
//                    assign out_img[m][n] = filtered_image[(m*20*8+n*20):(m*20*8+n*20+7)];
//                end
//            end
//        end
        
//    endgenerate
    
    // temporary values
    reg [7:0] img_temp [0:8];
    // note that karnel is always the same
    reg [0:19] out_img_temp;
    
    conv3x3 c0 (.A0(img_temp[0]),.A1(img_temp[1]),.A2(img_temp[2]),.A3(img_temp[3]),.A4(img_temp[4]),
                .A5(img_temp[5]),.A6(img_temp[6]),.A7(img_temp[7]),.A8(img_temp[8]),
    .B0(karnel[0]), .B1(karnel[1]), .B2(karnel[2]), .B3(karnel[3]), .B4(karnel[4]),
    .B5(karnel[5]), .B6(karnel[6]), .B7(karnel[7]), .B8(karnel[8]),

    .out(out_img_temp)
    );
    
    genvar p,q,r;
    generate
    for(p=0;p<8;p=p+1)
        begin
            for(q=0;q<8;q=q+1)
            begin
                always @(*) begin
                        img_temp[0] = img [p][q]; 
                        img_temp[1] = img [p][q+1];
                        img_temp[2] = img [p][q+2];
                        
                        img_temp[3] = img [p+1][q]; 
                        img_temp[4] = img [p+1][q+1];
                        img_temp[5] = img [p+1][q+2];
                        
                        img_temp[6] = img [p+2][q]; 
                        img_temp[7] = img [p+2][q+1];
                        img_temp[8] = img [p+2][q+2];

                    filtered_image[(p*20*8 + q*20) : (p*20*8 + q*20 + 19)] = out_img_temp; 
                end
                end
        end
        
    endgenerate
    
   
endmodule

module conv3x3(
    input [7:0] A0,A1,A2,A3,A4,A5,A6,A7,A8,
    input [7:0] B0,B1,B2,B3,B4,B5,B6,B7,B8,
    output wire [19:0] out );
   
    assign out = (A0*B0)+(A1*B1)+(A2*B2)+(A3*B3)+(A4*B4)+(A5*B5)+(A6*B6)+(A7*B7)+(A8*B8);
    
endmodule
