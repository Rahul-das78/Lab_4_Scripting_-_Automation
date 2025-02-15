`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2025 00:34:32
// Design Name: 
// Module Name: shift_register
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


module top_shift_register(

    input clk,          
    input rst,                  // Reset signal 
    input [2:0] mode,           // mode of operation
    input [7:0] parallel_in,    // data input in parallel
    input serial_in_left,       // Serial data input for left shift
    input serial_in_right,      // Serial data input for right shift
    output reg [7:0] q          // Output 
);

    

    always @(posedge clk or posedge rst) begin  // circuit will change its o/p at both clk edge and reset signal
    //-----------------------------------------------------------------------------------------------------------
        if (rst)                // reset operation active high
            begin
                #5;     // giving a small delay so that after posedge comes o/p will be update after the delay 
                q <= 0; // Reset register to 0
                        // using nonblocking statement 
            end 
    //-----------------------------------------------------------------------------------------------------------
        else begin
            case (mode)
                3'b000: begin   // No shift operation
                   #5;
                    q <= q;     // Maintain the current state
                end
            //---------------------------------------------------------------------------------------------------
                3'b001: begin    // left shift
                    #5;
                    q <= q << 1; // Left shift by 1 position rest padded 0
                    q[0] <= serial_in_left; // previous q[7] is lost
                end
            //---------------------------------------------------------------------------------------------------
                3'b010: begin    // circular left shift 
                    #5;
                    q <= q << 1; // Left shift by 1 position 
                    q[0] <= q[7]; // no data is lost here
                end
            //---------------------------------------------------------------------------------------------------
                3'b011: begin    // right shift
                    #5;
                    q <= q >> 1; // right shift by 1 position rest padded 0
                    q[0] <= serial_in_right; // previous q[0] is lost
                end
            //---------------------------------------------------------------------------------------------------
                3'b100: begin    // circular right shift
                    #5;
                    q <= q >> 1; // right shift by 1 position rest padded 0
                    q[7] <= q[0]; // no data is lost here 
                    end
            //---------------------------------------------------------------------------------------------------
                3'b101: begin   // parallel load
                    #5;
                    q <= parallel_in; // Load parallel data
                end
            //---------------------------------------------------------------------------------------------------
                default: begin
                    #5;
                    q <= q;
                end
            endcase
        end
    end


endmodule
