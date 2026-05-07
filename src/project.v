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

    // wiring
    wire [31:0] mc = {24'b0, ui_in};
    wire [31:0] mp = {24'b0, uio_in};

    wire [63:0] p;
    wire done;
    reg start;

    // simple start pulse (always running for test)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            start <= 0;
        else
            start <= 1;
    end

    pm32 uut (
        .clk(clk),
        .rst(~rst_n),
        .start(start),
        .mc(mc),
        .mp(mp),
        .p(p),
        .done(done)
    );

    assign uo_out  = p[7:0];   // low bits of product
    assign uio_out = 0;
    assign uio_oe  = 0;

endmodule
