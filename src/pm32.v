`timescale 1ns/1ps
`default_nettype none

module pm32 (
    input wire         clk,
    input wire         rst,
    input wire         start,
    input wire [31:0]  mc,
    input wire [31:0]  mp,
    output reg [63:0]  p,
    output wire        done
);

    reg [31:0] A, B;
    reg [63:0] acc;
    reg [5:0]  cnt;

    localparam IDLE = 2'b00,
               RUN  = 2'b01,
               DONE = 2'b10;

    reg [1:0] state, nstate;

    // ---------------- STATE ----------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= nstate;
    end

    always @(*) begin
        nstate = state;

        case (state)
            IDLE: if (start) nstate = RUN;

            RUN:  if (cnt == 32) nstate = DONE;

            DONE: if (start) nstate = RUN;
        endcase
    end

    // ---------------- COUNTER ----------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            cnt <= 0;
        else if (state == RUN)
            cnt <= cnt + 1;
        else
            cnt <= 0;
    end

    // ---------------- MULTIPLY ----------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            B <= 0;
            acc <= 0;
        end
        else if (state == IDLE && start) begin
            A <= mc;
            B <= mp;
            acc <= 0;
        end
        else if (state == RUN) begin
            if (B[0])
                acc <= acc + (A << cnt);

            B <= B >> 1;
        end
    end

    // ---------------- OUTPUT ----------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            p <= 0;
        else if (state == DONE)
            p <= acc;
    end

    assign done = (state == DONE);

endmodule

`default_nettype wire
