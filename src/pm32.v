`timescale 1ns/1ps
`default_nettype none

module pm32 (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [31:0] mc,
    input  wire [31:0] mp,
    output reg  [63:0] p,
    output wire        done
);

    wire pw;

    reg [31:0] Y;
    reg [7:0]  cnt;
    reg [1:0]  state;

    localparam IDLE = 0, RUN = 1, DONE = 2;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else begin
            case (state)
                IDLE:  state <= start ? RUN : IDLE;
                RUN:   state <= (cnt == 64) ? DONE : RUN;
                DONE:  state <= start ? RUN : DONE;
            endcase
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            cnt <= 0;
        else if (state == RUN)
            cnt <= cnt + 1;
        else if (state == IDLE)
            cnt <= 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            Y <= 0;
        else if (start)
            Y <= mp;
        else if (state == RUN)
            Y <= Y >> 1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            p <= 0;
        else if (start)
            p <= 0;
        else if (state == RUN)
	p <= p + (pw << cnt);
    end

    assign done = (state == DONE);

    wire y = (state == RUN) ? Y[0] : 0;

    spm #(.SIZE(32)) u_spm (
        .clk(clk),
        .rst(rst),
        .y(y),
        .x(mc),
        .p(pw)
    );

endmodule
