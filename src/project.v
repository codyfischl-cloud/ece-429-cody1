`default_nettype none

module tt_um_codyfischl (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire [15:0] product;

    assign product = ui_in * uio_in;

    assign uo_out  = product[7:0];
    assign uio_out = product[15:8];
    assign uio_oe  = 8'b11111111;

    wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
