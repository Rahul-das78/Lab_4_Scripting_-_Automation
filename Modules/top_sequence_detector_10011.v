module top_sequence_detector_10011 (
    input clk,
    input reset,
    input din,
    output reg dout
);

    // Define states using parameter (since Verilog-2001 does not support typedef in RTL)
    parameter S0 = 3'b000, 
              S1 = 3'b001, 
              S2 = 3'b010, 
              S3 = 3'b011, 
              S4 = 3'b100, 
              S5 = 3'b101;

    reg [2:0] state, next_state;

    // State transition on clock edge
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic and output logic
    always @(*) begin
        dout = 0; // Default output is 0
        case (state)
            S0: next_state = din ? S1 : S0;
            S1: next_state = din ? S1 : S2;
            S2: next_state = din ? S3 : S0;
            S3: next_state = din ? S4 : S0;
            S4: begin
                if (din) begin
                    next_state = S5;
                    dout = 1;  // Sequence detected
                end else begin
                    next_state = S2;  // Allow overlapping
                end
            end
            S5: begin
                dout = 1; // Output should be high for one cycle
                next_state = din ? S1 : S2;  // Allow overlapping detection
            end
            default: next_state = S0;
        endcase
    end

endmodule
